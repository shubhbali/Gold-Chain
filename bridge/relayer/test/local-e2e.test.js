import assert from 'node:assert/strict';
import { test } from 'node:test';
import { GoldBridgeRelayer } from '../src/relayer.js';
import { MemoryRelayerStore } from '../src/store.js';
import { validateRelayerConfig } from '../src/config.js';

const PAXG = 1;
const XAUT = 2;
const USER = '0x00000000000000000000000000000000000000a1';
const GOLD_RECIPIENT = '0x00000000000000000000000000000000000000b1';
const ETH_RECIPIENT = '0x00000000000000000000000000000000000000c1';

class LocalEthereumRoot {
  constructor() {
    this.head = 0;
    this.nextNonce = 0;
    this.tokenBalances = new Map();
    this.lockedByRoute = new Map([[PAXG, 0n], [XAUT, 0n]]);
    this.deposits = [];
    this.finalizedWithdrawals = new Set();
    this.releases = [];
  }

  key(routeId, account) { return `${routeId}:${account.toLowerCase()}`; }
  setBalance(routeId, account, amount) { this.tokenBalances.set(this.key(routeId, account), amount); }
  balance(routeId, account) { return this.tokenBalances.get(this.key(routeId, account)) ?? 0n; }
  mine(blocks = 1) { this.head += blocks; }
  async getHeadBlock() { return this.head; }

  deposit({ routeId, from, goldRecipient, amount, symbol }) {
    assert(amount > 0n);
    const fromBalance = this.balance(routeId, from);
    if (fromBalance < amount) throw new Error('insufficient root token balance');
    this.setBalance(routeId, from, fromBalance - amount);
    this.setBalance(routeId, 'custody', this.balance(routeId, 'custody') + amount);
    this.lockedByRoute.set(routeId, this.lockedByRoute.get(routeId) + amount);
    const deposit = {
      depositId: `0xdeposit${String(++this.nextNonce).padStart(56, '0')}`,
      routeId,
      symbol,
      from,
      goldRecipient,
      amount,
      blockNumber: this.head,
      finalized: true,
      safe: true,
    };
    this.deposits.push(deposit);
    return deposit;
  }

  async getDeposits({ fromBlock }) {
    return this.deposits.filter((deposit) => deposit.blockNumber >= fromBlock);
  }

  async finalizeWithdrawal({ withdrawalId, routeId, amount, recipient }) {
    if (this.finalizedWithdrawals.has(withdrawalId)) throw new Error('withdrawal replay');
    if ((this.lockedByRoute.get(routeId) ?? 0n) < amount) throw new Error('custody undercollateralized');
    this.finalizedWithdrawals.add(withdrawalId);
    this.lockedByRoute.set(routeId, this.lockedByRoute.get(routeId) - amount);
    this.setBalance(routeId, 'custody', this.balance(routeId, 'custody') - amount);
    this.setBalance(routeId, recipient, this.balance(routeId, recipient) + amount);
    this.releases.push({ withdrawalId, routeId, amount, recipient });
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
  }

  key(routeId, account) { return `${routeId}:${account.toLowerCase()}`; }
  balance(routeId, account) { return this.goldBalances.get(this.key(routeId, account)) ?? 0n; }
  setBalance(routeId, account, amount) { this.goldBalances.set(this.key(routeId, account), amount); }
  mine(blocks = 1) { this.head += blocks; }
  async getHeadBlock() { return this.head; }

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
      withdrawalId: `0xwithdraw${String(++this.nextNonce).padStart(55, '0')}`,
      routeId,
      symbol,
      account,
      ethereumRecipient,
      recipient: ethereumRecipient,
      amount,
      blockNumber: this.head,
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
    ethereumFinality: { minConfirmations: 3, requireFinalizedTag: true },
    goldChainFinality: { minConfirmations: 2, requireFinalizedTag: true },
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
    ethereumFinality: { minConfirmations: 0 },
    goldChainFinality: { minConfirmations: 2 },
    store: new MemoryRelayerStore(),
  }), /explicit finality policies/);
});

test('config rejects mock-only production routes and missing finality', () => {
  const base = {
    environment: 'production',
    ethereum: {
      rpcUrl: 'https://eth.example',
      rootCustodyAddress: '0x0000000000000000000000000000000000000001',
      finality: { minConfirmations: 64 },
    },
    goldChain: {
      rpcUrl: 'https://gold.example',
      childBridgeAddress: '0x0000000000000000000000000000000000000002',
      finality: { minConfirmations: 20 },
    },
    relayer: { keyPath: '/secure/relayer.json' },
    routes: {
      1: { symbol: 'PAXG', rootToken: '0x0000000000000000000000000000000000000011', enabled: true },
      2: { symbol: 'XAUT', rootToken: '0x0000000000000000000000000000000000000022', enabled: true },
    },
  };
  assert.equal(validateRelayerConfig(base).environment, 'production');
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
