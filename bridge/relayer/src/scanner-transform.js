import { EVENT_TOPICS, goldAmountToRootAmount, normalizeRouteId, rootAmountToGoldAmount } from './constants.js';
import { assertFinalizedEvent } from './finality.js';

const SCANNER_EVENT_TOPICS = Object.freeze({
  ...EVENT_TOPICS,
  DEPOSIT_FINALIZED: '0x9c4ad71a6b370f8c51d930b662bd10003786459e074657747779b1ffc6d232af',
  WITHDRAWAL_FINALIZED: '0x40ddfca8bd184549882d20964a0d844a7d4e8f462d674155c8915d6e70de4544',
});

function isAddress(value) {
  return typeof value === 'string' && /^0x[a-fA-F0-9]{40}$/.test(value);
}

function isBytes32(value) {
  return typeof value === 'string' && /^0x[a-fA-F0-9]{64}$/.test(value);
}

function requireBytes32(value, field, context) {
  if (!isBytes32(value)) throw new Error(`${context} missing valid ${field}`);
  return value.toLowerCase();
}

function routeAsset(routeId) {
  if (routeId === 1) return 'paxg';
  if (routeId === 2) return 'xaut';
  throw new Error(`unsupported scanner routeId ${routeId}`);
}

function requireProtocolTransferId(event, idField, context) {
  const protocolTransferId = requireBytes32(event.protocolTransferId, 'protocolTransferId', context);
  const eventId = requireBytes32(event[idField], idField, context);
  if (protocolTransferId !== eventId) {
    throw new Error(`${context} protocolTransferId does not match ${idField}`);
  }
  if (event.messageId !== undefined && String(event.messageId).toLowerCase() !== protocolTransferId) {
    throw new Error(`${context} messageId does not match protocolTransferId`);
  }
  return protocolTransferId;
}

function baseRow({ event, context, idField, sourceLayer, direction, bridgeState, finalityStatus, rootAmount, goldAmount }) {
  const protocolTransferId = requireProtocolTransferId(event, idField, context);
  const routeId = normalizeRouteId(event.routeId);
  requireBytes32(event.txHash, 'txHash', context);
  requireBytes32(event.blockHash, 'blockHash', context);
  if (!Number.isSafeInteger(event.blockNumber) || event.blockNumber < 0) throw new Error(`${context} invalid blockNumber`);
  if (!Number.isSafeInteger(event.logIndex) || event.logIndex < 0) throw new Error(`${context} invalid logIndex`);
  if (typeof rootAmount !== 'bigint' || rootAmount < 0n) throw new Error(`${context} invalid rootAmount`);
  if (typeof goldAmount !== 'bigint' || goldAmount < 0n) throw new Error(`${context} invalid goldAmount`);

  return {
    event_id: protocolTransferId,
    canonical_transfer_id: protocolTransferId,
    protocol_transfer_id: protocolTransferId,
    transaction_hash: event.txHash.toLowerCase(),
    block_number: event.blockNumber,
    log_index: event.logIndex,
    source_layer: sourceLayer,
    direction,
    bridge_state: bridgeState,
    finality_status: finalityStatus,
    route_id: routeId,
    route_asset: routeAsset(routeId),
    root_amount: rootAmount.toString(),
    gold_amount: goldAmount.toString(),
  };
}

function assertEventShape(event, expected, context) {
  if (event.eventName !== expected.eventName) throw new Error(`${context} unexpected eventName ${event.eventName}`);
  if (String(event.topic0 ?? '').toLowerCase() !== expected.topic0.toLowerCase()) throw new Error(`${context} unexpected topic0 ${event.topic0}`);
  if (event.sourceChainId !== expected.sourceChainId) throw new Error(`${context} unexpected chainId ${event.sourceChainId}`);
  if (String(event.emitterAddress ?? '').toLowerCase() !== expected.emitterAddress.toLowerCase()) throw new Error(`${context} unexpected emitter ${event.emitterAddress}`);
}

export function scannerBridgeRowFromFinalizedEvent({ chainName, headBlock, finality, event, expected }) {
  const finalityResult = assertFinalizedEvent({ chainName, headBlock, event, finality });
  if (!finalityResult.finalized) return null;

  const context = `${chainName}:${event.eventName ?? '<unknown>'}`;
  assertEventShape(event, expected, context);

  switch (event.eventName) {
    case 'Deposited': {
      const routeId = normalizeRouteId(event.routeId);
      return baseRow({
        event,
        context,
        idField: 'depositId',
        sourceLayer: 'root',
        direction: 'deposit',
        bridgeState: 'locked',
        finalityStatus: 'finalized',
        rootAmount: event.amount,
        goldAmount: rootAmountToGoldAmount(routeId, event.amount),
      });
    }
    case 'DepositFinalized': {
      const routeId = normalizeRouteId(event.routeId);
      return baseRow({
        event,
        context,
        idField: 'depositId',
        sourceLayer: 'child',
        direction: 'deposit',
        bridgeState: 'minted_or_credited',
        finalityStatus: 'finalized',
        rootAmount: goldAmountToRootAmount(routeId, event.amount),
        goldAmount: event.amount,
      });
    }
    case 'WithdrawalInitiated': {
      const routeId = normalizeRouteId(event.routeId);
      return baseRow({
        event,
        context,
        idField: 'withdrawalId',
        sourceLayer: 'child',
        direction: 'withdrawal',
        bridgeState: 'burned_or_debited',
        finalityStatus: 'finalized',
        rootAmount: goldAmountToRootAmount(routeId, event.amount),
        goldAmount: event.amount,
      });
    }
    case 'WithdrawalFinalized': {
      const routeId = normalizeRouteId(event.routeId);
      return baseRow({
        event,
        context,
        idField: 'withdrawalId',
        sourceLayer: 'root',
        direction: 'withdrawal',
        bridgeState: 'released',
        finalityStatus: 'finalized',
        rootAmount: event.amount,
        goldAmount: rootAmountToGoldAmount(routeId, event.amount),
      });
    }
    default:
      throw new Error(`${context} unsupported scanner bridge event`);
  }
}

export function scanFinalizedBridgeRows({ rootHeadBlock, childHeadBlock, rootFinality, childFinality, rootEvents = [], childEvents = [], rootChainId, childChainId, rootBridgeAddress, childBridgeAddress }) {
  const rows = [];
  for (const event of rootEvents) {
    const expected = event.eventName === 'WithdrawalFinalized'
      ? { eventName: 'WithdrawalFinalized', topic0: SCANNER_EVENT_TOPICS.WITHDRAWAL_FINALIZED, sourceChainId: rootChainId, emitterAddress: rootBridgeAddress }
      : { eventName: 'Deposited', topic0: EVENT_TOPICS.DEPOSITED, sourceChainId: rootChainId, emitterAddress: rootBridgeAddress };
    const row = scannerBridgeRowFromFinalizedEvent({ chainName: 'ethereum', headBlock: rootHeadBlock, finality: rootFinality, event, expected });
    if (row) rows.push(row);
  }
  for (const event of childEvents) {
    const expected = event.eventName === 'DepositFinalized'
      ? { eventName: 'DepositFinalized', topic0: SCANNER_EVENT_TOPICS.DEPOSIT_FINALIZED, sourceChainId: childChainId, emitterAddress: childBridgeAddress }
      : { eventName: 'WithdrawalInitiated', topic0: EVENT_TOPICS.WITHDRAWAL_INITIATED, sourceChainId: childChainId, emitterAddress: childBridgeAddress };
    const row = scannerBridgeRowFromFinalizedEvent({ chainName: 'goldChain', headBlock: childHeadBlock, finality: childFinality, event, expected });
    if (row) rows.push(row);
  }
  return rows.sort((a, b) => a.block_number - b.block_number || a.log_index - b.log_index || a.source_layer.localeCompare(b.source_layer));
}

export { SCANNER_EVENT_TOPICS };
