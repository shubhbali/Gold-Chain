#!/usr/bin/env node
'use strict';

const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

const ROOT = path.resolve(__dirname, '../..');
const GENESIS_CONTRACT_ROOT = path.join(ROOT, 'gilt-genesis-contract');

function usage() {
  console.error('Usage: node chain/genesis/build-genesis.js --network <mainnet|testnet>');
  process.exit(2);
}

function parseArgs() {
  const idx = process.argv.indexOf('--network');
  if (idx === -1 || !process.argv[idx + 1]) usage();
  const network = process.argv[idx + 1];
  if (!['mainnet', 'testnet'].includes(network)) usage();
  return { network };
}

function stripQuotes(v) {
  return String(v).trim().replace(/^['"]|['"]$/g, '');
}

function parseScalar(v) {
  v = stripQuotes(v);
  if (v === 'true') return true;
  if (v === 'false') return false;
  if (/^[0-9]+$/.test(v)) {
    const n = Number(v);
    return Number.isSafeInteger(n) ? n : v;
  }
  return v;
}

function parseGoldSpec(text) {
  // Intentionally tiny parser for the committed chain/spec shape. This avoids adding
  // npm dependencies to consensus-critical genesis generation.
  const spec = { chain: {}, forks: { activateFromGenesis: {} }, consensus: {}, validators: [], systemContracts: {} };
  let section = null;
  let inActivate = false;
  let currentValidator = null;

  for (const raw of text.split(/\r?\n/)) {
    const line = raw.replace(/#.*$/, '');
    if (!line.trim()) continue;
    if (/^[a-zA-Z][\w-]*:\s*$/.test(line)) {
      section = line.trim().slice(0, -1);
      inActivate = false;
      currentValidator = null;
      continue;
    }
    if (section === 'forks' && line.trim() === 'activateFromGenesis:') {
      inActivate = true;
      continue;
    }
    if (section === 'validators' && /^\s*-\s+/.test(line)) {
      currentValidator = {};
      spec.validators.push(currentValidator);
      const rest = line.replace(/^\s*-\s+/, '');
      if (rest.includes(':')) {
        const [k, ...parts] = rest.split(':');
        currentValidator[k.trim()] = parseScalar(parts.join(':'));
      }
      continue;
    }
    const m = line.match(/^(\s*)([A-Za-z0-9_-]+):\s*(.+)$/);
    if (!m) throw new Error(`Cannot parse spec line: ${raw}`);
    const indent = m[1].length;
    const key = m[2];
    const val = parseScalar(m[3]);
    if (section === 'chain') spec.chain[key] = val;
    else if (section === 'forks' && inActivate && indent >= 4) spec.forks.activateFromGenesis[key] = val;
    else if (section === 'forks') {
      inActivate = false;
      spec.forks[key] = val;
    }
    else if (section === 'consensus') spec.consensus[key] = val;
    else if (section === 'validators' && currentValidator) currentValidator[key] = val;
    else if (section === 'systemContracts') spec.systemContracts[key] = val;
    else throw new Error(`Unexpected line in ${section}: ${raw}`);
  }
  return spec;
}

function mustAddress(name, value) {
  if (!/^0x[0-9a-fA-F]{40}$/.test(value || '')) throw new Error(`${name} must be 20-byte hex address, got ${value}`);
}

function mustHex(name, value) {
  if (!/^0x[0-9a-fA-F]*$/.test(value || '')) throw new Error(`${name} must be hex, got ${value}`);
}

function validateSpec(spec, network) {
  if (!spec.chain.chainId || !spec.chain.networkId) throw new Error('chain.chainId and chain.networkId are required');
  if (spec.chain.chainId === 56 || spec.chain.networkId === 56) throw new Error('Gold Chain must not use BSC chain ID/network ID 56');
  if (network !== 'devnet' && spec.forks.compressedTestSchedule !== false) throw new Error('persistent networks must not use compressedTestSchedule');
  if (spec.consensus.engine !== 'parlia') throw new Error('Gold Chain canonical consensus engine must be parlia');
  if (!Array.isArray(spec.validators) || spec.validators.length === 0) throw new Error('at least one validator is required');

  const seen = new Set();
  for (const [i, v] of spec.validators.entries()) {
    mustAddress(`validators[${i}].consensusAddress`, v.consensusAddress);
    mustAddress(`validators[${i}].feeAddress`, v.feeAddress);
    mustAddress(`validators[${i}].giltFeeAddress`, v.giltFeeAddress);
    mustHex(`validators[${i}].blsPublicKey`, v.blsPublicKey);
    const lower = v.consensusAddress.toLowerCase();
    if (seen.has(lower)) throw new Error(`duplicate validator consensusAddress ${v.consensusAddress}`);
    seen.add(lower);
  }
  for (const [k, v] of Object.entries(spec.systemContracts)) mustAddress(`systemContracts.${k}`, v);
}

function extraData(validators) {
  const vanity = '00'.repeat(32);
  const vals = validators.map(v => v.consensusAddress.toLowerCase().replace(/^0x/, '')).join('');
  const seal = '00'.repeat(65);
  return `0x${vanity}${vals}${seal}`;
}

function encodeValidatorStorage(validators) {
  const storage = {
    // Fallback manifest slots used only if the canonical GiltValidatorSet launch
    // storage builder is unavailable. Production genesis should use the canonical
    // contract storage below so Parlia epoch transitions can call the predeploy.
    '0x0000000000000000000000000000000000000000000000000000000000000001': `0x${validators.length.toString(16).padStart(64, '0')}`,
  };
  validators.forEach((v, i) => {
    const key = crypto.createHash('sha256').update(`gold.validator.${i}.consensus`).digest('hex');
    storage[`0x${key}`] = `0x${v.consensusAddress.toLowerCase().replace(/^0x/, '').padStart(64, '0')}`;
  });
  return storage;
}

function votingPowerHex(value) {
  const n = typeof value === 'string' && value.startsWith('0x') ? BigInt(value) : BigInt(value);
  if (n <= 0n || n > ((1n << 64n) - 1n)) throw new Error(`validator votingPower must fit uint64: ${value}`);
  return `0x${n.toString(16).padStart(16, '0')}`;
}

function loadLaunchConfig(network, spec) {
  const configPath = path.join(GENESIS_CONTRACT_ROOT, 'launch-config', `${network}.json`);
  const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
  config.chainId = spec.chain.chainId;
  config.profile = network;
  config.validators = spec.validators.map(v => ({
    consensusAddress: v.consensusAddress,
    feeAddress: v.feeAddress,
    giltFeeAddress: v.giltFeeAddress,
    votingPower: votingPowerHex(v.votingPower),
    blsPublicKey: v.blsPublicKey,
  }));
  return config;
}

function loadCanonicalPredeploys(network, spec) {
  try {
    const { SYSTEM_PREDEPLOYS, readSystemArtifacts } = require(path.join(GENESIS_CONTRACT_ROOT, 'scripts/lib/launch-artifacts'));
    const { buildLaunchGenesisState } = require(path.join(GENESIS_CONTRACT_ROOT, 'scripts/lib/launch-storage'));
    const systemArtifacts = readSystemArtifacts();
    const launchConfig = loadLaunchConfig(network, spec);
    const launchState = buildLaunchGenesisState(launchConfig, systemArtifacts.rawArtifacts.physicalGold1155);
    const storageByKey = {
      validatorContract: launchState.validatorSetStorage,
      stakeHub: launchState.stakeHubStorage,
      physicalGold1155: launchState.physicalGoldStorage,
    };
    const codeByKey = { ...systemArtifacts.data, physicalGold1155: launchState.physicalGoldBytecode };
    const out = [];
    for (const predeploy of SYSTEM_PREDEPLOYS) {
      const address = predeploy.key === 'physicalGold1155' ? launchState.goldAddress : predeploy.address;
      if (!address) continue;
      out.push({
        key: predeploy.key,
        address,
        code: codeByKey[predeploy.key],
        storage: storageByKey[predeploy.key] || {},
      });
    }
    return out;
  } catch (err) {
    throw new Error(`canonical predeploy generation failed: ${err.message}`);
  }
}

function buildGenesis(spec, network) {
  const alloc = {};
  for (const predeploy of loadCanonicalPredeploys(network, spec)) {
    alloc[predeploy.address] = { balance: '0x0', code: predeploy.code, storage: predeploy.storage };
  }
  for (const [name, addr] of Object.entries(spec.systemContracts)) {
    if (!alloc[addr]) alloc[addr] = { balance: '0x0', code: '0x', storage: {} };
    if (name === 'validatorSet' && (!alloc[addr].storage || Object.keys(alloc[addr].storage).length === 0)) {
      alloc[addr].storage = encodeValidatorStorage(spec.validators);
    }
  }
  for (const v of spec.validators) {
    const balance = v.initialBalanceWei ? BigInt(v.initialBalanceWei).toString(16) : '0';
    const existing = alloc[v.consensusAddress] || alloc[v.consensusAddress.toLowerCase()] || { code: '0x', storage: {} };
    alloc[v.consensusAddress] = { ...existing, balance: `0x${balance}` };
  }
  return {
    config: {
      chainId: spec.chain.chainId,
      homesteadBlock: 0,
      eip150Block: 0,
      eip155Block: 0,
      eip158Block: 0,
      byzantiumBlock: 0,
      constantinopleBlock: 0,
      petersburgBlock: 0,
      istanbulBlock: 0,
      berlinBlock: 0,
      londonBlock: 0,
      shanghaiTime: 0,
      parlia: { period: spec.chain.blockTimeSeconds, epoch: spec.consensus.epochLength },
    },
    nonce: '0x0',
    timestamp: '0x0',
    extraData: extraData(spec.validators),
    gasLimit: '0x2625a00',
    difficulty: '0x1',
    mixHash: '0x0000000000000000000000000000000000000000000000000000000000000000',
    coinbase: '0x0000000000000000000000000000000000000000',
    alloc,
    number: '0x0',
    gasUsed: '0x0',
    parentHash: '0x0000000000000000000000000000000000000000000000000000000000000000',
    baseFeePerGas: '0x3b9aca00',
  };
}

function main() {
  const { network } = parseArgs();
  const specPath = path.join(ROOT, 'chain/spec', `gold-${network}.yaml`);
  const spec = parseGoldSpec(fs.readFileSync(specPath, 'utf8'));
  validateSpec(spec, network);
  const outDir = path.join(ROOT, 'chain/genesis/out', network);
  fs.mkdirSync(outDir, { recursive: true });

  const genesis = buildGenesis(spec, network);
  const validatorsConf = spec.validators.map(v => [v.consensusAddress, v.feeAddress, v.giltFeeAddress, `0x${Number(v.votingPower).toString(16).padStart(16, '0')}`, v.blsPublicKey].join(',')).join('\n') + '\n';
  const addressBook = {
    chain: spec.chain,
    consensus: spec.consensus,
    validators: spec.validators,
    systemContracts: spec.systemContracts,
    generatedAt: new Date().toISOString(),
  };

  fs.writeFileSync(path.join(outDir, 'genesis.json'), JSON.stringify(genesis, null, 2) + '\n');
  fs.writeFileSync(path.join(outDir, 'validators.conf'), validatorsConf);
  fs.writeFileSync(path.join(outDir, 'address-book.json'), JSON.stringify(addressBook, null, 2) + '\n');
  console.log(`generated ${network} genesis in ${path.relative(ROOT, outDir)}`);
}

main();
