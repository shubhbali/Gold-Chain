#!/usr/bin/env node
'use strict';

const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '..');
const failures = [];
const warnings = [];

function rel(p) { return path.relative(ROOT, p) || '.'; }
function fail(message) { failures.push(message); }
function warn(message) { warnings.push(message); }
function read(file) { return fs.readFileSync(path.join(ROOT, file), 'utf8'); }
function exists(file) { return fs.existsSync(path.join(ROOT, file)); }

function parseEnv(file) {
  const out = {};
  const text = read(file);
  for (const [idx, raw] of text.split(/\r?\n/).entries()) {
    const line = raw.trim();
    if (!line || line.startsWith('#')) continue;
    const m = line.match(/^([A-Za-z_][A-Za-z0-9_]*)=(.*)$/);
    if (!m) {
      fail(`${file}:${idx + 1} is not a KEY=value env line`);
      continue;
    }
    out[m[1]] = m[2].replace(/^['"]|['"]$/g, '');
  }
  return out;
}

function parseGoldSpec(file) {
  const spec = { chain: {}, validators: [] };
  let section = null;
  let currentValidator = null;
  for (const raw of read(file).split(/\r?\n/)) {
    const line = raw.replace(/#.*$/, '');
    if (!line.trim()) continue;
    if (/^[A-Za-z][\w-]*:\s*$/.test(line)) {
      section = line.trim().slice(0, -1);
      currentValidator = null;
      continue;
    }
    if (section === 'validators' && /^\s*-\s+/.test(line)) {
      currentValidator = {};
      spec.validators.push(currentValidator);
      const rest = line.replace(/^\s*-\s+/, '');
      if (rest.includes(':')) {
        const [k, ...parts] = rest.split(':');
        currentValidator[k.trim()] = parts.join(':').trim().replace(/^['"]|['"]$/g, '');
      }
      continue;
    }
    const m = line.match(/^\s*([A-Za-z0-9_-]+):\s*(.+)$/);
    if (!m) continue;
    const value = m[2].trim().replace(/^['"]|['"]$/g, '');
    if (section === 'chain') spec.chain[m[1]] = value;
    if (section === 'validators' && currentValidator) currentValidator[m[1]] = value;
  }
  return spec;
}

function parseJsonEnv(env, key, file) {
  if (!(key in env)) {
    fail(`${file} missing ${key}`);
    return null;
  }
  try {
    return JSON.parse(env[key]);
  } catch (err) {
    fail(`${file} ${key} is not valid JSON: ${err.message}`);
    return null;
  }
}

function checkChainSpecs() {
  for (const network of ['mainnet', 'testnet']) {
    const file = `chain/spec/gold-${network}.yaml`;
    const spec = parseGoldSpec(file);
    const count = spec.validators.length;
    if (count < 3) fail(`${file} requires at least 3 validators for ${network}; found ${count}`);
    const chainId = String(spec.chain.chainId || '');
    if (chainId === '56') fail(`${file} must not use BSC chainId 56`);
    if (network === 'mainnet' && chainId !== '7777777') fail(`${file} mainnet chainId must be 7777777; found ${chainId || '<missing>'}`);
    if (network === 'testnet' && chainId !== '7777778') fail(`${file} testnet chainId must be 7777778; found ${chainId || '<missing>'}`);
  }
}

function checkGeneratedGenesisNotMutatedByGate() {
  const gate = read('scripts/production-gate.sh');
  if (/build-genesis\.js --network (?:mainnet|testnet)(?![^\n]*--check)(?![^\n]*--out-dir)/.test(gate)) {
    fail('scripts/production-gate.sh invokes build-genesis without --check or --out-dir; gate validation must not mutate committed/generated genesis output');
  }
}

function checkScannerEnv(profile) {
  const envFile = `scan/goldscan/docker-compose/goldchain-${profile}.env`;
  if (!exists(envFile)) {
    fail(`${envFile} is missing`);
    return;
  }
  const env = parseEnv(envFile);

  const expectedChainIds = { mainnet: '7777777', testnet: '7777778', roughnet: null };
  if (expectedChainIds[profile] && env.GOLDCHAIN_CHAIN_ID !== expectedChainIds[profile]) {
    fail(`${envFile} GOLDCHAIN_CHAIN_ID must be ${expectedChainIds[profile]}; found ${env.GOLDCHAIN_CHAIN_ID || '<missing>'}`);
  }

  for (const key of Object.keys(env)) {
    if (key.startsWith('INDEXER_GOLDCHAIN_')) {
      fail(`${envFile} defines ${key}; profile env must use GOLDCHAIN_* inputs and docker-compose must map them to INDEXER_GOLDCHAIN_* runtime variables`);
    }
  }

  const routeMap = parseJsonEnv(env, 'GOLDCHAIN_ROUTE_ASSET_BY_ROOT_TOKEN_JSON', envFile);
  if (routeMap && Object.keys(routeMap).length === 0) {
    fail(`${envFile} GOLDCHAIN_ROUTE_ASSET_BY_ROOT_TOKEN_JSON must be non-empty and map root PAXG/XAUT token addresses to route assets`);
  }

  const bridgeTopics = parseJsonEnv(env, 'GOLDCHAIN_BRIDGE_TOPICS_JSON', envFile);
  if (bridgeTopics) {
    for (const required of ['root_lock', 'root_release', 'child_mint_or_credit', 'child_burn_or_debit']) {
      if (!Array.isArray(bridgeTopics[required]) || bridgeTopics[required].length === 0) {
        fail(`${envFile} GOLDCHAIN_BRIDGE_TOPICS_JSON missing non-empty ${required} topics`);
      }
    }
  }

  if (!['enabled', 'disabled'].includes(env.GOLDCHAIN_WEBSOCKET_STATUS)) {
    fail(`${envFile} must set GOLDCHAIN_WEBSOCKET_STATUS=enabled or disabled so unavailable WS is explicit, not implicit`);
  } else if (env.GOLDCHAIN_WEBSOCKET_STATUS === 'enabled' && !/^wss?:\/\//.test(env.GOLDCHAIN_RPC_WS_URL || '')) {
    fail(`${envFile} enables websocket but GOLDCHAIN_RPC_WS_URL is not ws:// or wss://`);
  } else if (env.GOLDCHAIN_WEBSOCKET_STATUS === 'disabled' && (env.GOLDCHAIN_RPC_WS_URL || '').trim()) {
    fail(`${envFile} disables websocket but still sets GOLDCHAIN_RPC_WS_URL`);
  }
}

function checkFrontendMainnetIsolation() {
  const file = 'scan/goldscan/docker-compose/goldchain-mainnet.frontend.env';
  const env = parseEnv(file);
  if (env.NEXT_PUBLIC_IS_TESTNET !== 'false') fail(`${file} must set NEXT_PUBLIC_IS_TESTNET=false`);
  const forbidden = /testnet|sepolia|roughnet|localhost|127\.0\.0\.1/i;
  for (const [key, value] of Object.entries(env)) {
    if (forbidden.test(value)) fail(`${file} ${key} contains testnet/local value ${value}`);
  }
  if (env.NEXT_PUBLIC_NETWORK_ID !== '7777777') fail(`${file} NEXT_PUBLIC_NETWORK_ID must match mainnet chainId 7777777; found ${env.NEXT_PUBLIC_NETWORK_ID || '<missing>'}`);

  const frontendSvc = 'scan/goldscan/docker-compose/services/frontend.yml';
  const text = read(frontendSvc);
  if (/goldchain-testnet\.frontend\.env/.test(text)) {
    fail(`${frontendSvc} hard-codes goldchain-testnet.frontend.env; mainnet frontend deployments must not load testnet env`);
  }
  if (/common-frontend\.env/.test(text)) {
    const common = parseEnv('scan/goldscan/docker-compose/envs/common-frontend.env');
    if (common.NEXT_PUBLIC_IS_TESTNET === 'true') {
      fail(`${frontendSvc} loads common-frontend.env, which defaults NEXT_PUBLIC_IS_TESTNET=true; mainnet must override or avoid this file`);
    }
  }
}

function checkComposeIndexerMapping() {
  const composeFile = 'scan/goldscan/docker-compose/goldchain-roughnet.yml';
  const text = read(composeFile);
  const mappings = [...text.matchAll(/\b(INDEXER_GOLDCHAIN_[A-Z0-9_]+):\s*\$\{(GOLDCHAIN_[A-Z0-9_]+)\}/g)];
  if (mappings.length === 0) {
    fail(`${composeFile} has no INDEXER_GOLDCHAIN_* <- GOLDCHAIN_* environment mappings`);
    return;
  }
  for (const profile of ['mainnet', 'testnet', 'roughnet']) {
    const envFile = `scan/goldscan/docker-compose/goldchain-${profile}.env`;
    if (!exists(envFile)) continue;
    const env = parseEnv(envFile);
    for (const [, indexerKey, goldKey] of mappings) {
      if (!(goldKey in env)) fail(`${envFile} missing ${goldKey} required for ${indexerKey} compose mapping`);
    }
  }
}

function checkLifecycleShape() {
  const file = 'scan/goldscan/apps/indexer/lib/indexer/transform/goldchain/lifecycle.ex';
  const text = read(file);
  const lines = text.split(/\r?\n/).length;
  const splitDir = path.join(ROOT, 'scan/goldscan/apps/indexer/lib/indexer/transform/goldchain/lifecycle');
  const refactored = fs.existsSync(splitDir) && fs.readdirSync(splitDir).some(name => name.endsWith('.ex'));
  if (lines > 800 && !refactored) {
    fail(`${file} is ${lines} lines and lifecycle/ split modules were not found; bridge lifecycle remains a monolith`);
  }
  if (/xfer-fallback-/.test(text)) {
    fail(`${file} contains xfer-fallback correlation; bridge transfers without protocol transfer IDs must not be correlated by participant/asset/amount heuristics`);
  }
  if (/Enum\.group_by\(& &1\.canonical_transfer_id\)/.test(text) && /canonical_transfer_id\([\s\S]*?is_nil\(transfer_id\)[\s\S]*?short_hash/.test(text)) {
    fail(`${file} groups by canonical_transfer_id derived from fallback hashes; unsafe cross-event correlation remains`);
  }
}

function main() {
  checkChainSpecs();
  checkGeneratedGenesisNotMutatedByGate();
  for (const profile of ['mainnet', 'testnet', 'roughnet']) checkScannerEnv(profile);
  checkFrontendMainnetIsolation();
  checkComposeIndexerMapping();
  checkLifecycleShape();

  for (const warning of warnings) console.error(`READINESS GATE WARN: ${warning}`);
  if (failures.length) {
    for (const message of failures) console.error(`READINESS GATE FAIL: ${message}`);
    process.exit(1);
  }
  console.log('READINESS GATE PASS');
}

main();
