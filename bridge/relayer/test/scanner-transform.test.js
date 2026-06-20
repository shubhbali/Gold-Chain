import assert from 'node:assert/strict';
import { test } from 'node:test';
import { EVENT_TOPICS } from '../src/constants.js';
import { SCANNER_EVENT_TOPICS, scanFinalizedBridgeRows, scannerBridgeRowFromFinalizedEvent } from '../src/scanner-transform.js';

const ROOT_CHAIN_ID = 31337;
const CHILD_CHAIN_ID = 7777778;
const ROOT_BRIDGE = '0x0000000000000000000000000000000000000abc';
const CHILD_BRIDGE = '0x0000000000000000000000000000000000000def';
const USER = '0x00000000000000000000000000000000000000a1';
const GOLD_RECIPIENT = '0x00000000000000000000000000000000000000b1';
const ETH_RECIPIENT = '0x00000000000000000000000000000000000000c1';

function bytes32(prefix, nonce) { return `0x${prefix}${String(nonce).padStart(64 - prefix.length, '0')}`; }

function baseEvent(overrides) {
  const id = overrides.depositId ?? overrides.withdrawalId ?? bytes32('aa', 1);
  return {
    protocolTransferId: id,
    messageId: id,
    routeId: 1,
    amount: 125n,
    blockNumber: 10,
    sourceBlockNumber: 10,
    blockHash: bytes32('bb', 10),
    txHash: bytes32('cc', 10),
    logIndex: 0,
    finalized: true,
    safe: true,
    ...overrides,
  };
}

const finality = { minConfirmations: 3, requireFinalizedTag: true };

test('scanner row transform emits only finalized canonical bridge/finality rows', () => {
  const depositId = bytes32('de', 1);
  const withdrawalId = bytes32('fa', 2);
  const rows = scanFinalizedBridgeRows({
    rootHeadBlock: 13,
    childHeadBlock: 12,
    rootFinality: finality,
    childFinality: { minConfirmations: 2, requireFinalizedTag: true },
    rootChainId: ROOT_CHAIN_ID,
    childChainId: CHILD_CHAIN_ID,
    rootBridgeAddress: ROOT_BRIDGE,
    childBridgeAddress: CHILD_BRIDGE,
    rootEvents: [
      baseEvent({
        depositId,
        protocolTransferId: depositId,
        messageId: depositId,
        eventName: 'Deposited',
        topic0: EVENT_TOPICS.DEPOSITED,
        sourceChainId: ROOT_CHAIN_ID,
        emitterAddress: ROOT_BRIDGE,
        from: USER,
        goldRecipient: GOLD_RECIPIENT,
        amount: 125n,
        blockNumber: 10,
        logIndex: 0,
      }),
      baseEvent({
        withdrawalId,
        protocolTransferId: withdrawalId,
        messageId: withdrawalId,
        eventName: 'WithdrawalFinalized',
        topic0: SCANNER_EVENT_TOPICS.WITHDRAWAL_FINALIZED,
        sourceChainId: ROOT_CHAIN_ID,
        emitterAddress: ROOT_BRIDGE,
        recipient: ETH_RECIPIENT,
        amount: 40n,
        blockNumber: 11,
        logIndex: 1,
      }),
    ],
    childEvents: [
      baseEvent({
        depositId,
        protocolTransferId: depositId,
        messageId: depositId,
        eventName: 'DepositFinalized',
        topic0: SCANNER_EVENT_TOPICS.DEPOSIT_FINALIZED,
        sourceChainId: CHILD_CHAIN_ID,
        emitterAddress: CHILD_BRIDGE,
        recipient: GOLD_RECIPIENT,
        amount: 125n,
        blockNumber: 10,
        logIndex: 2,
      }),
      baseEvent({
        withdrawalId,
        protocolTransferId: withdrawalId,
        messageId: withdrawalId,
        eventName: 'WithdrawalInitiated',
        topic0: EVENT_TOPICS.WITHDRAWAL_INITIATED,
        sourceChainId: CHILD_CHAIN_ID,
        emitterAddress: CHILD_BRIDGE,
        account: GOLD_RECIPIENT,
        ethereumRecipient: ETH_RECIPIENT,
        amount: 40n,
        blockNumber: 11,
        logIndex: 3,
      }),
    ],
  });

  assert.deepEqual(rows.map((row) => [row.source_layer, row.direction, row.bridge_state, row.finality_status]), [
    ['root', 'deposit', 'locked', 'finalized'],
    ['child', 'deposit', 'minted_or_credited', 'finalized'],
    ['root', 'withdrawal', 'released', 'finalized'],
    ['child', 'withdrawal', 'burned_or_debited', 'finalized'],
  ]);
  assert.equal(rows[1].event_id, depositId);
  assert.equal(rows[1].canonical_transfer_id, depositId);
  assert.equal(rows[1].protocol_transfer_id, depositId);
  assert.equal(rows[1].route_asset, 'paxg');
  assert.equal(rows[1].root_amount, '125');
  assert.equal(rows[1].gold_amount, '125');
  assert.equal(rows[3].event_id, withdrawalId);
});

test('scanner row transform refuses non-finalized or non-canonical bridge events', () => {
  const depositId = bytes32('de', 3);
  const event = baseEvent({
    depositId,
    protocolTransferId: depositId,
    messageId: depositId,
    eventName: 'Deposited',
    topic0: EVENT_TOPICS.DEPOSITED,
    sourceChainId: ROOT_CHAIN_ID,
    emitterAddress: ROOT_BRIDGE,
    from: USER,
    goldRecipient: GOLD_RECIPIENT,
    blockNumber: 10,
  });

  assert.equal(scannerBridgeRowFromFinalizedEvent({
    chainName: 'ethereum',
    headBlock: 11,
    finality,
    event,
    expected: { eventName: 'Deposited', topic0: EVENT_TOPICS.DEPOSITED, sourceChainId: ROOT_CHAIN_ID, emitterAddress: ROOT_BRIDGE },
  }), null);

  assert.throws(() => scannerBridgeRowFromFinalizedEvent({
    chainName: 'ethereum',
    headBlock: 12,
    finality,
    event: { ...event, topic0: EVENT_TOPICS.WITHDRAWAL_INITIATED },
    expected: { eventName: 'Deposited', topic0: EVENT_TOPICS.DEPOSITED, sourceChainId: ROOT_CHAIN_ID, emitterAddress: ROOT_BRIDGE },
  }), /unexpected topic0/);

  assert.throws(() => scannerBridgeRowFromFinalizedEvent({
    chainName: 'ethereum',
    headBlock: 12,
    finality,
    event: { ...event, protocolTransferId: bytes32('ff', 3) },
    expected: { eventName: 'Deposited', topic0: EVENT_TOPICS.DEPOSITED, sourceChainId: ROOT_CHAIN_ID, emitterAddress: ROOT_BRIDGE },
  }), /protocolTransferId does not match depositId/);
});
