#!/usr/bin/env node
'use strict';

const assert = require('assert');
const fs = require('fs');
const http = require('http');
const os = require('os');
const path = require('path');
const { spawn, spawnSync } = require('child_process');
const test = require('node:test');

const ROOT = path.resolve(__dirname, '../..');
const SCRIPT = path.join(ROOT, 'chain/scripts/persistent-testnet-acceptance.js');
const VALID_HASH = `0x${'11'.repeat(32)}`;

function runAcceptance(args, env = {}) {
  return spawnSync(process.execPath, [SCRIPT, ...args], {
    cwd: ROOT,
    env: { ...process.env, GOLD_ACCEPTANCE_RPC: '', ...env },
    encoding: 'utf8',
  });
}

function runAcceptanceAsync(args, env = {}) {
  return new Promise(resolve => {
    const child = spawn(process.execPath, [SCRIPT, ...args], {
      cwd: ROOT,
      env: { ...process.env, GOLD_ACCEPTANCE_RPC: '', ...env },
      stdio: ['ignore', 'pipe', 'pipe'],
    });
    let stdout = '';
    let stderr = '';
    child.stdout.on('data', chunk => { stdout += chunk; });
    child.stderr.on('data', chunk => { stderr += chunk; });
    child.on('close', status => resolve({ status, stdout, stderr }));
  });
}

function listen(server) {
  return new Promise(resolve => server.listen(0, '127.0.0.1', resolve));
}

test('--launch-mode requires proof, expected chain id, expected genesis hash, and explicit RPC before genesis build', () => {
  let res = runAcceptance(['--launch-mode', '--offline']);
  assert.notStrictEqual(res.status, 0);
  assert.match(res.stderr, /--launch-mode requires --proof-out/);

  res = runAcceptance(['--launch-mode', '--proof-out', '/tmp/gold-launch-proof.json']);
  assert.notStrictEqual(res.status, 0);
  assert.match(res.stderr, /--launch-mode requires --expected-chain-id/);

  res = runAcceptance(['--launch-mode', '--proof-out', '/tmp/gold-launch-proof.json', '--expected-chain-id', '1']);
  assert.notStrictEqual(res.status, 0);
  assert.match(res.stderr, /--launch-mode requires --expected-genesis-hash/);

  res = runAcceptance([
    '--launch-mode',
    '--proof-out', '/tmp/gold-launch-proof.json',
    '--expected-chain-id', '1',
    '--expected-genesis-hash', VALID_HASH,
  ]);
  assert.notStrictEqual(res.status, 0);
  assert.match(res.stderr, /requires explicit --rpc or GOLD_ACCEPTANCE_RPC/);
  assert.doesNotMatch(res.stderr, /canonical predeploy generation failed|missing system contract artifact/);
});

test('--require-rpc forbids offline acceptance before genesis build', () => {
  const res = runAcceptance(['--offline', '--require-rpc', '--proof-out', '/tmp/gold-acceptance-proof.json']);
  assert.notStrictEqual(res.status, 0);
  assert.match(res.stderr, /--require-rpc\/--launch-mode forbids offline acceptance/);
  assert.doesNotMatch(res.stderr, /canonical predeploy generation failed|missing system contract artifact/);
});

test('writeProof writes machine-readable proof JSON', () => {
  const { writeProof } = require('./persistent-testnet-acceptance.js');
  const tmp = fs.mkdtempSync(path.join(os.tmpdir(), 'gold-proof-'));
  const proofPath = path.join(tmp, 'nested', 'proof.json');
  const proof = {
    status: 'pass',
    mode: 'launch',
    network: 'testnet',
    rpc: 'http://127.0.0.1:8545',
    chainId: 17000,
    rpcGenesisHash: VALID_HASH,
    freshTransaction: { txHash: `0x${'22'.repeat(32)}`, receipt: { status: '0x1' } },
  };

  writeProof(proofPath, proof);
  assert.deepStrictEqual(JSON.parse(fs.readFileSync(proofPath, 'utf8')), proof);
  assert.match(fs.readFileSync(proofPath, 'utf8'), /\n$/);
});

test('launch mode checks explicit RPC, expected chain/genesis, fresh tx, and writes proof JSON', async () => {
  const build = spawnSync(process.execPath, ['chain/genesis/build-genesis.js', '--network', 'testnet'], {
    cwd: ROOT,
    encoding: 'utf8',
  });
  assert.strictEqual(build.status, 0, build.stderr || build.stdout);
  const chainId = Number(JSON.parse(fs.readFileSync(path.join(ROOT, 'chain/genesis/out/testnet/genesis.json'), 'utf8')).config.chainId);
  const genesisHash = `0x${'44'.repeat(32)}`;
  const txHash = `0x${'55'.repeat(32)}`;
  const methods = [];
  const server = http.createServer((req, res) => {
    let body = '';
    req.on('data', chunk => { body += chunk; });
    req.on('end', () => {
      const call = JSON.parse(body);
      methods.push(call.method);
      const results = {
        eth_chainId: `0x${chainId.toString(16)}`,
        eth_getBlockByNumber: { hash: genesisHash },
        eth_blockNumber: '0x0',
        eth_accounts: ['0x0000000000000000000000000000000000000001'],
        eth_sendTransaction: txHash,
        eth_getTransactionReceipt: { blockNumber: '0x1', status: '0x1' },
      };
      assert.ok(call.method in results, `unexpected RPC method ${call.method}`);
      res.writeHead(200, { 'content-type': 'application/json' });
      res.end(JSON.stringify({ jsonrpc: '2.0', id: call.id, result: results[call.method] }));
    });
  });
  await listen(server);
  try {
    const tmp = fs.mkdtempSync(path.join(os.tmpdir(), 'gold-launch-proof-'));
    const proofOut = path.join(tmp, 'proof.json');
    const { port } = server.address();
    const res = await runAcceptanceAsync([
      '--launch-mode',
      '--rpc', `http://127.0.0.1:${port}`,
      '--target-block', '0',
      '--timeout-seconds', '2',
      '--interval-seconds', '0',
      '--expected-chain-id', String(chainId),
      '--expected-genesis-hash', genesisHash,
      '--proof-out', proofOut,
    ]);

    assert.strictEqual(res.status, 0, res.stderr || res.stdout);
    assert.match(res.stdout, new RegExp(`PASS RPC chainId: ${chainId}`));
    assert.match(res.stdout, new RegExp(`PASS RPC genesis block hash: ${genesisHash}`));
    assert.match(res.stdout, /PASS fresh transaction receipt:/);
    assert.match(res.stdout, /PASS wrote acceptance proof:/);
    assert.deepStrictEqual(methods, [
      'eth_chainId',
      'eth_getBlockByNumber',
      'eth_blockNumber',
      'eth_accounts',
      'eth_sendTransaction',
      'eth_getTransactionReceipt',
    ]);

    const proof = JSON.parse(fs.readFileSync(proofOut, 'utf8'));
    assert.strictEqual(proof.status, 'pass');
    assert.strictEqual(proof.mode, 'launch');
    assert.strictEqual(proof.chainId, chainId);
    assert.strictEqual(proof.rpcGenesisHash, genesisHash);
    assert.strictEqual(proof.headBlock, 0);
    assert.strictEqual(proof.freshTransaction.txHash, txHash);
    assert.strictEqual(proof.freshTransaction.receipt.status, '0x1');
  } finally {
    await new Promise(resolve => server.close(resolve));
  }
});

test('freshTx requires an included successful fresh transaction receipt', async () => {
  const { freshTx } = require('./persistent-testnet-acceptance.js');
  const calls = [];
  const rpc = async (_url, method) => {
    calls.push(method);
    if (method === 'eth_accounts') return ['0x0000000000000000000000000000000000000001'];
    if (method === 'eth_sendTransaction') return `0x${'33'.repeat(32)}`;
    if (method === 'eth_getTransactionReceipt') return { blockNumber: '0x2', status: '0x0' };
    throw new Error(`unexpected method ${method}`);
  };

  await assert.rejects(
    () => freshTx('http://rpc.invalid', { timeoutSeconds: 1, intervalSeconds: 0, requireTx: true }, rpc),
    /fresh transaction failed: hash=.* status=0x0/,
  );
  assert.deepStrictEqual(calls, ['eth_accounts', 'eth_sendTransaction', 'eth_getTransactionReceipt']);
});
