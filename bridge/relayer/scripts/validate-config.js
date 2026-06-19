#!/usr/bin/env node
import fs from 'node:fs';
import { assertBridgeContractsHaveCode, validateRelayerConfig } from '../src/config.js';

const args = process.argv.slice(2);
const checkCode = args.includes('--check-code');
const configPath = args.find((arg) => arg !== '--check-code');
if (!configPath) {
  console.error('usage: validate-config.js [--check-code] <config.json>');
  process.exit(2);
}

const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
validateRelayerConfig(config);
if (checkCode) await assertBridgeContractsHaveCode(config);
console.log(`relayer config OK: ${configPath}${checkCode ? ' (bridge code checked)' : ''}`);
