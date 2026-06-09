#!/usr/bin/env node
'use strict';

const http = require('http');

function usage() {
  console.error(`Usage: node chain/scripts/healthcheck-testnet.js [options]

Options:
  --rpc <url[,url...]>        RPC endpoints (default: http://127.0.0.1:8545,http://127.0.0.1:8546,http://127.0.0.1:8547)
  --expected-chain-id <n>     Expected chain ID (default: 7777778)
  --min-peers <n>             Minimum peers per node (default: 1)
  --max-lag <n>               Maximum block lag across nodes (default: 2)
  --require-advancing         Require head to advance during the sample window
  --sample-seconds <n>        Sample window for --require-advancing (default: 12)
`);
  process.exit(2);
}

function args() {
  const out = {
    rpcs: ['http://127.0.0.1:8545', 'http://127.0.0.1:8546', 'http://127.0.0.1:8547'],
    expectedChainId: 7777778,
    minPeers: 1,
    maxLag: 2,
    requireAdvancing: false,
    sampleSeconds: 12,
  };
  for (let i = 2; i < process.argv.length; i++) {
    const a = process.argv[i];
    const next = () => process.argv[++i] || usage();
    if (a === '--help' || a === '-h') usage();
    else if (a === '--rpc') out.rpcs = next().split(',').filter(Boolean);
    else if (a === '--expected-chain-id') out.expectedChainId = Number(next());
    else if (a === '--min-peers') out.minPeers = Number(next());
    else if (a === '--max-lag') out.maxLag = Number(next());
    else if (a === '--require-advancing') out.requireAdvancing = true;
    else if (a === '--sample-seconds') out.sampleSeconds = Number(next());
    else usage();
  }
  return out;
}

function rpc(url, method, params = []) {
  return new Promise((resolve, reject) => {
    const body = JSON.stringify({ jsonrpc: '2.0', id: 1, method, params });
    const u = new URL(url);
    const req = http.request({
      method: 'POST', hostname: u.hostname, port: u.port, path: `${u.pathname}${u.search}`,
      headers: { 'content-type': 'application/json', 'content-length': Buffer.byteLength(body) },
      timeout: 5000,
    }, res => {
      let data = '';
      res.on('data', c => { data += c; });
      res.on('end', () => {
        try {
          const j = JSON.parse(data);
          if (j.error) reject(new Error(`${method}: ${j.error.message || JSON.stringify(j.error)}`));
          else resolve(j.result);
        } catch (e) { reject(new Error(`${method}: invalid response ${data.slice(0, 160)}`)); }
      });
    });
    req.on('error', reject);
    req.on('timeout', () => req.destroy(new Error(`${method}: timeout`)));
    req.end(body);
  });
}

const hexNum = h => Number.parseInt(String(h || '0x0'), 16);
const sleep = ms => new Promise(r => setTimeout(r, ms));

async function snapshot(rpcs) {
  const rows = [];
  for (const url of rpcs) {
    const [chainId, block, peers, syncing, coinbase] = await Promise.all([
      rpc(url, 'eth_chainId'),
      rpc(url, 'eth_blockNumber'),
      rpc(url, 'net_peerCount'),
      rpc(url, 'eth_syncing'),
      rpc(url, 'eth_coinbase').catch(() => null),
    ]);
    rows.push({ url, chainId: hexNum(chainId), block: hexNum(block), peers: hexNum(peers), syncing, coinbase });
  }
  return rows;
}

async function main() {
  const opts = args();
  const rows = await snapshot(opts.rpcs);
  for (const r of rows) {
    if (r.chainId !== opts.expectedChainId) throw new Error(`${r.url} chainId=${r.chainId}, expected=${opts.expectedChainId}`);
    if (r.peers < opts.minPeers) throw new Error(`${r.url} peers=${r.peers}, min=${opts.minPeers}`);
    if (r.syncing !== false) throw new Error(`${r.url} syncing=${JSON.stringify(r.syncing)}`);
  }
  const min = Math.min(...rows.map(r => r.block));
  const max = Math.max(...rows.map(r => r.block));
  if (max - min > opts.maxLag) throw new Error(`block lag too high: min=${min} max=${max} maxLag=${opts.maxLag}`);

  if (opts.requireAdvancing) {
    await sleep(opts.sampleSeconds * 1000);
    const later = await snapshot(opts.rpcs);
    for (let i = 0; i < rows.length; i++) {
      if (later[i].block <= rows[i].block) throw new Error(`${rows[i].url} did not advance: before=${rows[i].block} after=${later[i].block}`);
    }
    console.log(`PASS advancing blocks over ${opts.sampleSeconds}s`);
  }

  for (const r of rows) console.log(`PASS ${r.url} chainId=${r.chainId} block=${r.block} peers=${r.peers} syncing=false coinbase=${r.coinbase || 'n/a'}`);
  console.log(`PASS multinode health: nodes=${rows.length} blockRange=${min}-${max} maxLag=${opts.maxLag}`);
}

main().catch(err => {
  console.error(`HEALTHCHECK FAIL: ${err.message}`);
  process.exit(1);
});
