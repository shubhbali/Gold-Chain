import {
  DEFAULT_GILTCONSENSUS_URL,
  DEFAULT_SEPOLIA_RPC,
  ROOT_ETHER_ADDRESS,
  STATE_RECEIVER_ADDRESS,
  loadAddressBook,
  readBridgeProgress,
  readBridgeLifecycleByStateID,
  readBridgeLifecycleWindow,
  readBridgeChainIDStats,
  readChainmanagerParams,
  rpcProviderFor,
  waitForRpc,
} from './live-bridge-common.mjs';
import { ethers } from 'ethers';

const stateSenderAbi = ['function counter() view returns (uint256)'];
const stateReceiverAbi = ['function lastStateId() view returns (uint256)'];
const childChainManagerAbi = ['function rootToChildToken(address) view returns (address)'];
const LIFECYCLE_WINDOW = Number(process.env.BRIDGE_STATUS_WINDOW || 25);
const BRIDGE_MIN_MAIN_CONFIRMATIONS = 6;
const BRIDGE_MIN_CHILD_CONFIRMATIONS = 10;

async function safe(fn) {
  try {
    return await fn();
  } catch (error) {
    return { error: error?.message || String(error) };
  }
}

async function main() {
  const addressBook = loadAddressBook();
  const sepoliaRpc = process.env.SEPOLIA_RPC_URL || addressBook.meta?.sepoliaRpc || DEFAULT_SEPOLIA_RPC;
  const roughnetRpc =
    process.env.CHILD_RPC_URL
    || process.env.ROUGHNET_RPC_URL
    || addressBook.meta?.childRpc
    || addressBook.meta?.roughnetRpc
    || 'http://127.0.0.1:8545';
  const giltconsensusUrl = process.env.GILTCONSENSUS_URL || DEFAULT_GILTCONSENSUS_URL;

  const sepoliaProvider = rpcProviderFor(sepoliaRpc);
  const roughnetProvider = rpcProviderFor(roughnetRpc);
  const rootStateSender = new ethers.Contract(addressBook.root.stateSender, stateSenderAbi, sepoliaProvider);
  const childStateReceiver = new ethers.Contract(STATE_RECEIVER_ADDRESS, stateReceiverAbi, roughnetProvider);
  const childChainManager = new ethers.Contract(addressBook.child.childChainManager, childChainManagerAbi, roughnetProvider);

  const output = {
    checkedAt: new Date().toISOString(),
    rpc: {
      sepolia: sepoliaRpc,
      childChain: roughnetRpc,
      giltconsensus: giltconsensusUrl,
    },
  };

  output.sepoliaReachable = await safe(async () => {
    await waitForRpc(sepoliaProvider, 'Sepolia', 10000, 1000);
    return true;
  });
  output.childChainReachable = await safe(async () => {
    await waitForRpc(roughnetProvider, 'child chain', 10000, 1000);
    return true;
  });
  output.giltconsensusReachable = await safe(async () => {
    const response = await fetch(new URL('/clerk/event-records/count', giltconsensusUrl), {
      headers: { Accept: 'application/json' },
      signal: AbortSignal.timeout(10000),
    });
    if (!response.ok) {
      throw new Error(`giltconsensus returned HTTP ${response.status}`);
    }
    return true;
  });
  output.chainIdValidation = await safe(async () => readBridgeChainIDStats(giltconsensusUrl));

  if (output.sepoliaReachable === true && output.childChainReachable === true) {
    let progressSnapshot = null;
    output.bridgeProgress = await safe(async () => {
      const progress = await readBridgeProgress(rootStateSender, childStateReceiver, giltconsensusUrl);
      progressSnapshot = progress;
      return {
        rootStateId: progress.rootStateId.toString(),
        giltconsensusLatestRecordId: progress.giltconsensusLatestRecordId.toString(),
        giltconsensusLatestProcessed: progress.giltconsensusLatestProcessed,
        giltconsensusRecordCount: progress.giltconsensusRecordCount.toString(),
        childStateId: progress.childStateId.toString(),
      };
    });

    output.bridgeSafetyWindow = await safe(async () => {
      const params = await readChainmanagerParams(giltconsensusUrl);
      const hardeningViolations = [];
      if (params.mainChainTxConfirmations < BRIDGE_MIN_MAIN_CONFIRMATIONS) {
        hardeningViolations.push('main_chain_confirmations_below_minimum');
      }
      if (params.giltChainTxConfirmations < BRIDGE_MIN_CHILD_CONFIRMATIONS) {
        hardeningViolations.push('child_chain_confirmations_below_minimum');
      }

      return {
        mainChainTxConfirmations: String(params.mainChainTxConfirmations),
        giltChainTxConfirmations: String(params.giltChainTxConfirmations),
        finalitySource: 'ethereum_finalized_primary_confirmations_fallback',
        hardeningViolations,
      };
    });

    output.bridgeEventState = await safe(async () => {
      if (!progressSnapshot) {
        throw new Error('bridge progress unavailable');
      }

      const rootStateId = BigInt(progressSnapshot.rootStateId);
      const childStateId = BigInt(progressSnapshot.childStateId);
      const latestRecordId = BigInt(progressSnapshot.giltconsensusLatestRecordId);

      let state = 'pending_confirmations';
      let summary = 'No record has been finalized yet.';
      let recordSeen = false;
      let recordProcessed = false;

      if (rootStateId === 0n) {
        state = 'completed';
        summary = 'No bridge events emitted yet.';
      } else {
        const lifecycleRecord = await readBridgeLifecycleByStateID(giltconsensusUrl, rootStateId);
        if (!lifecycleRecord) {
          state = 'seen';
          summary = `Root state ${rootStateId.toString()} has not been persisted in canonical lifecycle storage yet.`;
        } else {
          recordSeen = true;
          state = lifecycleRecord.lifecycle_state;
          recordProcessed = state === 'completed';
          summary = `Canonical lifecycle for record ${rootStateId.toString()} is ${state}.`;
        }
      }

      return {
        state,
        summary,
        rootStateId: rootStateId.toString(),
        latestRecordId: latestRecordId.toString(),
        childStateId: childStateId.toString(),
        recordSeen,
        recordProcessed,
        finalitySource: 'ethereum_finalized_primary_confirmations_fallback',
      };
    });

    output.bridgeLifecycle = await safe(async () => {
      if (!progressSnapshot) {
        throw new Error('bridge progress unavailable');
      }

      const rootStateId = BigInt(progressSnapshot.rootStateId);
      const childStateId = BigInt(progressSnapshot.childStateId);
      const latestRecordId = BigInt(progressSnapshot.giltconsensusLatestRecordId);
      const startRecord = latestRecordId > BigInt(LIFECYCLE_WINDOW)
        ? latestRecordId - BigInt(LIFECYCLE_WINDOW) + 1n
        : 1n;
      const lifecycleWindow = latestRecordId > 0n
        ? await readBridgeLifecycleWindow(giltconsensusUrl, startRecord, LIFECYCLE_WINDOW)
        : { records: [], aggregates: {} };

      return {
        schemaVersion: 2,
        source: 'canonical_lifecycle_store',
        finalitySource: 'ethereum_finalized_primary_confirmations_fallback',
        window: {
          size: LIFECYCLE_WINDOW,
          fromRecordId: latestRecordId > 0n ? startRecord.toString() : '0',
          toRecordId: latestRecordId.toString(),
        },
        aggregates: lifecycleWindow.aggregates || {},
        latest: {
          rootStateId: rootStateId.toString(),
          latestRecordId: latestRecordId.toString(),
          childStateId: childStateId.toString(),
        },
        records: lifecycleWindow.records || [],
      };
    });

    output.childMappings = await safe(async () => ({
      paxg: await childChainManager.rootToChildToken(addressBook.root.paxg),
      xaut: await childChainManager.rootToChildToken(addressBook.root.xaut),
      usdc: await childChainManager.rootToChildToken(addressBook.root.usdc),
      usdt: await childChainManager.rootToChildToken(addressBook.root.usdt),
      eth: await childChainManager.rootToChildToken(ROOT_ETHER_ADDRESS),
      wrappedGilt: await childChainManager.rootToChildToken(addressBook.root.wrappedGilt),
    }));
  } else {
    output.bridgeProgress = { skipped: 'requires both Sepolia and child-chain RPCs' };
    output.bridgeEventState = { skipped: 'requires both Sepolia and child-chain RPCs' };
    output.bridgeLifecycle = { skipped: 'requires both Sepolia and child-chain RPCs' };
    output.childMappings = { skipped: 'requires child-chain RPC' };
  }

  console.log(JSON.stringify(output, null, 2));
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
