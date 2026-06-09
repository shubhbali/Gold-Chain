import { promises as fs } from 'node:fs';
import { validateRelayerConfig } from './config.js';
import { GoldBridgeRelayer } from './relayer.js';
import { JsonRelayerStore } from './store.js';

class RpcAdapterPlaceholder {
  constructor(name) { this.name = name; }
  unsupported() {
    throw new Error(`${this.name} RPC adapter is not wired in this package yet; instantiate GoldBridgeRelayer with production clients that implement the relayer client interface`);
  }
  async getHeadBlock() { this.unsupported(); }
  async getDeposits() { this.unsupported(); }
  async getWithdrawals() { this.unsupported(); }
  async finalizeDeposit() { this.unsupported(); }
  async finalizeWithdrawal() { this.unsupported(); }
}

export async function loadConfig(configPath) {
  if (!configPath) throw new Error('config path is required');
  const raw = await fs.readFile(configPath, 'utf8');
  return validateRelayerConfig(JSON.parse(raw));
}

export async function main(argv = process.argv.slice(2)) {
  const configPath = argv[0] ?? process.env.GOLD_BRIDGE_RELAYER_CONFIG;
  const config = await loadConfig(configPath);
  const store = new JsonRelayerStore(config.statePath ?? './relayer-state.json');
  await store.load();

  // The relayer core is production-safe and finality-gated. Concrete signing/RPC clients
  // are injected by deployment code so tests cannot accidentally become production paths.
  const relayer = new GoldBridgeRelayer({
    ethereumClient: new RpcAdapterPlaceholder('ethereum'),
    goldChainClient: new RpcAdapterPlaceholder('goldChain'),
    ethereumFinality: config.ethereum.finality,
    goldChainFinality: config.goldChain.finality,
    store,
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
