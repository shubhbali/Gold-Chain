import { EVENT_TOPICS, eventKey, FLOW, normalizeRouteId } from './constants.js';
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

function isAddress(value) {
  return typeof value === 'string' && /^0x[a-fA-F0-9]{40}$/.test(value);
}

function isBytes32(value) {
  return typeof value === 'string' && /^0x[a-fA-F0-9]{64}$/.test(value);
}

function validateBridgeEvent(event, idField, routes, expected) {
  if (!event || !isBytes32(event[idField])) {
    throw new Error(`bridge event missing valid ${idField}`);
  }
  if (event.messageId !== undefined && event.messageId.toLowerCase() !== event[idField].toLowerCase()) {
    throw new Error(`bridge event ${event[idField]} messageId mismatch`);
  }
  if (event.sourceChainId !== expected.sourceChainId) {
    throw new Error(`bridge event ${event[idField]} unexpected chainId ${event.sourceChainId}`);
  }
  if (String(event.emitterAddress ?? '').toLowerCase() !== expected.emitterAddress.toLowerCase()) {
    throw new Error(`bridge event ${event[idField]} unexpected emitter ${event.emitterAddress}`);
  }
  if (event.eventName !== expected.eventName) {
    throw new Error(`bridge event ${event[idField]} unexpected eventName ${event.eventName}`);
  }
  if (String(event.topic0 ?? '').toLowerCase() !== expected.topic0.toLowerCase()) {
    throw new Error(`bridge event ${event[idField]} unexpected topic0 ${event.topic0}`);
  }
  if (!isBytes32(event.blockHash)) throw new Error(`bridge event ${event[idField]} missing blockHash`);
  if (!isBytes32(event.txHash)) throw new Error(`bridge event ${event[idField]} missing txHash`);
  if (!Number.isSafeInteger(event.logIndex) || event.logIndex < 0) throw new Error(`bridge event ${event[idField]} invalid logIndex`);
  if (!Number.isSafeInteger(event.sourceBlockNumber ?? event.blockNumber) || (event.sourceBlockNumber ?? event.blockNumber) <= 0) throw new Error(`bridge event ${event[idField]} invalid sourceBlockNumber`);
  if (!Number.isSafeInteger(event.signerSetVersion) || event.signerSetVersion <= 0) throw new Error(`bridge event ${event[idField]} invalid signerSetVersion`);
  if (!Array.isArray(event.signatures) || event.signatures.length === 0) throw new Error(`bridge event ${event[idField]} missing threshold signatures`);
  const routeId = normalizeRouteId(event.routeId);
  const route = routes.get(routeId);
  if (!route) throw new Error(`bridge event ${event[idField]} uses unconfigured route ${routeId}`);
  if (event.symbol !== undefined && event.symbol !== route.symbol) {
    throw new Error(`bridge event ${event[idField]} symbol ${event.symbol} does not match route ${routeId} ${route.symbol}`);
  }
  if (typeof event.amount !== 'bigint' || event.amount <= 0n) throw new Error(`bridge event ${event[idField]} has invalid amount`);
  if (!isAddress(event.recipient)) {
    throw new Error(`bridge event ${event[idField]} has invalid recipient`);
  }
}

export class GoldBridgeRelayer {
  constructor({ ethereumClient, goldChainClient, ethereumChainId, goldChainChainId, rootCustodyAddress, childBridgeAddress, ethereumFinality, goldChainFinality, routes, store, logger = console, rescanOverlapBlocks = 0, ethereumStartBlock = 0, goldChainStartBlock = 0 }) {
    requireMethod(ethereumClient, 'getHeadBlock');
    requireMethod(ethereumClient, 'getDeposits');
    requireMethod(ethereumClient, 'finalizeWithdrawal');
    requireMethod(ethereumClient, 'isWithdrawalFinalized');
    requireMethod(goldChainClient, 'getHeadBlock');
    requireMethod(goldChainClient, 'getWithdrawals');
    requireMethod(goldChainClient, 'finalizeDeposit');
    requireMethod(goldChainClient, 'isDepositFinalized');
    if (!store) throw new Error('relayer store is required');
    if (!Number.isSafeInteger(ethereumChainId) || ethereumChainId <= 0) throw new Error('ethereumChainId is required');
    if (!Number.isSafeInteger(goldChainChainId) || goldChainChainId <= 0) throw new Error('goldChainChainId is required');
    if (!isAddress(rootCustodyAddress)) throw new Error('rootCustodyAddress is required');
    if (!isAddress(childBridgeAddress)) throw new Error('childBridgeAddress is required');
    if (!Number.isSafeInteger(rescanOverlapBlocks) || rescanOverlapBlocks < 0) throw new Error('rescanOverlapBlocks must be >= 0');
    if (!Number.isSafeInteger(ethereumStartBlock) || ethereumStartBlock < 0) throw new Error('ethereumStartBlock must be >= 0');
    if (!Number.isSafeInteger(goldChainStartBlock) || goldChainStartBlock < 0) throw new Error('goldChainStartBlock must be >= 0');
    if (!ethereumFinality?.minConfirmations || !goldChainFinality?.minConfirmations) {
      throw new Error('explicit finality policies are required for both chains');
    }
    this.ethereumClient = ethereumClient;
    this.goldChainClient = goldChainClient;
    this.ethereumChainId = ethereumChainId;
    this.goldChainChainId = goldChainChainId;
    this.rootCustodyAddress = rootCustodyAddress;
    this.childBridgeAddress = childBridgeAddress;
    this.rescanOverlapBlocks = rescanOverlapBlocks;
    this.ethereumStartBlock = ethereumStartBlock;
    this.goldChainStartBlock = goldChainStartBlock;
    this.ethereumFinality = ethereumFinality;
    this.goldChainFinality = goldChainFinality;
    this.routes = normalizeRoutes(routes);
    this.store = store;
    this.logger = logger;
  }

  async relayDeposits() {
    const headBlock = await this.ethereumClient.getHeadBlock();
    const cursor = this.store.getCursor('ethereumDeposits', this.ethereumStartBlock);
    const fromBlock = Math.max(0, cursor - this.rescanOverlapBlocks);
    const deposits = await this.ethereumClient.getDeposits({ fromBlock });
    const finalized = filterFinalizedEvents({ chainName: 'ethereum', headBlock, events: deposits, finality: this.ethereumFinality });
    let relayed = 0;
    for (const deposit of finalized) {
      validateBridgeEvent({ ...deposit, recipient: deposit.goldRecipient }, 'depositId', this.routes, {
        sourceChainId: this.ethereumChainId,
        emitterAddress: this.rootCustodyAddress,
        eventName: 'Deposited',
        topic0: EVENT_TOPICS.DEPOSITED,
      });
      const key = eventKey(FLOW.ROOT_LOCK_TO_CHILD_MINT, deposit.depositId);
      if (this.store.hasProcessed(key)) continue;
      if (await this.goldChainClient.isDepositFinalized({ depositId: deposit.depositId })) {
        this.store.markProcessed(key);
        continue;
      }
      const route = this.routes.get(normalizeRouteId(deposit.routeId));
      await this.goldChainClient.finalizeDeposit({
        depositId: deposit.depositId,
        routeId: normalizeRouteId(deposit.routeId),
        amount: deposit.amount,
        recipient: deposit.goldRecipient,
        proof: {
          rootToken: route.rootToken,
          from: deposit.from,
          sourceBlockNumber: deposit.sourceBlockNumber ?? deposit.blockNumber,
          txHash: deposit.txHash,
          logIndex: deposit.logIndex,
          signerSetVersion: deposit.signerSetVersion,
          signatures: deposit.signatures,
        },
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
    const cursor = this.store.getCursor('goldWithdrawals', this.goldChainStartBlock);
    const fromBlock = Math.max(0, cursor - this.rescanOverlapBlocks);
    const withdrawals = await this.goldChainClient.getWithdrawals({ fromBlock });
    const finalized = filterFinalizedEvents({ chainName: 'goldChain', headBlock, events: withdrawals, finality: this.goldChainFinality });
    let relayed = 0;
    for (const withdrawal of finalized) {
      validateBridgeEvent({ ...withdrawal, recipient: withdrawal.ethereumRecipient }, 'withdrawalId', this.routes, {
        sourceChainId: this.goldChainChainId,
        emitterAddress: this.childBridgeAddress,
        eventName: 'WithdrawalInitiated',
        topic0: EVENT_TOPICS.WITHDRAWAL_INITIATED,
      });
      const key = eventKey(FLOW.CHILD_BURN_TO_ROOT_RELEASE, withdrawal.withdrawalId);
      if (this.store.hasProcessed(key)) continue;
      if (await this.ethereumClient.isWithdrawalFinalized({ withdrawalId: withdrawal.withdrawalId })) {
        this.store.markProcessed(key);
        continue;
      }
      await this.ethereumClient.finalizeWithdrawal({
        withdrawalId: withdrawal.withdrawalId,
        routeId: normalizeRouteId(withdrawal.routeId),
        amount: withdrawal.amount,
        recipient: withdrawal.ethereumRecipient,
        proof: {
          account: withdrawal.account,
          sourceBlockNumber: withdrawal.sourceBlockNumber ?? withdrawal.blockNumber,
          txHash: withdrawal.txHash,
          logIndex: withdrawal.logIndex,
          signerSetVersion: withdrawal.signerSetVersion,
          signatures: withdrawal.signatures,
        },
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
