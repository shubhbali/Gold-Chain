import { execFile } from 'node:child_process';
import { promises as fs } from 'node:fs';
import { promisify } from 'node:util';
import { EVENT_TOPICS, normalizeRouteId } from './constants.js';

const execFileAsync = promisify(execFile);
const BRIDGE_MESSAGE_TYPEHASH = '0xbd96b36be634fe104cbb12f9f0e5ff814cff6ae76dcd6f361b0557d0a016bc82';

function assertAddress(value, name) {
  if (typeof value !== 'string' || !/^0x[a-fA-F0-9]{40}$/.test(value)) throw new Error(`${name} must be an EVM address`);
  return value;
}

function assertBytes32(value, name) {
  if (typeof value !== 'string' || !/^0x[a-fA-F0-9]{64}$/.test(value)) throw new Error(`${name} must be bytes32`);
  return value;
}

function strip0x(value) { return String(value).startsWith('0x') ? String(value).slice(2) : String(value); }
function topicAddress(topic) { return `0x${strip0x(topic).slice(24)}`; }
function topicUint(topic) { return Number(BigInt(topic)); }
function topicBytes32(topic) { return assertBytes32(topic, 'topic'); }
function word(data, index) { return `0x${strip0x(data).slice(index * 64, (index + 1) * 64)}`; }
function dataAddress(data, index) { return `0x${strip0x(word(data, index)).slice(24)}`; }
function dataUint(data, index) { return BigInt(word(data, index)); }
function lower(value) { return String(value).toLowerCase(); }

async function rpc(rpcUrl, method, params = []) {
  const response = await fetch(rpcUrl, {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ jsonrpc: '2.0', id: 1, method, params }),
  });
  if (!response.ok) throw new Error(`${method} HTTP ${response.status}`);
  const body = await response.json();
  if (body.error) throw new Error(`${method} RPC error ${body.error.message ?? JSON.stringify(body.error)}`);
  return body.result;
}

async function cast(args, options = {}) {
  try {
    const { stdout } = await execFileAsync('cast', args, {
      ...options,
      maxBuffer: 1024 * 1024,
      env: { ...process.env, ...(options.env ?? {}) },
    });
    return stdout.trim();
  } catch (error) {
    error.message = String(error.message).replace(/0x[a-fA-F0-9]{64}/g, '[REDACTED_PRIVATE_KEY]');
    throw error;
  }
}

async function abiEncode(types, values) {
  return cast(['abi-encode', `f(${types.join(',')})`, ...values.map(String)]);
}

async function keccak(encoded) {
  return cast(['keccak', encoded]);
}

async function hashAbi(types, values) {
  return keccak(await abiEncode(types, values));
}

async function bridgeMessageHash(message) {
  const routeHash = await hashAbi(
    ['uint256', 'uint256', 'address', 'address', 'uint256', 'address'],
    [message.sourceChainId, message.destinationChainId, message.sourceBridge, message.destinationBridge, message.routeId, message.token],
  );
  const transferHash = await hashAbi(
    ['address', 'address', 'uint256', 'uint256'],
    [message.sender, message.recipient, message.amount.toString(), message.nonce.toString()],
  );
  const sourceHash = await hashAbi(
    ['uint256', 'uint256', 'bytes32', 'uint256'],
    [message.sourceBlockNumber, message.signerSetVersion, message.txHash, message.logIndex],
  );
  return hashAbi(['bytes32', 'bytes32', 'bytes32', 'bytes32', 'uint8'], [BRIDGE_MESSAGE_TYPEHASH, routeHash, transferHash, sourceHash, message.direction]);
}

async function readPrivateKey(keyPath) {
  const key = (await fs.readFile(keyPath, 'utf8')).trim();
  if (!/^0x[a-fA-F0-9]{64}$/.test(key)) throw new Error(`invalid private key in ${keyPath}`);
  return key;
}

function castArray(values) {
  return `[${values.join(',')}]`;
}

function blockNumber(log) { return Number(BigInt(log.blockNumber)); }
function logIndex(log) { return Number(BigInt(log.logIndex)); }

export class LiveEvmBridgeClient {
  constructor({ rpcUrl, keyPath, sourceChainId, destinationChainId, rootCustodyAddress, childBridgeAddress, routes, signerSetVersion = 1, side }) {
    if (!['ethereum', 'goldChain'].includes(side)) throw new Error('side must be ethereum or goldChain');
    this.rpcUrl = rpcUrl;
    this.keyPath = keyPath;
    this.sourceChainId = Number(sourceChainId);
    this.destinationChainId = Number(destinationChainId);
    this.rootCustodyAddress = assertAddress(rootCustodyAddress, 'rootCustodyAddress');
    this.childBridgeAddress = assertAddress(childBridgeAddress, 'childBridgeAddress');
    this.routes = routes;
    this.signerSetVersion = Number(signerSetVersion);
    this.side = side;
  }

  async getHeadBlock() {
    return Number(BigInt(await rpc(this.rpcUrl, 'eth_blockNumber')));
  }

  async getDeposits({ fromBlock = 0 }) {
    if (this.side !== 'ethereum') throw new Error('getDeposits only valid for ethereum side');
    const logs = await rpc(this.rpcUrl, 'eth_getLogs', [{
      fromBlock: `0x${BigInt(fromBlock).toString(16)}`,
      toBlock: 'latest',
      address: this.rootCustodyAddress,
      topics: [EVENT_TOPICS.DEPOSITED],
    }]);
    return Promise.all(logs.map((log) => this.decodeDeposit(log)));
  }

  async getWithdrawals({ fromBlock = 0 }) {
    if (this.side !== 'goldChain') throw new Error('getWithdrawals only valid for goldChain side');
    const logs = await rpc(this.rpcUrl, 'eth_getLogs', [{
      fromBlock: `0x${BigInt(fromBlock).toString(16)}`,
      toBlock: 'latest',
      address: this.childBridgeAddress,
      topics: [EVENT_TOPICS.WITHDRAWAL_INITIATED],
    }]);
    return Promise.all(logs.map((log) => this.decodeWithdrawal(log)));
  }

  async decodeDeposit(log) {
    const depositId = topicBytes32(log.topics[1]);
    const routeId = topicUint(log.topics[2]);
    const route = this.routes[String(routeId)] ?? this.routes[routeId];
    if (!route) throw new Error(`unconfigured deposit route ${routeId}`);
    const event = {
      eventName: 'Deposited',
      topic0: log.topics[0],
      messageId: depositId,
      depositId,
      routeId,
      from: topicAddress(log.topics[3]),
      goldRecipient: dataAddress(log.data, 0),
      amount: dataUint(log.data, 1),
      sourceChainId: this.sourceChainId,
      emitterAddress: this.rootCustodyAddress,
      sourceBlockNumber: blockNumber(log),
      blockNumber: blockNumber(log),
      blockHash: log.blockHash,
      txHash: log.transactionHash,
      logIndex: logIndex(log),
      signerSetVersion: this.signerSetVersion,
      symbol: route.symbol,
    };
    event.signatures = [await this.signMessage({
      sourceChainId: this.sourceChainId,
      destinationChainId: this.destinationChainId,
      sourceBridge: this.rootCustodyAddress,
      destinationBridge: this.childBridgeAddress,
      routeId,
      token: route.rootToken,
      sender: event.from,
      recipient: event.goldRecipient,
      amount: event.amount,
      nonce: BigInt(event.depositId),
      sourceBlockNumber: event.sourceBlockNumber,
      signerSetVersion: event.signerSetVersion,
      txHash: event.txHash,
      logIndex: event.logIndex,
      direction: 0,
    })];
    return event;
  }

  async decodeWithdrawal(log) {
    const withdrawalId = topicBytes32(log.topics[1]);
    const routeId = topicUint(log.topics[2]);
    const route = this.routes[String(routeId)] ?? this.routes[routeId];
    if (!route) throw new Error(`unconfigured withdrawal route ${routeId}`);
    const event = {
      eventName: 'WithdrawalInitiated',
      topic0: log.topics[0],
      messageId: withdrawalId,
      withdrawalId,
      routeId,
      account: topicAddress(log.topics[3]),
      ethereumRecipient: dataAddress(log.data, 0),
      amount: dataUint(log.data, 1),
      sourceChainId: this.sourceChainId,
      emitterAddress: this.childBridgeAddress,
      sourceBlockNumber: blockNumber(log),
      blockNumber: blockNumber(log),
      blockHash: log.blockHash,
      txHash: log.transactionHash,
      logIndex: logIndex(log),
      signerSetVersion: this.signerSetVersion,
      symbol: route.symbol,
    };
    event.signatures = [await this.signMessage({
      sourceChainId: this.sourceChainId,
      destinationChainId: this.destinationChainId,
      sourceBridge: this.childBridgeAddress,
      destinationBridge: this.rootCustodyAddress,
      routeId,
      token: route.rootToken,
      sender: event.account,
      recipient: event.ethereumRecipient,
      amount: event.amount,
      nonce: BigInt(event.withdrawalId),
      sourceBlockNumber: event.sourceBlockNumber,
      signerSetVersion: event.signerSetVersion,
      txHash: event.txHash,
      logIndex: event.logIndex,
      direction: 1,
    })];
    return event;
  }

  async signMessage(message) {
    const privateKey = await readPrivateKey(this.keyPath);
    const digest = await bridgeMessageHash(message);
    return cast(['wallet', 'sign', '--no-hash', '--private-key', privateKey, digest]);
  }

  async isDepositFinalized({ depositId }) {
    const value = await cast(['call', '--rpc-url', this.rpcUrl, this.childBridgeAddress, 'finalizedDeposits(bytes32)(bool)', assertBytes32(depositId, 'depositId')]);
    return value === 'true';
  }

  async isWithdrawalFinalized({ withdrawalId }) {
    const value = await cast(['call', '--rpc-url', this.rpcUrl, this.rootCustodyAddress, 'finalizedWithdrawals(bytes32)(bool)', assertBytes32(withdrawalId, 'withdrawalId')]);
    return value === 'true';
  }

  async finalizeDeposit({ depositId, routeId, amount, recipient, proof }) {
    const privateKey = await readPrivateKey(this.keyPath);
    const gasArgs = this.rpcUrl.includes('127.0.0.1') || this.rpcUrl.includes('localhost') ? ['--legacy', '--gas-price', '1000000000'] : [];
    return cast([
      'send', '--rpc-url', this.rpcUrl, ...gasArgs, '--private-key', privateKey, this.childBridgeAddress,
      'finalizeDeposit(bytes32,uint256,uint256,address,(address,address,uint256,bytes32,uint256,uint256,bytes[]))',
      assertBytes32(depositId, 'depositId'), String(normalizeRouteId(routeId)), amount.toString(), assertAddress(recipient, 'recipient'),
      `(${assertAddress(proof.rootToken, 'rootToken')},${assertAddress(proof.from, 'from')},${proof.sourceBlockNumber},${assertBytes32(proof.txHash, 'txHash')},${proof.logIndex},${proof.signerSetVersion},${castArray(proof.signatures)})`,
    ]);
  }

  async finalizeWithdrawal({ withdrawalId, routeId, amount, recipient, proof }) {
    const privateKey = await readPrivateKey(this.keyPath);
    const gasArgs = this.rpcUrl.includes('127.0.0.1') || this.rpcUrl.includes('localhost') ? ['--legacy', '--gas-price', '1000000000'] : [];
    return cast([
      'send', '--rpc-url', this.rpcUrl, ...gasArgs, '--private-key', privateKey, this.rootCustodyAddress,
      'finalizeWithdrawal(bytes32,uint256,address,uint256,(address,uint256,bytes32,uint256,uint256,bytes[]))',
      assertBytes32(withdrawalId, 'withdrawalId'), String(normalizeRouteId(routeId)), assertAddress(recipient, 'recipient'), amount.toString(),
      `(${assertAddress(proof.account, 'account')},${proof.sourceBlockNumber},${assertBytes32(proof.txHash, 'txHash')},${proof.logIndex},${proof.signerSetVersion},${castArray(proof.signatures)})`,
    ]);
  }
}

export { bridgeMessageHash };
