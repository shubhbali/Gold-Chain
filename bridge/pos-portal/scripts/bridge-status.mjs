import {
  DEFAULT_GILTCONSENSUS_URL,
  DEFAULT_SEPOLIA_RPC,
  ROOT_ETHER_ADDRESS,
  STATE_RECEIVER_ADDRESS,
  loadAddressBook,
  readBridgeProgress,
  rpcProviderFor,
  waitForRpc,
} from './live-bridge-common.mjs';
import { ethers } from 'ethers';

const stateSenderAbi = ['function counter() view returns (uint256)'];
const stateReceiverAbi = ['function lastStateId() view returns (uint256)'];
const childChainManagerAbi = ['function rootToChildToken(address) view returns (address)'];

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

  if (output.sepoliaReachable === true && output.childChainReachable === true) {
    output.bridgeProgress = await safe(async () => {
      const progress = await readBridgeProgress(rootStateSender, childStateReceiver, giltconsensusUrl);
      return {
        rootStateId: progress.rootStateId.toString(),
        giltconsensusLatestRecordId: progress.giltconsensusLatestRecordId.toString(),
        giltconsensusLatestProcessed: progress.giltconsensusLatestProcessed,
        giltconsensusRecordCount: progress.giltconsensusRecordCount.toString(),
        childStateId: progress.childStateId.toString(),
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
    output.childMappings = { skipped: 'requires child-chain RPC' };
  }

  console.log(JSON.stringify(output, null, 2));
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
