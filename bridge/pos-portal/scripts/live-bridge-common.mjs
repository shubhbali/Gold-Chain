import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { ethers } from 'ethers';
import Web3 from 'web3';
import { bufferToHex, rlp } from 'ethereumjs-util';
import { getBlockHeader } from '../test/helpers/blocks.js';
import { getReceiptBytes, getReceiptProof } from '../test/helpers/proofs.js';
import MerkleTree from '../test/helpers/merkle-tree.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

export const REPO_ROOT = path.resolve(__dirname, '../../..');
const DEFAULT_LIVE_CHAIN_DIR = fs.existsSync(path.join(REPO_ROOT, '.live-chain'))
  ? path.join(REPO_ROOT, '.live-chain')
  : path.join(REPO_ROOT, '.live-roughnet');
const LIVE_CHAIN_DIR = process.env.LIVE_CHAIN_DIR
  ? path.resolve(REPO_ROOT, process.env.LIVE_CHAIN_DIR)
  : DEFAULT_LIVE_CHAIN_DIR;
export const ADDRESS_BOOK_PATH =
  process.env.LIVE_BRIDGE_ADDRESS_BOOK || path.join(LIVE_CHAIN_DIR, 'live-bridge-addresses.json');
export const DEFAULT_SEPOLIA_RPC = 'https://sepolia.drpc.org';
export const DEFAULT_GILTCONSENSUS_URL = 'http://127.0.0.1:1317';

export const ROOT_ETHER_ADDRESS = '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE';
export const STATE_RECEIVER_ADDRESS = '0x0000000000000000000000000000000000003001';
export const NATIVE_GILT_BRIDGE_ADDRESS = '0x0000000000000000000000000000000000003002';
export const STAKE_HUB_ADDRESS = '0x0000000000000000000000000000000000002002';
export const GOV_HUB_ADDRESS = '0x0000000000000000000000000000000000001007';
export const GOVERNOR_ADDRESS = '0x0000000000000000000000000000000000002004';
export const GOV_TOKEN_ADDRESS = '0x0000000000000000000000000000000000002005';
const GOLD_CHAIN_ID_RAW = process.env.GOLD_CHAIN_ID || process.env.CHAIN_ID || '714';
export const GOLD_CHAIN_ID = Number.parseInt(GOLD_CHAIN_ID_RAW, 10);
if (!Number.isInteger(GOLD_CHAIN_ID) || GOLD_CHAIN_ID <= 0) {
  throw new Error(`Invalid GOLD_CHAIN_ID: ${GOLD_CHAIN_ID_RAW}`);
}
export const ZERO_ADDRESS = ethers.ZeroAddress;
const CHECKPOINT_ACCOUNT_SEED = process.env.CHECKPOINT_ACCOUNT_SEED || 'gold-chain-testnet';
export const CHECKPOINT_ACCOUNT_HASH = process.env.CHECKPOINT_ACCOUNT_HASH
  || ethers.keccak256(ethers.toUtf8Bytes(CHECKPOINT_ACCOUNT_SEED));

export function addressEq(a, b) {
  return a.toLowerCase() === b.toLowerCase();
}

export function errorContains(error, needle) {
  const parts = [
    error?.message,
    error?.shortMessage,
    error?.reason,
    error?.info?.error?.message,
  ].filter(Boolean);
  return parts.some((part) => String(part).includes(needle));
}

export function readJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, 'utf8'));
}

export function writeJson(filePath, value) {
  fs.mkdirSync(path.dirname(filePath), { recursive: true });
  fs.writeFileSync(filePath, `${JSON.stringify(value, null, 2)}\n`);
}

export function readArtifact(relativePath) {
  return readJson(path.join(REPO_ROOT, relativePath));
}

export function bytecodeOf(artifact) {
  const bytecode = artifact?.bytecode?.object ?? artifact?.bytecode;
  if (!bytecode) {
    throw new Error('artifact is missing bytecode');
  }
  return bytecode.startsWith('0x') ? bytecode : `0x${bytecode}`;
}

function isReceiptIndexingError(error) {
  const messages = [
    error?.message,
    error?.shortMessage,
    error?.error?.message,
    error?.error?.data,
  ].filter(Boolean);
  return messages.some((message) => String(message).includes('transaction indexing is in progress'));
}

function rpcUrlForProvider(provider) {
  return provider?._getConnection?.().url || provider?.connection?.url || null;
}

async function withTimeout(promise, label, timeoutMs = 15000) {
  let timer;
  try {
    return await Promise.race([
      promise,
      new Promise((_, reject) => {
        timer = setTimeout(() => reject(new Error(`${label} timed out after ${timeoutMs}ms`)), timeoutMs);
      }),
    ]);
  } finally {
    if (timer) {
      clearTimeout(timer);
    }
  }
}

async function receiptProvidersFor(txResponse) {
  const providers = [txResponse.provider].filter(Boolean);
  const network = await withTimeout(txResponse.provider.getNetwork(), 'getNetwork');
  if (network.chainId !== 11155111n) {
    return providers;
  }

  const fallbackUrls = [
    ...(process.env.SEPOLIA_RECEIPT_RPC_URLS || '').split(',').map((value) => value.trim()).filter(Boolean),
    'https://sepolia.drpc.org',
    'https://ethereum-sepolia.publicnode.com',
    'https://ethereum-sepolia-rpc.publicnode.com',
  ];

  const seen = new Set(providers.map((provider) => rpcUrlForProvider(provider)).filter(Boolean));
  for (const url of fallbackUrls) {
    if (seen.has(url)) {
      continue;
    }
    providers.push(new ethers.JsonRpcProvider(url));
    seen.add(url);
  }

  return providers;
}

export async function waitForMined(txResponse, confirmations = 1, timeoutMs = 300000, pollMs = 3000) {
  if (!txResponse?.hash || !txResponse?.provider) {
    throw new Error('missing transaction response/provider');
  }

  const startedAt = Date.now();
  const providers = await receiptProvidersFor(txResponse);
  let loggedWaiting = false;
  while (Date.now() - startedAt < timeoutMs) {
    if (!loggedWaiting && Date.now() - startedAt >= 30000) {
      console.log(`Still waiting for tx ${txResponse.hash}`);
      loggedWaiting = true;
    }
    let sawReceipt = false;
    for (const provider of providers) {
      try {
        const receipt = await withTimeout(
          provider.getTransactionReceipt(txResponse.hash),
          `getTransactionReceipt ${txResponse.hash}`,
        );
        if (!receipt) {
          continue;
        }

        sawReceipt = true;
        if (confirmations > 1) {
          const latestBlock = await withTimeout(provider.getBlockNumber(), 'getBlockNumber');
          if (latestBlock < receipt.blockNumber + confirmations - 1) {
            continue;
          }
        }

        if (receipt.status === 0 || receipt.status === 0n) {
          throw new Error(`transaction ${txResponse.hash} reverted`);
        }

        return receipt;
      } catch (_) {
        continue;
      }
    }
    if (!sawReceipt) {
      await sleep(pollMs);
      continue;
    }
    await sleep(pollMs);
  }

  throw new Error(`Timed out waiting for transaction ${txResponse.hash}`);
}

async function waitTx(txPromise) {
  const tx = await txPromise;
  return waitForMined(tx);
}

export async function deployContract(signer, artifact, args = []) {
  const factory = new ethers.ContractFactory(artifact.abi, bytecodeOf(artifact), signer);
  const contract = await factory.deploy(...args);
  await waitForMined(contract.deploymentTransaction());
  return contract;
}

export function contractAt(address, artifact, runner) {
  return new ethers.Contract(address, artifact.abi, runner);
}

export function saveAddressBook(data) {
  writeJson(ADDRESS_BOOK_PATH, data);
}

export function loadAddressBook() {
  return readJson(ADDRESS_BOOK_PATH);
}

function readStoredCheckpointCursor(addressBook) {
  const cursor = addressBook?.runtime?.checkpointCursor;
  if (
    !cursor ||
    cursor.currentHeaderBlock == null ||
    cursor.offsetBlock == null ||
    cursor.lastActualEndBlock == null ||
    cursor.logicalStart == null ||
    cursor.logicalEnd == null
  ) {
    return null;
  }

  return {
    currentHeaderBlock: String(cursor.currentHeaderBlock),
    offsetBlock: Number(cursor.offsetBlock),
    lastActualEndBlock: Number(cursor.lastActualEndBlock),
    logicalStart: Number(cursor.logicalStart),
    logicalEnd: Number(cursor.logicalEnd),
  };
}

function writeStoredCheckpointCursor(addressBook, cursor) {
  if (!addressBook || !cursor) {
    return;
  }

  addressBook.runtime ||= {};
  addressBook.runtime.checkpointCursor = {
    currentHeaderBlock: String(cursor.currentHeaderBlock),
    offsetBlock: Number(cursor.offsetBlock),
    lastActualEndBlock: Number(cursor.lastActualEndBlock),
    logicalStart: Number(cursor.logicalStart),
    logicalEnd: Number(cursor.logicalEnd),
  };
  saveAddressBook(addressBook);
}

export async function waitForCondition(fn, label, timeoutMs = 900000, intervalMs = 5000) {
  const startedAt = Date.now();
  while (Date.now() - startedAt < timeoutMs) {
    const value = await fn();
    if (value) {
      return value;
    }
    await sleep(intervalMs);
  }
  throw new Error(`Timed out waiting for ${label}`);
}

export function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

export async function rpcRequest(url, method, params = [], label = method) {
  const response = await fetch(url, {
    method: 'POST',
    headers: {
      Accept: 'application/json',
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ jsonrpc: '2.0', id: 1, method, params }),
    signal: AbortSignal.timeout(10000),
  });
  if (!response.ok) {
    throw new Error(`${label} returned HTTP ${response.status}`);
  }
  const payload = await response.json();
  if (payload.error) {
    throw new Error(`${label} failed: ${payload.error.message || JSON.stringify(payload.error)}`);
  }
  return payload.result;
}

export async function waitForRpc(provider, label, timeoutMs = 300000, intervalMs = 3000) {
  const url = rpcUrlForProvider(provider);
  if (!url) {
    throw new Error(`${label} RPC URL is missing`);
  }
  return waitForCondition(
    async () => {
      try {
        await rpcRequest(url, 'eth_blockNumber', [], `${label} eth_blockNumber`);
        return true;
      } catch (_) {
        return null;
      }
    },
    `${label} RPC`,
    timeoutMs,
    intervalMs,
  );
}

async function fetchJson(url, label) {
  const response = await fetch(url, {
    headers: { Accept: 'application/json' },
    signal: AbortSignal.timeout(10000),
  });
  if (!response.ok) {
    throw new Error(`${label} returned HTTP ${response.status}`);
  }
  return response.json();
}

export async function readGiltConsensusLatestRecord(giltconsensusUrl = DEFAULT_GILTCONSENSUS_URL) {
  const url = new URL('/clerk/event-records/latest-id', giltconsensusUrl);
  const payload = await fetchJson(url, 'giltconsensus latest record');
  return {
    latestRecordId: BigInt(payload.latest_record_id),
    isProcessedByGiltConsensus: Boolean(payload.is_processed_by_giltconsensus),
  };
}

export async function readGiltConsensusRecordCount(giltconsensusUrl = DEFAULT_GILTCONSENSUS_URL) {
  const url = new URL('/clerk/event-records/count', giltconsensusUrl);
  const payload = await fetchJson(url, 'giltconsensus record count');
  return BigInt(payload.count);
}

export async function readGiltConsensusRecord(giltconsensusUrl, recordId) {
  const url = new URL(`/clerk/event-records/${recordId.toString()}`, giltconsensusUrl);
  const response = await fetch(url, {
    headers: { Accept: 'application/json' },
    signal: AbortSignal.timeout(10000),
  });
  if (response.status === 404) {
    return null;
  }
  if (!response.ok) {
    throw new Error(`giltconsensus record ${recordId.toString()} returned HTTP ${response.status}`);
  }
  return response.json();
}

export async function waitForGiltConsensusRecord(giltconsensusUrl, recordId, timeoutMs = 900000, intervalMs = 5000) {
  return waitForCondition(
    async () => {
      const record = await readGiltConsensusRecord(giltconsensusUrl, recordId);
      return record ? record : null;
    },
    `giltconsensus record ${recordId.toString()}`,
    timeoutMs,
    intervalMs,
  );
}

export async function submitGoldMapping(
  rootChainManager,
  childChainManager,
  rootToken,
  childToken,
  tokenId,
  tokenType,
) {
  const rootMapped = await rootChainManager.rootToChildToken(rootToken);
  const childMapped = await childChainManager.rootToChildToken(rootToken);

  if (addressEq(rootMapped, childToken) && addressEq(childMapped, childToken)) {
    return;
  }

  if (rootMapped !== ethers.ZeroAddress) {
    await waitTx(rootChainManager.cleanMapToken(rootToken, rootMapped));
  }

  try {
    await waitTx(rootChainManager.mapGoldToken(rootToken, childToken, tokenId, tokenType));
  } catch (error) {
    if (!errorContains(error, 'ALREADY_MAPPED')) {
      throw error;
    }

    await waitTx(rootChainManager.cleanMapToken(rootToken, childToken));
    await waitTx(rootChainManager.mapGoldToken(rootToken, childToken, tokenId, tokenType));
  }
}

export async function submitStandardMapping(rootChainManager, childChainManager, rootToken, childToken, tokenType) {
  const rootMapped = await rootChainManager.rootToChildToken(rootToken);
  const childMapped = await childChainManager.rootToChildToken(rootToken);

  if (addressEq(rootMapped, childToken) && addressEq(childMapped, childToken)) {
    return;
  }

  await waitTx(
    rootMapped !== ethers.ZeroAddress
      ? rootChainManager.remapToken(rootToken, childToken, tokenType)
      : rootChainManager.mapToken(rootToken, childToken, tokenType),
  );
}

export async function waitForChildStateId(stateReceiver, targetId, timeoutMs = 900000, intervalMs = 5000) {
  return waitForCondition(
    async () => {
      const lastStateId = await stateReceiver.lastStateId();
      return lastStateId >= targetId ? lastStateId : null;
    },
    `child state id ${targetId.toString()}`,
    timeoutMs,
    intervalMs,
  );
}

export async function readBridgeProgress(rootStateSender, childStateReceiver, giltconsensusUrl = DEFAULT_GILTCONSENSUS_URL) {
  const [rootStateId, childStateId, giltconsensusLatest, giltconsensusCount] = await Promise.all([
    rootStateSender.counter(),
    childStateReceiver.lastStateId(),
    readGiltConsensusLatestRecord(giltconsensusUrl),
    readGiltConsensusRecordCount(giltconsensusUrl),
  ]);
  return {
    rootStateId,
    childStateId,
    giltconsensusLatestRecordId: giltconsensusLatest.latestRecordId,
    giltconsensusLatestProcessed: giltconsensusLatest.isProcessedByGiltConsensus,
    giltconsensusRecordCount: giltconsensusCount,
  };
}

export function publicKeyBytes(privateKey) {
  const uncompressed = ethers.SigningKey.computePublicKey(privateKey, false);
  return `0x${uncompressed.slice(4)}`;
}

export function role(name) {
  return ethers.keccak256(ethers.toUtf8Bytes(name));
}

export function hexAddressBytes(address) {
  return ethers.getBytes(address);
}

export function hexStringBytes(value) {
  return ethers.toUtf8Bytes(value);
}

export function checkpointSignature(privateKey, data) {
  const digest = ethers.keccak256(ethers.concat(['0x01', data]));
  const signature = new ethers.SigningKey(privateKey).sign(digest);
  return [[BigInt(signature.r), BigInt(signature.s), BigInt(signature.v)]];
}

export function buildExitPayload(headerNumber, checkpointData, receiptLogIndex = 0) {
  return bufferToHex(
    rlp.encode([
      headerNumber,
      bufferToHex(Buffer.concat(checkpointData.blockProof)),
      checkpointData.blockNumber,
      checkpointData.blockTime,
      bufferToHex(checkpointData.txRoot),
      bufferToHex(checkpointData.receiptRoot),
      bufferToHex(checkpointData.receipt),
      bufferToHex(rlp.encode(checkpointData.receiptParentNodes)),
      bufferToHex(checkpointData.path),
      receiptLogIndex,
    ]),
  );
}

export async function buildCheckpointData(web3Child, txHash, offsetBlock, startActualBlock) {
  const tx = await web3Child.eth.getTransaction(txHash);
  const receipt = await web3Child.eth.getTransactionReceipt(txHash);
  const block = await web3Child.eth.getBlock(receipt.blockHash, true);
  const endActualBlock = Number(block.number);

  if (startActualBlock > endActualBlock) {
    throw new Error(`invalid checkpoint window ${startActualBlock} > ${endActualBlock}`);
  }

  const headers = [];
  for (let actualBlock = startActualBlock; actualBlock <= endActualBlock; actualBlock += 1) {
    const rawBlock = await web3Child.eth.getBlock(actualBlock);
    headers.push(
      await getBlockHeader({
        ...rawBlock,
        number: actualBlock - offsetBlock,
      }),
    );
  }

  const normalizedBlock = {
    ...block,
    number: endActualBlock - offsetBlock,
  };

  const tree = new MerkleTree(headers);
  const blockHeader = await getBlockHeader(normalizedBlock);
  const receiptProof = await getReceiptProof(receipt, block, web3Child);

  return {
    actualStartBlock: startActualBlock,
    actualEndBlock: endActualBlock,
    startBlock: startActualBlock - offsetBlock,
    endBlock: endActualBlock - offsetBlock,
    blockNumber: endActualBlock - offsetBlock,
    blockTime: Number(block.timestamp),
    headerRoot: bufferToHex(tree.getRoot()),
    blockProof: tree.getProof(blockHeader),
    txRoot: Buffer.from(block.transactionsRoot.slice(2), 'hex'),
    receiptRoot: Buffer.from(block.receiptsRoot.slice(2), 'hex'),
    receipt: getReceiptBytes(receipt),
    receiptParentNodes: receiptProof.parentNodes,
    path: Buffer.concat([Buffer.from('00', 'hex'), receiptProof.path]),
  };
}

async function checkpointWindowRoot(provider, actualStart, actualEnd, logicalStart) {
  const offset = actualStart - logicalStart;
  const headers = [];

  for (let actual = actualStart; actual <= actualEnd; actual += 1) {
    const rawBlock = await provider.send('eth_getBlockByNumber', [ethers.toQuantity(actual), false]);
    const normalized = normalizeBlockShape(rawBlock);
    headers.push(
      await getBlockHeader({
        ...normalized,
        number: actual - offset,
      }),
    );
  }

  const tree = new MerkleTree(headers);
  return ethers.hexlify(tree.getRoot()).toLowerCase();
}

async function readRootCheckpointWindow(rootChain) {
  const currentHeaderBlock = await rootChain.currentHeaderBlock();
  const headerBlock = await rootChain.headerBlocks(currentHeaderBlock);
  const headerRoot = String(headerBlock[0]).toLowerCase();
  const logicalStart = Number(headerBlock[1]);
  const logicalEnd = Number(headerBlock[2]);

  return {
    currentHeaderBlock,
    headerRoot,
    logicalStart,
    logicalEnd,
  };
}

export async function findCheckpointCursor(rootChain, provider, searchChunk = 2000) {
  const { currentHeaderBlock, headerRoot, logicalStart, logicalEnd } = await readRootCheckpointWindow(rootChain);

  if (headerRoot === ethers.ZeroHash.toLowerCase() && logicalStart === 0 && logicalEnd === 0) {
    return null;
  }

  const span = logicalEnd - logicalStart + 1;
  const actualLatest = await provider.getBlockNumber();
  const earliestActualEnd = span - 1;

  for (let chunkEnd = actualLatest; chunkEnd >= earliestActualEnd; chunkEnd -= searchChunk) {
    const chunkStart = Math.max(earliestActualEnd, chunkEnd - searchChunk + 1);
    for (let actualEnd = chunkEnd; actualEnd >= chunkStart; actualEnd -= 1) {
      const actualStart = actualEnd - span + 1;
      const computedRoot = await checkpointWindowRoot(provider, actualStart, actualEnd, logicalStart);
      if (computedRoot === headerRoot) {
        return {
          currentHeaderBlock: currentHeaderBlock.toString(),
          offsetBlock: actualStart - logicalStart,
          lastActualEndBlock: actualEnd,
          logicalStart,
          logicalEnd,
        };
      }
    }
  }

  throw new Error(
    `Unable to align root checkpoint ${currentHeaderBlock.toString()} (${logicalStart}-${logicalEnd}) with child chain`,
  );
}

export function createCheckpointBuilder({
  rootChain,
  proposerPrivateKey,
  proposerAddress,
  childWeb3,
  roughnetProvider,
  addressBook = null,
  goldChainId = null,
  checkpointAccountHash = null,
}) {
  let offsetBlock = null;
  let lastActualEndBlock = null;
  let logicalStart = null;
  let logicalEnd = null;
  let currentHeaderBlock = null;
  let cursorPromise = null;
  let resolvedGoldChainId = goldChainId == null ? null : BigInt(goldChainId);
  let resolvedCheckpointAccountHash = checkpointAccountHash || addressBook?.meta?.checkpointAccountHash || CHECKPOINT_ACCOUNT_HASH;

  const persistCursor = () => {
    if (
      offsetBlock == null ||
      lastActualEndBlock == null ||
      logicalStart == null ||
      logicalEnd == null ||
      currentHeaderBlock == null
    ) {
      return;
    }

    writeStoredCheckpointCursor(addressBook, {
      currentHeaderBlock: currentHeaderBlock.toString(),
      offsetBlock,
      lastActualEndBlock,
      logicalStart,
      logicalEnd,
    });
  };

  async function ensureCursor() {
    if (offsetBlock != null && lastActualEndBlock != null) {
      return;
    }

    const storedCursor = readStoredCheckpointCursor(addressBook);
    if (storedCursor) {
      const liveWindow = await readRootCheckpointWindow(rootChain);
      if (
        storedCursor.currentHeaderBlock === liveWindow.currentHeaderBlock.toString() &&
        storedCursor.logicalStart === liveWindow.logicalStart &&
        storedCursor.logicalEnd === liveWindow.logicalEnd
      ) {
        offsetBlock = storedCursor.offsetBlock;
        lastActualEndBlock = storedCursor.lastActualEndBlock;
        logicalStart = storedCursor.logicalStart;
        logicalEnd = storedCursor.logicalEnd;
        currentHeaderBlock = BigInt(storedCursor.currentHeaderBlock);
        return;
      }
    }

    if (!cursorPromise) {
      cursorPromise = findCheckpointCursor(rootChain, roughnetProvider);
    }
    const cursor = await cursorPromise;
    if (cursor) {
      offsetBlock = cursor.offsetBlock;
      lastActualEndBlock = cursor.lastActualEndBlock;
      logicalStart = cursor.logicalStart;
      logicalEnd = cursor.logicalEnd;
      currentHeaderBlock = BigInt(cursor.currentHeaderBlock);
      persistCursor();
    }
  }

  return async (txHash, logIndex) => {
    await ensureCursor();
    const receipt = await childWeb3.eth.getTransactionReceipt(txHash);
    const actualEndBlock = Number(receipt.blockNumber);

    if (
      offsetBlock != null &&
      currentHeaderBlock != null &&
      logicalStart != null &&
      logicalEnd != null
    ) {
      const currentWindowStart = offsetBlock + logicalStart;
      const currentWindowEnd = offsetBlock + logicalEnd;
      if (actualEndBlock >= currentWindowStart && actualEndBlock <= currentWindowEnd) {
        const checkpointData = await buildCheckpointData(childWeb3, txHash, offsetBlock, currentWindowStart);
        return buildExitPayload(currentHeaderBlock, checkpointData, logIndex);
      }
    }

    if (offsetBlock == null) {
      offsetBlock = actualEndBlock;
      lastActualEndBlock = actualEndBlock - 1;
    }

    const actualStartBlock = lastActualEndBlock + 1;
    const checkpointData = await buildCheckpointData(childWeb3, txHash, offsetBlock, actualStartBlock);
    if (resolvedGoldChainId == null) {
      const childChainId = addressBook?.meta?.childChainId
        || addressBook?.meta?.goldChainId
        || (await roughnetProvider.getNetwork()).chainId;
      resolvedGoldChainId = BigInt(childChainId);
    }
    const data = ethers.AbiCoder.defaultAbiCoder().encode(
      ['address', 'uint256', 'uint256', 'bytes32', 'bytes32', 'uint256'],
      [
        proposerAddress,
        BigInt(checkpointData.startBlock),
        BigInt(checkpointData.endBlock),
        checkpointData.headerRoot,
        resolvedCheckpointAccountHash,
        resolvedGoldChainId,
      ],
    );

    const sigs = checkpointSignature(proposerPrivateKey, data);
    const submitTx = await rootChain.submitCheckpoint(data, sigs);
    const submitReceipt = await waitForMined(submitTx);

    let headerNumber = null;
    for (const log of submitReceipt.logs) {
      try {
        const parsed = rootChain.interface.parseLog(log);
        if (parsed?.name === 'NewHeaderBlock') {
          headerNumber = parsed.args.headerBlockId;
          break;
        }
      } catch (_) {
        // ignore unrelated logs
      }
    }
    if (headerNumber == null) {
      throw new Error('NewHeaderBlock not found');
    }

    lastActualEndBlock = checkpointData.actualEndBlock;
    logicalStart = checkpointData.startBlock;
    logicalEnd = checkpointData.endBlock;
    currentHeaderBlock = BigInt(headerNumber);
    persistCursor();

    return buildExitPayload(headerNumber, checkpointData, logIndex);
  };
}

export function web3For(url) {
  return new Web3(url);
}

export function rpcProviderFor(url) {
  return new ethers.JsonRpcProvider(url, undefined, { batchMaxCount: 1 });
}

function normalizeReceiptShape(receipt) {
  return {
    ...receipt,
    blockNumber: receipt?.blockNumber != null ? Number(BigInt(receipt.blockNumber)) : receipt?.blockNumber,
    transactionIndex:
      receipt?.transactionIndex != null ? Number(BigInt(receipt.transactionIndex)) : receipt?.transactionIndex,
  };
}

function normalizeBlockShape(block) {
  return {
    ...block,
    number: block?.number != null ? Number(BigInt(block.number)) : block?.number,
    timestamp: block?.timestamp != null ? Number(BigInt(block.timestamp)) : block?.timestamp,
    transactions: Array.isArray(block?.transactions)
      ? block.transactions.map((tx) =>
          typeof tx === 'string'
            ? tx
            : {
                ...tx,
                transactionIndex:
                  tx?.transactionIndex != null ? Number(BigInt(tx.transactionIndex)) : tx?.transactionIndex,
              },
        )
      : block?.transactions,
  };
}

export function childRpcFor(providerOrUrl) {
  const provider = typeof providerOrUrl === 'string' ? rpcProviderFor(providerOrUrl) : providerOrUrl;

  return {
    eth: {
      async getTransaction(hash) {
        const tx = await provider.send('eth_getTransactionByHash', [hash]);
        return tx?.transactionIndex != null
          ? { ...tx, transactionIndex: Number(BigInt(tx.transactionIndex)) }
          : tx;
      },
      async getTransactionReceipt(hash) {
        return normalizeReceiptShape(await provider.send('eth_getTransactionReceipt', [hash]));
      },
      async getBlock(ref, full = false) {
        const isHash = typeof ref === 'string' && ref.startsWith('0x') && ref.length === 66;
        const method = isHash ? 'eth_getBlockByHash' : 'eth_getBlockByNumber';
        const arg = isHash ? ref : ethers.toQuantity(ref);
        return normalizeBlockShape(await provider.send(method, [arg, full]));
      },
    },
  };
}
