import { promises as fs } from 'node:fs';
import { validateRelayerConfig } from './config.js';
import { LiveEvmBridgeClient } from './live-rpc-client.js';
import { GoldBridgeRelayer } from './relayer.js';
import { JsonRelayerStore } from './store.js';

export async function loadConfig(configPath) {
  if (!configPath) throw new Error('config path is required');
  const raw = await fs.readFile(configPath, 'utf8');
  return validateRelayerConfig(JSON.parse(raw));
}

function buildClients(config) {
  const signerSetVersion = config.relayer.signerSetVersion ?? 1;
  return {
    ethereumClient: new LiveEvmBridgeClient({
      side: 'ethereum',
      rpcUrl: config.ethereum.rpcUrl,
      keyPath: config.relayer.keyPath,
      sourceChainId: config.ethereum.chainId,
      destinationChainId: config.goldChain.chainId,
      rootCustodyAddress: config.ethereum.rootCustodyAddress,
      childBridgeAddress: config.goldChain.childBridgeAddress,
      routes: config.routes,
      signerSetVersion,
    }),
    goldChainClient: new LiveEvmBridgeClient({
      side: 'goldChain',
      rpcUrl: config.goldChain.rpcUrl,
      keyPath: config.relayer.keyPath,
      sourceChainId: config.goldChain.chainId,
      destinationChainId: config.ethereum.chainId,
      rootCustodyAddress: config.ethereum.rootCustodyAddress,
      childBridgeAddress: config.goldChain.childBridgeAddress,
      routes: config.routes,
      signerSetVersion,
    }),
  };
}

export async function main(argv = process.argv.slice(2)) {
  const configPath = argv[0] ?? process.env.GOLD_BRIDGE_RELAYER_CONFIG;
  const config = await loadConfig(configPath);
  const store = new JsonRelayerStore(config.statePath ?? './relayer-state.json');
  await store.load();

  const { ethereumClient, goldChainClient } = buildClients(config);
  const relayer = new GoldBridgeRelayer({
    ethereumClient,
    goldChainClient,
    ethereumChainId: config.ethereum.chainId,
    goldChainChainId: config.goldChain.chainId,
    rootCustodyAddress: config.ethereum.rootCustodyAddress,
    childBridgeAddress: config.goldChain.childBridgeAddress,
    ethereumFinality: config.ethereum.finality,
    goldChainFinality: config.goldChain.finality,
    routes: config.routes,
    store,
    rescanOverlapBlocks: config.relayer.rescanOverlapBlocks ?? 0,
    ethereumStartBlock: config.ethereum.startBlock,
    goldChainStartBlock: config.goldChain.startBlock,
  });
  return relayer.runOnce();
}

if (import.meta.url === `file://${process.argv[1]}`) {
  main().then((result) => {
    console.log(JSON.stringify(result));
  }).catch((error) => {
    console.error(error.stack || error.message);
    process.exitCode = 1;
  });
}
