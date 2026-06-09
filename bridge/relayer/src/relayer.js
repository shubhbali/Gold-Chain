import { eventKey, FLOW, normalizeRouteId } from './constants.js';
import { filterFinalizedEvents } from './finality.js';

function requireMethod(client, name) {
  if (!client || typeof client[name] !== 'function') throw new Error(`client method ${name} is required`);
}

function normalizeRoutes(routes) {
  if (!routes || typeof routes !== 'object') throw new Error('route policy is required');
  const normalized = new Map();
  for (const [rawRouteId, route] of Object.entries(routes)) {
    const routeId = normalizeRouteId(rawRouteId);
    if (!route || typeof route !== 'object') throw new Error(`route ${routeId} policy is required`);
    if (route.enabled !== true) throw new Error(`route ${routeId} is not enabled`);
    if (typeof route.symbol !== 'string' || route.symbol.length === 0) throw new Error(`route ${routeId} symbol is required`);
    normalized.set(routeId, Object.freeze({ ...route, routeId }));
  }
  return normalized;
}

function validateBridgeEvent(event, idField, routes) {
  if (!event || typeof event[idField] !== 'string' || event[idField].length === 0) {
    throw new Error(`bridge event missing ${idField}`);
  }
  const routeId = normalizeRouteId(event.routeId);
  const route = routes.get(routeId);
  if (!route) throw new Error(`bridge event ${event[idField]} uses unconfigured route ${routeId}`);
  if (event.symbol !== undefined && event.symbol !== route.symbol) {
    throw new Error(`bridge event ${event[idField]} symbol ${event.symbol} does not match route ${routeId} ${route.symbol}`);
  }
  if (typeof event.amount !== 'bigint' || event.amount <= 0n) throw new Error(`bridge event ${event[idField]} has invalid amount`);
  if (typeof event.recipient !== 'string' || !event.recipient.startsWith('0x')) {
    throw new Error(`bridge event ${event[idField]} has invalid recipient`);
  }
}

export class GoldBridgeRelayer {
  constructor({ ethereumClient, goldChainClient, ethereumFinality, goldChainFinality, routes, store, logger = console }) {
    requireMethod(ethereumClient, 'getHeadBlock');
    requireMethod(ethereumClient, 'getDeposits');
    requireMethod(ethereumClient, 'finalizeWithdrawal');
    requireMethod(goldChainClient, 'getHeadBlock');
    requireMethod(goldChainClient, 'getWithdrawals');
    requireMethod(goldChainClient, 'finalizeDeposit');
    if (!store) throw new Error('relayer store is required');
    if (!ethereumFinality?.minConfirmations || !goldChainFinality?.minConfirmations) {
      throw new Error('explicit finality policies are required for both chains');
    }
    this.ethereumClient = ethereumClient;
    this.goldChainClient = goldChainClient;
    this.ethereumFinality = ethereumFinality;
    this.goldChainFinality = goldChainFinality;
    this.routes = normalizeRoutes(routes);
    this.store = store;
    this.logger = logger;
  }

  async relayDeposits() {
    const headBlock = await this.ethereumClient.getHeadBlock();
    const fromBlock = this.store.getCursor('ethereumDeposits', 0);
    const deposits = await this.ethereumClient.getDeposits({ fromBlock });
    const finalized = filterFinalizedEvents({ chainName: 'ethereum', headBlock, events: deposits, finality: this.ethereumFinality });
    let relayed = 0;
    for (const deposit of finalized) {
      validateBridgeEvent({ ...deposit, recipient: deposit.goldRecipient }, 'depositId', this.routes);
      const key = eventKey(FLOW.ROOT_LOCK_TO_CHILD_MINT, deposit.depositId);
      if (this.store.hasProcessed(key)) continue;
      await this.goldChainClient.finalizeDeposit({
        depositId: deposit.depositId,
        routeId: normalizeRouteId(deposit.routeId),
        amount: deposit.amount,
        recipient: deposit.goldRecipient,
      });
      this.store.markProcessed(key);
      relayed += 1;
      this.logger.info?.(`relayed finalized ${deposit.symbol ?? 'GOLD'} deposit ${deposit.depositId}`);
    }
    if (finalized.length > 0) {
      this.store.setCursor('ethereumDeposits', Math.max(...finalized.map((event) => event.blockNumber)) + 1);
    }
    return relayed;
  }

  async relayWithdrawals() {
    const headBlock = await this.goldChainClient.getHeadBlock();
    const fromBlock = this.store.getCursor('goldWithdrawals', 0);
    const withdrawals = await this.goldChainClient.getWithdrawals({ fromBlock });
    const finalized = filterFinalizedEvents({ chainName: 'goldChain', headBlock, events: withdrawals, finality: this.goldChainFinality });
    let relayed = 0;
    for (const withdrawal of finalized) {
      validateBridgeEvent({ ...withdrawal, recipient: withdrawal.ethereumRecipient }, 'withdrawalId', this.routes);
      const key = eventKey(FLOW.CHILD_BURN_TO_ROOT_RELEASE, withdrawal.withdrawalId);
      if (this.store.hasProcessed(key)) continue;
      await this.ethereumClient.finalizeWithdrawal({
        withdrawalId: withdrawal.withdrawalId,
        routeId: normalizeRouteId(withdrawal.routeId),
        amount: withdrawal.amount,
        recipient: withdrawal.ethereumRecipient,
      });
      this.store.markProcessed(key);
      relayed += 1;
      this.logger.info?.(`relayed finalized ${withdrawal.symbol ?? 'GOLD'} withdrawal ${withdrawal.withdrawalId}`);
    }
    if (finalized.length > 0) {
      this.store.setCursor('goldWithdrawals', Math.max(...finalized.map((event) => event.blockNumber)) + 1);
    }
    return relayed;
  }

  async runOnce() {
    const depositsRelayed = await this.relayDeposits();
    const withdrawalsRelayed = await this.relayWithdrawals();
    await this.store.save();
    return { depositsRelayed, withdrawalsRelayed };
  }
}
