#!/usr/bin/env node
'use strict';

const fs = require('fs');
const http = require('http');
const https = require('https');
const { spawnSync } = require('child_process');
const path = require('path');
const crypto = require('crypto');

const ROOT = path.resolve(__dirname, '../..');

function usage() {
  console.error(`Usage: node chain/scripts/persistent-testnet-acceptance.js [options]

Persistent testnet acceptance checker. It never deletes an existing datadir unless
--reset-datadir-confirmed is explicitly supplied.

Options:
  --network <testnet|mainnet>       Network to generate/check (default: testnet)
  --datadir <dir>                   Persistent datadir to preflight/init (optional)
  --rpc <url>                       JSON-RPC endpoint to check (default: http://127.0.0.1:8545)
  --target-block <n>                Required head block (default: 10000)
  --timeout-seconds <n>             Wait time for block target/receipt (default: 600)
  --interval-seconds <n>            Poll interval (default: 5)
  --init-datadir                    Initialize empty datadir from generated genesis
  --reset-datadir-confirmed         Allow destructive datadir reset before init
  --offline                         Only run generated-genesis/datadir/preflight checks; skip RPC
  --require-rpc                     Fail before offline exit unless an explicit --rpc/GOLD_ACCEPTANCE_RPC is supplied
  --require-tx                      Fail if a fresh eth_sendTransaction receipt cannot be produced
  --expected-chain-id <n>           Require generated/RPC chainId to equal this value
  --expected-genesis-hash <hash>    Require RPC genesis block hash to equal this hash
  --proof-out <file>                Write machine-readable acceptance proof JSON
  --launch-mode                     Mainnet-grade launch proof mode: requires RPC and fresh tx
  --tx-from <address>               Sender for eth_sendTransaction (default: first eth_accounts entry)
  --tx-to <address>                 Recipient for fresh tx (default: tx-from)
  --help                            Show this help
`);
  process.exit(2);
}

function args() {
  const out = {
    network: 'testnet',
    datadir: null,
    datadirProvided: false,
    rpc: process.env.GOLD_ACCEPTANCE_RPC || 'http://127.0.0.1:8545',
    rpcProvided: Boolean(process.env.GOLD_ACCEPTANCE_RPC),
    targetBlock: 10000,
    timeoutSeconds: 600,
    intervalSeconds: 5,
    initDatadir: false,
    resetDatadir: false,
    offline: false,
    requireRpc: false,
    requireTx: false,
    launchMode: false,
    expectedChainId: null,
    expectedGenesisHash: null,
    proofOut: null,
    txFrom: null,
    txTo: null,
  };
  for (let i = 2; i < process.argv.length; i++) {
    const a = process.argv[i];
    const next = () => {
      if (!process.argv[i + 1]) usage();
      return process.argv[++i];
    };
    if (a === '--help' || a === '-h') usage();
    else if (a === '--network') out.network = next();
    else if (a === '--datadir') { out.datadir = next(); out.datadirProvided = true; }
    else if (a === '--rpc') { out.rpc = next(); out.rpcProvided = true; }
    else if (a === '--target-block') out.targetBlock = Number(next());
    else if (a === '--timeout-seconds') out.timeoutSeconds = Number(next());
    else if (a === '--interval-seconds') out.intervalSeconds = Number(next());
    else if (a === '--init-datadir') out.initDatadir = true;
    else if (a === '--reset-datadir-confirmed') out.resetDatadir = true;
    else if (a === '--offline') out.offline = true;
    else if (a === '--require-rpc') out.requireRpc = true;
    else if (a === '--require-tx') out.requireTx = true;
    else if (a === '--expected-chain-id') out.expectedChainId = Number(next());
    else if (a === '--expected-genesis-hash') out.expectedGenesisHash = next().toLowerCase();
    else if (a === '--proof-out') out.proofOut = path.resolve(ROOT, next());
    else if (a === '--launch-mode') { out.requireRpc = true; out.requireTx = true; out.launchMode = true; }
    else if (a === '--tx-from') out.txFrom = next();
    else if (a === '--tx-to') out.txTo = next();
    else usage();
  }
  if (!['testnet', 'mainnet'].includes(out.network)) usage();
  if (out.expectedChainId !== null && (!Number.isFinite(out.expectedChainId) || out.expectedChainId <= 0)) throw new Error('expectedChainId must be a positive number');
  if (out.expectedGenesisHash !== null && !/^0x[0-9a-f]{64}$/.test(out.expectedGenesisHash)) throw new Error('expectedGenesisHash must be a 32-byte hex hash');
  for (const k of ['targetBlock', 'timeoutSeconds', 'intervalSeconds']) {
    if (!Number.isFinite(out[k]) || out[k] < 0) throw new Error(`${k} must be a non-negative number`);
  }
  if (out.datadir) out.datadir = path.resolve(ROOT, out.datadir);
  if (out.launchMode && !out.proofOut) throw new Error('--launch-mode requires --proof-out for machine-readable launch evidence');
  if (out.launchMode && out.expectedChainId === null) throw new Error('--launch-mode requires --expected-chain-id');
  if (out.launchMode && out.expectedGenesisHash === null) throw new Error('--launch-mode requires --expected-genesis-hash');
  return out;
}

function run(cmd, cmdArgs, opts = {}) {
  const res = spawnSync(cmd, cmdArgs, { cwd: ROOT, stdio: opts.capture ? ['ignore', 'pipe', 'pipe'] : 'inherit', encoding: 'utf8' });
  if (res.status !== 0) {
    const msg = opts.capture ? `${res.stderr || ''}${res.stdout || ''}`.trim() : '';
    throw new Error(`command failed: ${cmd} ${cmdArgs.join(' ')}${msg ? `\n${msg}` : ''}`);
  }
  return res.stdout || '';
}

function sha256(file) {
  return crypto.createHash('sha256').update(fs.readFileSync(file)).digest('hex');
}

function loadJson(file) {
  return JSON.parse(fs.readFileSync(file, 'utf8'));
}

function validatorsFromExtraData(extraData) {
  if (!/^0x[0-9a-fA-F]+$/.test(extraData || '')) throw new Error('genesis.extraData missing or invalid');
  const hex = extraData.slice(2);
  if (hex.length < 64 + 130) throw new Error('extraData too short for Parlia validator list');
  const validatorHex = hex.slice(64, -130);
  if (validatorHex.length % 40 !== 0) throw new Error('extraData validator bytes are not address-aligned');
  const vals = [];
  for (let i = 0; i < validatorHex.length; i += 40) vals.push(`0x${validatorHex.slice(i, i + 40)}`.toLowerCase());
  return vals;
}

function datadirHasChainData(datadir) {
  return fs.existsSync(path.join(datadir, 'geth', 'chaindata')) ||
    fs.existsSync(path.join(datadir, 'chaindata')) ||
    fs.existsSync(path.join(datadir, 'geth', 'lightchaindata'));
}

function removeRecursive(dir) {
  fs.rmSync(dir, { recursive: true, force: true });
}

function resolveGeth() {
  const candidates = [
    process.env.GETH,
    path.join(ROOT, 'gilt-chain/build/bin/geth'),
    path.join(ROOT, 'gilt-chain/build/bin/gilt'),
    'geth',
  ].filter(Boolean);
  for (const c of candidates) {
    const res = spawnSync(c, ['version'], { stdio: 'ignore' });
    if (res.status === 0) return c;
  }
  return null;
}

function initDatadir(datadir, genesisPath, allowReset) {
  if (fs.existsSync(datadir) && datadirHasChainData(datadir)) {
    if (!allowReset) {
      console.log(`PASS datadir non-destructive check: existing chain data preserved at ${path.relative(ROOT, datadir)}`);
      return { initialized: false, preserved: true };
    }
    console.log(`RESET confirmed: removing existing datadir ${path.relative(ROOT, datadir)}`);
    removeRecursive(datadir);
  } else if (fs.existsSync(datadir) && allowReset) {
    console.log(`RESET confirmed: removing existing non-chain datadir ${path.relative(ROOT, datadir)}`);
    removeRecursive(datadir);
  }
  fs.mkdirSync(datadir, { recursive: true });
  const geth = resolveGeth();
  if (!geth) throw new Error('cannot initialize datadir: set GETH or build gilt-chain/build/bin/geth');
  run(geth, ['--datadir', datadir, 'init', genesisPath]);
  console.log(`PASS initialized datadir ${path.relative(ROOT, datadir)} from generated genesis`);
  return { initialized: true, preserved: false };
}

function rpc(url, method, params = []) {
  return new Promise((resolve, reject) => {
    const body = JSON.stringify({ jsonrpc: '2.0', id: 1, method, params });
    const u = new URL(url);
    const lib = u.protocol === 'https:' ? https : http;
    const req = lib.request({
      method: 'POST', hostname: u.hostname, port: u.port, path: `${u.pathname}${u.search}`,
      headers: { 'content-type': 'application/json', 'content-length': Buffer.byteLength(body) },
      timeout: 15000,
    }, res => {
      let data = '';
      res.setEncoding('utf8');
      res.on('data', chunk => { data += chunk; });
      res.on('end', () => {
        try {
          const parsed = JSON.parse(data);
          if (parsed.error) reject(new Error(`${method}: ${parsed.error.message || JSON.stringify(parsed.error)}`));
          else resolve(parsed.result);
        } catch (e) {
          reject(new Error(`${method}: invalid RPC response: ${data.slice(0, 200)}`));
        }
      });
    });
    req.on('error', reject);
    req.on('timeout', () => req.destroy(new Error(`${method}: RPC timeout`)));
    req.write(body);
    req.end();
  });
}

const sleep = ms => new Promise(resolve => setTimeout(resolve, ms));
const hexNum = h => Number.parseInt(String(h || '0x0'), 16);

async function waitForBlock(url, target, timeoutSeconds, intervalSeconds) {
  const deadline = Date.now() + timeoutSeconds * 1000;
  let current = hexNum(await rpc(url, 'eth_blockNumber'));
  while (current < target && Date.now() < deadline) {
    console.log(`WAIT block progress: current=${current} target=${target}`);
    await sleep(intervalSeconds * 1000);
    current = hexNum(await rpc(url, 'eth_blockNumber'));
  }
  if (current < target) throw new Error(`block progress target not met: current=${current}, target=${target}`);
  console.log(`PASS block progress: current=${current}, target=${target}`);
  return current;
}

async function freshTx(url, opts, rpcClient = rpc) {
  let from = opts.txFrom;
  if (!from) {
    const accounts = await rpcClient(url, 'eth_accounts');
    if (Array.isArray(accounts) && accounts.length) from = accounts[0];
  }
  if (!from) {
    const msg = 'fresh transaction skipped: no --tx-from and eth_accounts returned no unlocked accounts';
    if (opts.requireTx) throw new Error(msg);
    console.log(`WARN ${msg}`);
    return { skipped: true };
  }
  const to = opts.txTo || from;
  const txHash = await rpcClient(url, 'eth_sendTransaction', [{ from, to, value: '0x0' }]);
  const deadline = Date.now() + opts.timeoutSeconds * 1000;
  let receipt = null;
  while (!receipt && Date.now() < deadline) {
    receipt = await rpcClient(url, 'eth_getTransactionReceipt', [txHash]);
    if (!receipt) await sleep(opts.intervalSeconds * 1000);
  }
  if (!receipt) throw new Error(`fresh transaction was not included before timeout: ${txHash}`);
  if (receipt.status !== '0x1') throw new Error(`fresh transaction failed: hash=${txHash} status=${receipt.status}`);
  console.log(`PASS fresh transaction receipt: hash=${txHash} block=${hexNum(receipt.blockNumber)} status=${receipt.status}`);
  return { txHash, receipt };
}

function writeProof(file, proof) {
  fs.mkdirSync(path.dirname(file), { recursive: true });
  fs.writeFileSync(file, `${JSON.stringify(proof, null, 2)}\n`);
}

async function main() {
  const opts = args();
  if (opts.offline && opts.requireRpc) throw new Error('--require-rpc/--launch-mode forbids offline acceptance');
  if (opts.requireRpc && !opts.rpcProvided) {
    throw new Error('--require-rpc/--launch-mode requires explicit --rpc or GOLD_ACCEPTANCE_RPC; refusing implicit localhost proof');
  }
  const genesisPath = path.join(ROOT, 'chain/genesis/out', opts.network, 'genesis.json');
  const validatorsPath = path.join(ROOT, 'chain/genesis/out', opts.network, 'validators.conf');

  run('node', ['chain/genesis/build-genesis.js', '--network', opts.network]);
  if (!fs.existsSync(genesisPath) || !fs.existsSync(validatorsPath)) throw new Error('genesis builder did not produce expected outputs');

  const genesis = loadJson(genesisPath);
  const chainId = Number(genesis.config && genesis.config.chainId);
  if (!chainId || chainId === 56) throw new Error(`invalid Gold Chain chainId in generated genesis: ${chainId}`);
  if (opts.expectedChainId !== null && chainId !== opts.expectedChainId) throw new Error(`generated chainId mismatch: generated=${chainId}, expected=${opts.expectedChainId}`);
  const validators = validatorsFromExtraData(genesis.extraData);
  const genesisSha = sha256(genesisPath);
  console.log(`PASS generated genesis: network=${opts.network} chainId=${chainId} validators=${validators.length} sha256=${genesisSha}`);

  const preflightArgs = ['chain/scripts/preflight-validators.js', '--genesis', genesisPath, '--validators', validatorsPath];
  if (opts.datadir && fs.existsSync(opts.datadir)) preflightArgs.push('--datadir', opts.datadir);
  run('node', preflightArgs);

  if (opts.initDatadir || opts.resetDatadir) {
    if (!opts.datadir) throw new Error('--init-datadir/--reset-datadir-confirmed requires --datadir');
    initDatadir(opts.datadir, genesisPath, opts.resetDatadir);
  } else if (opts.datadir && fs.existsSync(opts.datadir)) {
    console.log(`PASS datadir non-destructive check: no init/reset requested for ${path.relative(ROOT, opts.datadir)}`);
  } else if (opts.datadir) {
    console.log(`WARN datadir ${path.relative(ROOT, opts.datadir)} does not exist; use --init-datadir to initialize it non-destructively`);
  } else {
    console.log('WARN no --datadir supplied; local signer preflight and datadir preservation checks were not run');
  }

  if (opts.offline) {
    console.log('PASS offline persistent-testnet acceptance checks');
    return;
  }

  const rpcChainId = hexNum(await rpc(opts.rpc, 'eth_chainId'));
  if (rpcChainId !== chainId) throw new Error(`RPC chainId mismatch: rpc=${rpcChainId}, generated=${chainId}`);
  if (opts.expectedChainId !== null && rpcChainId !== opts.expectedChainId) throw new Error(`RPC chainId mismatch: rpc=${rpcChainId}, expected=${opts.expectedChainId}`);
  console.log(`PASS RPC chainId: ${rpcChainId}`);

  const genesisBlock = await rpc(opts.rpc, 'eth_getBlockByNumber', ['0x0', false]);
  if (!genesisBlock || !/^0x[0-9a-fA-F]{64}$/.test(genesisBlock.hash || '')) throw new Error('RPC did not return a valid genesis block hash');
  const rpcGenesisHash = genesisBlock.hash.toLowerCase();
  if (opts.expectedGenesisHash !== null && rpcGenesisHash !== opts.expectedGenesisHash) throw new Error(`RPC genesis hash mismatch: rpc=${rpcGenesisHash}, expected=${opts.expectedGenesisHash}`);
  console.log(`PASS RPC genesis block hash: ${rpcGenesisHash}`);

  const headBlock = await waitForBlock(opts.rpc, opts.targetBlock, opts.timeoutSeconds, opts.intervalSeconds);
  const tx = await freshTx(opts.rpc, opts);
  const proof = {
    status: 'pass',
    mode: opts.launchMode ? 'launch' : 'acceptance',
    generatedAt: new Date().toISOString(),
    network: opts.network,
    rpc: opts.rpc,
    chainId,
    genesisSha256: genesisSha,
    rpcGenesisHash,
    validators: validators.length,
    headBlock,
    freshTransaction: tx,
  };
  if (opts.proofOut) {
    writeProof(opts.proofOut, proof);
    console.log(`PASS wrote acceptance proof: ${path.relative(ROOT, opts.proofOut)}`);
  }
  console.log('PASS persistent-testnet acceptance checks');
}

if (require.main === module) {
  main().catch(err => {
    console.error(`PERSISTENT TESTNET ACCEPTANCE FAIL: ${err.message}`);
    process.exit(1);
  });
}

module.exports = { freshTx, writeProof };
