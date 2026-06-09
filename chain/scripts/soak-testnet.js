#!/usr/bin/env node
'use strict';

const { spawnSync } = require('child_process');
const path = require('path');

const ROOT = path.resolve(__dirname, '../..');
function usage() {
  console.error(`Usage: node chain/scripts/soak-testnet.js [options]

Options:
  --duration-seconds <n>   Soak duration (default: 300)
  --interval-seconds <n>   Check interval (default: 15)
  --rpc <url[,url...]>     RPC endpoints
  --expected-chain-id <n>  Expected chain ID (default: 7777778)
`);
  process.exit(2);
}
function arg(name, def) { const i = process.argv.indexOf(name); return i === -1 ? def : process.argv[i + 1]; }
function run(args) {
  const res = spawnSync('node', ['chain/scripts/healthcheck-testnet.js', ...args], { cwd: ROOT, encoding: 'utf8' });
  if (res.status !== 0) throw new Error(`${res.stderr}${res.stdout}`.trim());
  return `${res.stdout}${res.stderr}`.trim();
}
async function sleep(ms) { return new Promise(r => setTimeout(r, ms)); }
function blockFrom(out) {
  const nums = [...out.matchAll(/block=(\d+)/g)].map(m => Number(m[1]));
  return nums.length ? Math.min(...nums) : 0;
}

async function main() {
  for (const a of process.argv.slice(2)) if (a === '--help' || a === '-h') usage();
  const duration = Number(arg('--duration-seconds', '300'));
  const interval = Number(arg('--interval-seconds', '15'));
  const rpcs = arg('--rpc', 'http://127.0.0.1:8545,http://127.0.0.1:8546,http://127.0.0.1:8547');
  const chainId = arg('--expected-chain-id', '7777778');
  const deadline = Date.now() + duration * 1000;
  let checks = 0;
  let firstBlock = null;
  let lastBlock = null;
  while (Date.now() <= deadline) {
    const out = run(['--rpc', rpcs, '--expected-chain-id', chainId, '--min-peers', '1', '--max-lag', '2']);
    const b = blockFrom(out);
    if (firstBlock === null) firstBlock = b;
    lastBlock = b;
    checks += 1;
    console.log(`PASS soak check ${checks}: minBlock=${b}`);
    if (Date.now() + interval * 1000 > deadline) break;
    await sleep(interval * 1000);
  }
  if (lastBlock <= firstBlock) throw new Error(`chain did not advance during soak: first=${firstBlock} last=${lastBlock}`);
  console.log(`PASS soak: duration=${duration}s checks=${checks} firstBlock=${firstBlock} lastBlock=${lastBlock} advanced=${lastBlock - firstBlock}`);
}

main().catch(err => {
  console.error(`SOAK FAIL: ${err.message}`);
  process.exit(1);
});
