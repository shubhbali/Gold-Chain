#!/usr/bin/env node
'use strict';

const fs = require('fs');
const path = require('path');

function usage() {
  console.error('Usage: node chain/scripts/preflight-validators.js --genesis <genesis.json> --validators <validators.conf> [--datadir <dir>]');
  process.exit(2);
}

function arg(name) {
  const i = process.argv.indexOf(name);
  return i === -1 ? null : process.argv[i + 1];
}

function readValidatorsConf(file) {
  return fs.readFileSync(file, 'utf8')
    .split(/\r?\n/)
    .map(l => l.trim())
    .filter(Boolean)
    .map(l => l.split(',')[0].toLowerCase());
}

function validatorsFromExtraData(extraData) {
  if (!/^0x[0-9a-fA-F]+$/.test(extraData || '')) throw new Error('genesis.extraData missing or invalid');
  const hex = extraData.slice(2);
  if (hex.length < 64 + 130) throw new Error('extraData too short for Parlia validator list');
  const validatorHex = hex.slice(64, -130);
  if (validatorHex.length % 40 !== 0) throw new Error('extraData validator bytes are not address-aligned');
  const validators = [];
  for (let i = 0; i < validatorHex.length; i += 40) validators.push(`0x${validatorHex.slice(i, i + 40)}`.toLowerCase());
  return validators;
}

function findKeystoreAddresses(datadir) {
  const out = [];
  if (!datadir || !fs.existsSync(datadir)) return out;
  const walk = d => {
    for (const ent of fs.readdirSync(d, { withFileTypes: true })) {
      const p = path.join(d, ent.name);
      if (ent.isDirectory()) walk(p);
      else if (p.includes(`${path.sep}keystore${path.sep}`)) {
        try {
          const j = JSON.parse(fs.readFileSync(p, 'utf8'));
          if (j.address) out.push({ file: p, address: `0x${String(j.address).toLowerCase().replace(/^0x/, '')}` });
        } catch (_) {}
      }
    }
  };
  walk(datadir);
  return out;
}

function setEq(a, b) {
  return a.size === b.size && [...a].every(x => b.has(x));
}

function main() {
  const genesisPath = arg('--genesis');
  const validatorsPath = arg('--validators');
  const datadir = arg('--datadir');
  if (!genesisPath || !validatorsPath) usage();

  const genesis = JSON.parse(fs.readFileSync(genesisPath, 'utf8'));
  const extraVals = new Set(validatorsFromExtraData(genesis.extraData));
  const confVals = new Set(readValidatorsConf(validatorsPath));
  if (!setEq(extraVals, confVals)) {
    console.error('FAIL validator mismatch: genesis extraData != validators.conf');
    console.error('extraData:', [...extraVals].join(', '));
    console.error('validators.conf:', [...confVals].join(', '));
    process.exit(1);
  }

  const keys = findKeystoreAddresses(datadir);
  if (datadir && keys.length === 0) {
    console.error(`FAIL no keystore accounts found under ${datadir}`);
    process.exit(1);
  }
  const bad = keys.filter(k => !extraVals.has(k.address));
  if (bad.length) {
    console.error('FAIL keystore signer(s) not authorized by genesis validators:');
    for (const k of bad) console.error(`  ${k.address} ${k.file}`);
    console.error('authorized:', [...extraVals].join(', '));
    process.exit(1);
  }

  console.log(`PASS validator preflight: ${extraVals.size} genesis validators, ${keys.length} keystore signer(s) checked`);
}

main();
