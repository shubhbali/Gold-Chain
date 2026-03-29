import {
  DEFAULT_HEIMDALL_URL,
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
  const roughnetRpc = process.env.ROUGHNET_RPC_URL || addressBook.meta?.roughnetRpc || 'http://127.0.0.1:8545';
  const heimdallUrl = process.env.HEIMDALL_URL || DEFAULT_HEIMDALL_URL;

  const sepoliaProvider = rpcProviderFor(sepoliaRpc);
  const roughnetProvider = rpcProviderFor(roughnetRpc);
  const rootStateSender = new ethers.Contract(addressBook.root.stateSender, stateSenderAbi, sepoliaProvider);
  const childStateReceiver = new ethers.Contract(STATE_RECEIVER_ADDRESS, stateReceiverAbi, roughnetProvider);
  const childChainManager = new ethers.Contract(addressBook.child.childChainManager, childChainManagerAbi, roughnetProvider);

  const output = {
    checkedAt: new Date().toISOString(),
    rpc: {
      sepolia: sepoliaRpc,
      roughnet: roughnetRpc,
      heimdall: heimdallUrl,
    },
  };

  output.sepoliaReachable = await safe(async () => {
    await waitForRpc(sepoliaProvider, 'Sepolia', 10000, 1000);
    return true;
  });
  output.roughnetReachable = await safe(async () => {
    await waitForRpc(roughnetProvider, 'roughnet', 10000, 1000);
    return true;
  });
  output.heimdallReachable = await safe(async () => {
    const response = await fetch(new URL('/clerk/event-records/count', heimdallUrl), {
      headers: { Accept: 'application/json' },
      signal: AbortSignal.timeout(10000),
    });
    if (!response.ok) {
      throw new Error(`heimdall returned HTTP ${response.status}`);
    }
    return true;
  });

  if (output.sepoliaReachable === true && output.roughnetReachable === true) {
    output.bridgeProgress = await safe(async () => {
      const progress = await readBridgeProgress(rootStateSender, childStateReceiver, heimdallUrl);
      return {
        rootStateId: progress.rootStateId.toString(),
        heimdallLatestRecordId: progress.heimdallLatestRecordId.toString(),
        heimdallLatestProcessed: progress.heimdallLatestProcessed,
        heimdallRecordCount: progress.heimdallRecordCount.toString(),
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
    output.bridgeProgress = { skipped: 'requires both Sepolia and roughnet RPCs' };
    output.childMappings = { skipped: 'requires roughnet RPC' };
  }

  console.log(JSON.stringify(output, null, 2));
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
