#!/usr/bin/env node
'use strict';

const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const { spawnSync } = require('child_process');

const ROOT = path.resolve(__dirname, '../..');

function usage() {
  console.error(`Usage: node chain/scripts/check-chain-invariants.js --network <testnet|mainnet> [--datadir <dir>]

Checks production-chain invariants for the canonical Gold Chain genesis/config.
This is chain-only: consensus identity, fork schedule, validator/system-contract
bootstrap, GILT native identity, and validator signer alignment when datadir is supplied.
`);
  process.exit(2);
}

function arg(name) {
  const i = process.argv.indexOf(name);
  return i === -1 ? null : process.argv[i + 1];
}
function has(name) { return process.argv.includes(name); }
function readJson(p) { return JSON.parse(fs.readFileSync(p, 'utf8')); }
function sha(p) { return crypto.createHash('sha256').update(fs.readFileSync(p)).digest('hex'); }
function must(cond, msg) { if (!cond) throw new Error(msg); }
function validatorsFromExtraData(extraData) {
  must(/^0x[0-9a-fA-F]+$/.test(extraData || ''), 'genesis.extraData invalid');
  const hex = extraData.slice(2);
  const body = hex.slice(64, -130);
  must(body.length > 0 && body.length % 40 === 0, 'extraData validator list invalid');
  const out = [];
  for (let i = 0; i < body.length; i += 40) out.push(`0x${body.slice(i, i + 40)}`.toLowerCase());
  return out;
}
function run(cmd, args) {
  const res = spawnSync(cmd, args, { cwd: ROOT, encoding: 'utf8' });
  if (res.status !== 0) throw new Error(`command failed: ${cmd} ${args.join(' ')}\n${res.stderr}${res.stdout}`.trim());
  return res.stdout;
}

function main() {
  const network = arg('--network') || usage();
  must(['testnet', 'mainnet'].includes(network), 'network must be testnet or mainnet');
  const datadir = arg('--datadir');

  run('node', ['chain/genesis/build-genesis.js', '--network', network]);
  const out = path.join(ROOT, 'chain/genesis/out', network);
  const genesis = readJson(path.join(out, 'genesis.json'));
  const addressBook = readJson(path.join(out, 'address-book.json'));
  const validators = validatorsFromExtraData(genesis.extraData);
  const chainId = genesis.config.chainId;

  must(chainId === addressBook.chain.chainId, 'genesis/address-book chainId mismatch');
  must(chainId !== 56 && chainId !== 97, 'Gold Chain must not use BSC mainnet/testnet chain IDs');
  must(addressBook.chain.nativeSymbol === 'GILT', `native symbol must be GILT, got ${addressBook.chain.nativeSymbol}`);
  must(genesis.config.parlia && Number(genesis.config.parlia.period) === Number(addressBook.chain.blockTimeSeconds), 'parlia period mismatch');
  must(Number(genesis.config.parlia.epoch) === Number(addressBook.consensus.epochLength), 'parlia epoch mismatch');
  must(!('cancunTime' in genesis.config), 'cancun must not be accidentally enabled in current persistent profile');
  must(genesis.config.londonBlock === 0 && genesis.config.shanghaiTime === 0, 'expected stable post-london/shanghai genesis schedule');
  must(validators.length === addressBook.validators.length, 'validator count mismatch');

  const seen = new Set();
  for (const [i, v] of addressBook.validators.entries()) {
    const addr = v.consensusAddress.toLowerCase();
    must(validators.includes(addr), `validator ${addr} missing from extraData`);
    must(!seen.has(addr), `duplicate validator ${addr}`);
    seen.add(addr);
    must(genesis.alloc[v.consensusAddress] || genesis.alloc[addr], `validator ${addr} missing from genesis alloc`);
    const alloc = genesis.alloc[v.consensusAddress] || genesis.alloc[addr];
    if (network === 'testnet') must(BigInt(alloc.balance) > 0n, `testnet validator ${addr} not funded for live tx/ops`);
    must(Number(v.votingPower) > 0, `validator ${addr} votingPower must be positive`);
    must(/^0x[0-9a-fA-F]{96}$/.test(v.blsPublicKey), `validator ${addr} BLS key malformed`);
  }

  for (const name of ['validatorSet', 'slash', 'systemReward', 'stakeHub', 'govHub', 'governor', 'timelock', 'goldBridge', 'goldAsset']) {
    const addr = addressBook.systemContracts[name];
    must(/^0x[0-9a-fA-F]{40}$/.test(addr || ''), `system contract ${name} missing/malformed`);
    must(genesis.alloc[addr], `system contract ${name} missing from genesis alloc`);
  }
  must(Object.keys(genesis.alloc[addressBook.systemContracts.validatorSet].storage || {}).length >= validators.length + 1, 'validatorSet bootstrap storage incomplete');

  if (datadir) {
    run('node', ['chain/scripts/preflight-validators.js', '--genesis', path.join(out, 'genesis.json'), '--validators', path.join(out, 'validators.conf'), '--datadir', datadir]);
  }

  console.log(`PASS chain invariants: network=${network} chainId=${chainId} native=GILT consensus=parlia validators=${validators.length} genesisSha256=${sha(path.join(out, 'genesis.json'))}`);
  console.log('PASS bootstrap invariants: validatorSet/slash/stake/reward/governance/gold system contracts allocated');
  console.log('PASS upgrade/economics gate: canonical IDs, non-compressed fork schedule, positive validator voting power, funded testnet validators');
}

main();
