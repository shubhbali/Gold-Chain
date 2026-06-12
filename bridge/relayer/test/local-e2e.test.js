import assert from 'node:assert/strict';
import { test } from 'node:test';
import { GoldBridgeRelayer } from '../src/relayer.js';
import { MemoryRelayerStore } from '../src/store.js';
import { validateRelayerConfig } from '../src/config.js';
import { EVENT_TOPICS } from '../src/constants.js';

const PAXG = 1;
const XAUT = 2;
const USER = '0x00000000000000000000000000000000000000a1';
const GOLD_RECIPIENT = '0x00000000000000000000000000000000000000b1';
const ETH_RECIPIENT = '0x00000000000000000000000000000000000000c1';
const ROOT_CHAIN_ID = 31337;
const GOLD_CHAIN_ID = 7777778;
const ROOT_CUSTODY = '0x0000000000000000000000000000000000000abc';
const CHILD_BRIDGE = '0x0000000000000000000000000000000000000def';
const PAXG_ROOT_TOKEN = '0x0000000000000000000000000000000000000011';
const XAUT_ROOT_TOKEN = '0x0000000000000000000000000000000000000022';
const DUMMY_SIGNATURE = '0x' + '11'.repeat(65);
function bytes32(prefix, nonce) { return `0x${prefix}${String(nonce).padStart(64 - prefix.length, '0')}`; }

class LocalEthereumRoot {
  constructor() {
    this.head = 0;
    this.nextNonce = 0;
    this.tokenBalances = new Map();
    this.lockedByRoute = new Map([[PAXG, 0n], [XAUT, 0n]]);
    this.deposits = [];
    this.finalizedWithdrawals = new Set();
    this.releases = [];
    this.chainId = ROOT_CHAIN_ID;
    this.bridgeAddress = ROOT_CUSTODY;
  }

  key(routeId, account) { return `${routeId}:${account.toLowerCase()}`; }
  setBalance(routeId, account, amount) { this.tokenBalances.set(this.key(routeId, account), amount); }
  balance(routeId, account) { return this.tokenBalances.get(this.key(routeId, account)) ?? 0n; }
  mine(blocks = 1) { this.head += blocks; }
  async getHeadBlock() { return this.head; }
  async isWithdrawalFinalized({ withdrawalId }) { return this.finalizedWithdrawals.has(withdrawalId); }

  deposit({ routeId, from, goldRecipient, amount, symbol }) {
    assert(amount > 0n);
    const fromBalance = this.balance(routeId, from);
    if (fromBalance < amount) throw new Error('insufficient root token balance');
    this.setBalance(routeId, from, fromBalance - amount);
    this.setBalance(routeId, 'custody', this.balance(routeId, 'custody') + amount);
    this.lockedByRoute.set(routeId, this.lockedByRoute.get(routeId) + amount);
    const deposit = {
      depositId: bytes32('de', ++this.nextNonce),
      routeId,
      symbol,
      from,
      goldRecipient,
      amount,
      sourceChainId: this.chainId,
      emitterAddress: this.bridgeAddress,
      eventName: 'Deposited',
      topic0: EVENT_TOPICS.DEPOSITED,
      blockHash: bytes32('aa', this.head + 1),
      txHash: bytes32('bb', this.nextNonce),
      logIndex: this.nextNonce - 1,
      messageId: bytes32('de', this.nextNonce),
      blockNumber: this.head,
      sourceBlockNumber: this.head,
      signerSetVersion: 1,
      signatures: [DUMMY_SIGNATURE],
      finalized: true,
      safe: true,
    };
    this.deposits.push(deposit);
    return deposit;
  }

  async getDeposits({ fromBlock }) {
    return this.deposits.filter((deposit) => deposit.blockNumber >= fromBlock);
  }

  async finalizeWithdrawal({ withdrawalId, routeId, amount, recipient, proof, submitter = 'permissionless-keeper' }) {
    if (this.finalizedWithdrawals.has(withdrawalId)) throw new Error('withdrawal replay');
    if (!proof || proof.sourceBlockNumber <= 0 || !Array.isArray(proof.signatures) || proof.signatures.length === 0) {
      throw new Error('valid threshold proof required');
    }
    if ((this.lockedByRoute.get(routeId) ?? 0n) < amount) throw new Error('custody undercollateralized');
    this.finalizedWithdrawals.add(withdrawalId);
    this.lockedByRoute.set(routeId, this.lockedByRoute.get(routeId) - amount);
    this.setBalance(routeId, 'custody', this.balance(routeId, 'custody') - amount);
    this.setBalance(routeId, recipient, this.balance(routeId, recipient) + amount);
    this.releases.push({ withdrawalId, routeId, amount, recipient, submitter });
  }
}

class LocalGoldChild {
  constructor() {
    this.head = 0;
    this.nextNonce = 0;
    this.goldBalances = new Map();
    this.routeSupply = new Map([[PAXG, 0n], [XAUT, 0n]]);
    this.finalizedDeposits = new Set();
    this.withdrawals = [];
    this.chainId = GOLD_CHAIN_ID;
    this.bridgeAddress = CHILD_BRIDGE;
  }

  key(routeId, account) { return `${routeId}:${account.toLowerCase()}`; }
  balance(routeId, account) { return this.goldBalances.get(this.key(routeId, account)) ?? 0n; }
  setBalance(routeId, account, amount) { this.goldBalances.set(this.key(routeId, account), amount); }
  mine(blocks = 1) { this.head += blocks; }
  async getHeadBlock() { return this.head; }
  async isDepositFinalized({ depositId }) { return this.finalizedDeposits.has(depositId); }

  async finalizeDeposit({ depositId, routeId, amount, recipient }) {
    if (this.finalizedDeposits.has(depositId)) throw new Error('deposit replay');
    this.finalizedDeposits.add(depositId);
    this.routeSupply.set(routeId, (this.routeSupply.get(routeId) ?? 0n) + amount);
    this.setBalance(routeId, recipient, this.balance(routeId, recipient) + amount);
  }

  withdraw({ routeId, account, ethereumRecipient, amount, symbol }) {
    const goldBalance = this.balance(routeId, account);
    if (goldBalance < amount) throw new Error('insufficient GOLD route balance');
    this.setBalance(routeId, account, goldBalance - amount);
    this.routeSupply.set(routeId, this.routeSupply.get(routeId) - amount);
    const withdrawal = {
      withdrawalId: bytes32('fa', ++this.nextNonce),
      routeId,
      symbol,
      account,
      ethereumRecipient,
      recipient: ethereumRecipient,
      amount,
      sourceChainId: this.chainId,
      emitterAddress: this.bridgeAddress,
      eventName: 'WithdrawalInitiated',
      topic0: EVENT_TOPICS.WITHDRAWAL_INITIATED,
      blockHash: bytes32('cc', this.head + 1),
      txHash: bytes32('dd', this.nextNonce),
      logIndex: this.nextNonce - 1,
      messageId: bytes32('fa', this.nextNonce),
      blockNumber: this.head,
      sourceBlockNumber: this.head,
      signerSetVersion: 1,
      signatures: [DUMMY_SIGNATURE],
      finalized: true,
      safe: true,
    };
    this.withdrawals.push(withdrawal);
    return withdrawal;
  }

  async getWithdrawals({ fromBlock }) {
    return this.withdrawals.filter((withdrawal) => withdrawal.blockNumber >= fromBlock);
  }
}

function makeRelayer(root, child, store = new MemoryRelayerStore()) {
  return new GoldBridgeRelayer({
    ethereumClient: root,
    goldChainClient: child,
    ethereumChainId: ROOT_CHAIN_ID,
    goldChainChainId: GOLD_CHAIN_ID,
    rootCustodyAddress: ROOT_CUSTODY,
    childBridgeAddress: CHILD_BRIDGE,
    ethereumFinality: { minConfirmations: 3, requireFinalizedTag: true },
    goldChainFinality: { minConfirmations: 2, requireFinalizedTag: true },
    rescanOverlapBlocks: 2,
    routes: {
      [PAXG]: { symbol: 'PAXG', rootToken: PAXG_ROOT_TOKEN, enabled: true },
      [XAUT]: { symbol: 'XAUT', rootToken: XAUT_ROOT_TOKEN, enabled: true },
    },
    store,
    logger: { info() {} },
  });
}

test('requires explicit finality policies', () => {
  const root = new LocalEthereumRoot();
  const child = new LocalGoldChild();
  assert.throws(() => new GoldBridgeRelayer({
    ethereumClient: root,
    goldChainClient: child,
    ethereumChainId: ROOT_CHAIN_ID,
    goldChainChainId: GOLD_CHAIN_ID,
    rootCustodyAddress: ROOT_CUSTODY,
    childBridgeAddress: CHILD_BRIDGE,
    ethereumFinality: { minConfirmations: 0 },
    goldChainFinality: { minConfirmations: 2 },
    store: new MemoryRelayerStore(),
    routes: { [PAXG]: { symbol: 'PAXG', enabled: true } },
  }), /explicit finality policies/);
});

test('config rejects mock-only production routes and missing finality', () => {
  const base = {
    environment: 'production',
    ethereum: {
      rpcUrl: 'https://eth.example',
      chainId: ROOT_CHAIN_ID,
      rootCustodyAddress: '0x0000000000000000000000000000000000000001',
      finality: { minConfirmations: 64, requireFinalizedTag: true },
    },
    goldChain: {
      rpcUrl: 'https://gold.example',
      chainId: GOLD_CHAIN_ID,
      childBridgeAddress: '0x0000000000000000000000000000000000000002',
      finality: { minConfirmations: 20, requireFinalizedTag: true },
    },
    relayer: { keyPath: '/secure/relayer.json' },
    routes: {
      1: { symbol: 'PAXG', rootToken: '0x0000000000000000000000000000000000000011', enabled: true },
      2: { symbol: 'XAUT', rootToken: '0x0000000000000000000000000000000000000022', enabled: true },
    },
  };
  assert.equal(validateRelayerConfig(base).environment, 'production');
  assert.throws(() => validateRelayerConfig({ ...base, ethereum: { ...base.ethereum, finality: { minConfirmations: 1 } } }), /production ethereum finality/);
  assert.throws(() => validateRelayerConfig({ ...base, ethereum: { ...base.ethereum, finality: undefined } }), /finality is required/);
  assert.throws(() => validateRelayerConfig({
    ...base,
    routes: { ...base.routes, 1: { ...base.routes[1], mockOnly: true } },
  }), /mockOnly/);
});

test('PAXG lock -> finalized relay -> route GOLD mint -> GOLD burn -> finalized relay -> PAXG release', async () => {
  const root = new LocalEthereumRoot();
  const child = new LocalGoldChild();
  const relayer = makeRelayer(root, child);

  root.setBalance(PAXG, USER, 1000n);
  root.mine();
  const deposit = root.deposit({ routeId: PAXG, from: USER, goldRecipient: GOLD_RECIPIENT, amount: 125n, symbol: 'PAXG' });

  assert.equal(root.balance(PAXG, USER), 875n);
  assert.equal(root.balance(PAXG, 'custody'), 125n);
  assert.equal(root.lockedByRoute.get(PAXG), 125n);

  assert.deepEqual(await relayer.runOnce(), { depositsRelayed: 0, withdrawalsRelayed: 0 });
  assert.equal(child.balance(PAXG, GOLD_RECIPIENT), 0n, 'non-finalized deposit must not mint GOLD');

  root.mine(2);
  assert.deepEqual(await relayer.runOnce(), { depositsRelayed: 1, withdrawalsRelayed: 0 });
  assert.equal(child.balance(PAXG, GOLD_RECIPIENT), 125n);
  assert.equal(child.routeSupply.get(PAXG), 125n);
  assert(child.finalizedDeposits.has(deposit.depositId));

  assert.deepEqual(await relayer.runOnce(), { depositsRelayed: 0, withdrawalsRelayed: 0 }, 'deposit replay is ignored');
  assert.equal(child.balance(PAXG, GOLD_RECIPIENT), 125n);

  child.mine();
  const withdrawal = child.withdraw({ routeId: PAXG, account: GOLD_RECIPIENT, ethereumRecipient: ETH_RECIPIENT, amount: 40n, symbol: 'PAXG' });
  assert.equal(child.balance(PAXG, GOLD_RECIPIENT), 85n, 'GOLD is burned before root release');
  assert.equal(child.routeSupply.get(PAXG), 85n);

  assert.deepEqual(await relayer.runOnce(), { depositsRelayed: 0, withdrawalsRelayed: 0 });
  assert.equal(root.balance(PAXG, ETH_RECIPIENT), 0n, 'non-finalized withdrawal must not release root PAXG');

  child.mine(1);
  assert.deepEqual(await relayer.runOnce(), { depositsRelayed: 0, withdrawalsRelayed: 1 });
  assert(root.finalizedWithdrawals.has(withdrawal.withdrawalId));
  assert.equal(root.balance(PAXG, ETH_RECIPIENT), 40n);
  assert.equal(root.balance(PAXG, 'custody'), 85n);
  assert.equal(root.lockedByRoute.get(PAXG), 85n);
  assert.equal(root.releases.length, 1);

  assert.deepEqual(await relayer.runOnce(), { depositsRelayed: 0, withdrawalsRelayed: 0 }, 'withdrawal replay is ignored');
  assert.equal(root.balance(PAXG, ETH_RECIPIENT), 40n);
  assert.equal(root.releases.at(-1).submitter, 'permissionless-keeper');
});

test('permissionless root release accepts valid finalized burn proof from any submitter', async () => {
  const root = new LocalEthereumRoot();
  const child = new LocalGoldChild();
  const relayer = makeRelayer(root, child);

  root.setBalance(PAXG, USER, 100n);
  root.mine();
  root.deposit({ routeId: PAXG, from: USER, goldRecipient: GOLD_RECIPIENT, amount: 60n, symbol: 'PAXG' });
  root.mine(2);
  assert.equal(await relayer.relayDeposits(), 1);

  child.mine();
  const withdrawal = child.withdraw({ routeId: PAXG, account: GOLD_RECIPIENT, ethereumRecipient: ETH_RECIPIENT, amount: 25n, symbol: 'PAXG' });
  child.mine(2);

  const proof = {
    account: withdrawal.account,
    sourceBlockNumber: withdrawal.sourceBlockNumber,
    txHash: withdrawal.txHash,
    logIndex: withdrawal.logIndex,
    signerSetVersion: withdrawal.signerSetVersion,
    signatures: withdrawal.signatures,
  };
  await root.finalizeWithdrawal({
    withdrawalId: withdrawal.withdrawalId,
    routeId: withdrawal.routeId,
    amount: withdrawal.amount,
    recipient: withdrawal.ethereumRecipient,
    submitter: USER,
    proof,
  });

  assert.equal(root.balance(PAXG, ETH_RECIPIENT), 25n);
  assert.equal(root.lockedByRoute.get(PAXG), 35n);
  assert.equal(root.releases.at(-1).submitter, USER);
  await assert.rejects(() => root.finalizeWithdrawal({
    withdrawalId: withdrawal.withdrawalId,
    routeId: withdrawal.routeId,
    amount: withdrawal.amount,
    recipient: withdrawal.ethereumRecipient,
    submitter: 'another-keeper',
    proof,
  }), /withdrawal replay/);
});

test('relayer rejects route-symbol mismatches before mint or release', async () => {
  const root = new LocalEthereumRoot();
  const child = new LocalGoldChild();
  const relayer = makeRelayer(root, child);

  root.setBalance(PAXG, USER, 100n);
  root.mine();
  root.deposit({ routeId: PAXG, from: USER, goldRecipient: GOLD_RECIPIENT, amount: 10n, symbol: 'XAUT' });
  root.mine(2);

  await assert.rejects(() => relayer.runOnce(), /symbol XAUT does not match route 1 PAXG/);
  assert.equal(child.balance(PAXG, GOLD_RECIPIENT), 0n);
});

test('XAUT route remains separate from PAXG route accounting', async () => {
  const root = new LocalEthereumRoot();
  const child = new LocalGoldChild();
  const relayer = makeRelayer(root, child);

  root.setBalance(PAXG, USER, 500n);
  root.setBalance(XAUT, USER, 700n);
  root.mine();
  root.deposit({ routeId: PAXG, from: USER, goldRecipient: GOLD_RECIPIENT, amount: 50n, symbol: 'PAXG' });
  root.deposit({ routeId: XAUT, from: USER, goldRecipient: GOLD_RECIPIENT, amount: 70n, symbol: 'XAUT' });
  root.mine(2);

  assert.deepEqual(await relayer.runOnce(), { depositsRelayed: 2, withdrawalsRelayed: 0 });
  assert.equal(child.balance(PAXG, GOLD_RECIPIENT), 50n);
  assert.equal(child.balance(XAUT, GOLD_RECIPIENT), 70n);
  assert.equal(root.lockedByRoute.get(PAXG), 50n);
  assert.equal(root.lockedByRoute.get(XAUT), 70n);

  child.mine();
  child.withdraw({ routeId: XAUT, account: GOLD_RECIPIENT, ethereumRecipient: ETH_RECIPIENT, amount: 25n, symbol: 'XAUT' });
  child.mine(1);
  assert.deepEqual(await relayer.runOnce(), { depositsRelayed: 0, withdrawalsRelayed: 1 });

  assert.equal(root.balance(PAXG, ETH_RECIPIENT), 0n);
  assert.equal(root.balance(XAUT, ETH_RECIPIENT), 25n);
  assert.equal(root.lockedByRoute.get(PAXG), 50n);
  assert.equal(root.lockedByRoute.get(XAUT), 45n);
  assert.equal(child.routeSupply.get(PAXG), 50n);
  assert.equal(child.routeSupply.get(XAUT), 45n);
});


test('relayer rejects wrong emitter, wrong chain, and malformed recipient metadata', async () => {
  const root = new LocalEthereumRoot();
  const child = new LocalGoldChild();
  const relayer = makeRelayer(root, child);

  root.setBalance(PAXG, USER, 100n);
  root.mine();
  const badEmitter = root.deposit({ routeId: PAXG, from: USER, goldRecipient: GOLD_RECIPIENT, amount: 10n, symbol: 'PAXG' });
  badEmitter.emitterAddress = CHILD_BRIDGE;
  root.mine(2);
  await assert.rejects(() => relayer.runOnce(), /unexpected emitter/);
  assert.equal(child.balance(PAXG, GOLD_RECIPIENT), 0n);

  badEmitter.emitterAddress = ROOT_CUSTODY;
  badEmitter.sourceChainId = 1;
  await assert.rejects(() => relayer.runOnce(), /unexpected chainId/);

  badEmitter.sourceChainId = ROOT_CHAIN_ID;
  badEmitter.topic0 = EVENT_TOPICS.WITHDRAWAL_INITIATED;
  await assert.rejects(() => relayer.runOnce(), /unexpected topic0/);

  badEmitter.topic0 = EVENT_TOPICS.DEPOSITED;
  badEmitter.goldRecipient = '0x1234';
  await assert.rejects(() => relayer.runOnce(), /invalid recipient/);
});

test('relayer rescan overlap and on-chain processed check make restart idempotent', async () => {
  const root = new LocalEthereumRoot();
  const child = new LocalGoldChild();
  child.isDepositFinalized = async ({ depositId }) => child.finalizedDeposits.has(depositId);
  const store = new MemoryRelayerStore();
  const relayer = makeRelayer(root, child, store);

  root.setBalance(PAXG, USER, 100n);
  root.mine();
  const deposit = root.deposit({ routeId: PAXG, from: USER, goldRecipient: GOLD_RECIPIENT, amount: 10n, symbol: 'PAXG' });
  root.mine(2);
  assert.deepEqual(await relayer.runOnce(), { depositsRelayed: 1, withdrawalsRelayed: 0 });
  store.state.processed = {}; // simulate crash after tx success but before durable save
  assert.deepEqual(await relayer.runOnce(), { depositsRelayed: 0, withdrawalsRelayed: 0 });
  assert.equal(child.balance(PAXG, GOLD_RECIPIENT), 10n);
  assert(child.finalizedDeposits.has(deposit.depositId));
});
