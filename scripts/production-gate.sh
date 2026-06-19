#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# Foundry installs here by default; production gate must not silently skip Forge tests
# in non-interactive shells.
export PATH="$HOME/.foundry/bin:$PATH"

fail() { echo "PRODUCTION GATE FAIL: $*" >&2; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }
run() { echo "+ $*" >&2; "$@"; }

# Canonical chain IDs: no BSC 56 in Gold Chain specs or generated genesis.
if grep -RInE 'chainId:[[:space:]]*56|"chainId"[[:space:]]*:[[:space:]]*56|ChainID:[[:space:]]*big.NewInt\(56\)' \
  chain/spec chain/genesis gilt-chain/params/config.go gilt-genesis-contract/launch-config 2>/dev/null; then
  fail "Gold Chain production path still references chain ID 56"
fi

# Persistent specs cannot use compressed test fork schedules.
if grep -RInE 'compressedTestSchedule:[[:space:]]*true|MirrorSyncBlock:[[:space:]]*big.NewInt\(1\)|BerlinBlock:[[:space:]]*big.NewInt\(8\)' \
  chain/spec gilt-chain/params/config.go 2>/dev/null; then
  fail "compressed fork-test schedule found in production path"
fi

# Duplicate execution and removed bridge paths must not remain in production references.
# Keep this explicit; broad words like bor/polygon appear in vendored scanner code and normal text.
if git grep -nE 'bridge/gilt-exec|gilt-exec|bridge/gilt-consensus|bridge/pos-contracts|bridge/pos-portal|pos-portal|pos-contracts' -- \
  ':!attic/**' ':!docs/overhaul/current-inventory.md' ':!docs/architecture/ADR-0001-canonical-chain.md' ':!.hermes/**' ':!scripts/production-gate.sh' >/tmp/gold-prod-gate.refs 2>/dev/null; then
  cat /tmp/gold-prod-gate.refs >&2
  fail "non-canonical duplicate/removed bridge references remain in production path"
fi

run node scripts/readiness-gate.js
run node chain/genesis/build-genesis.js --network testnet --check >/tmp/gold-gen-testnet-check.log
run node chain/genesis/build-genesis.js --network mainnet --check >/tmp/gold-gen-mainnet-check.log
GENESIS_TMP="$(mktemp -d /tmp/gold-genesis.XXXXXX)"
trap 'rm -rf "$GENESIS_TMP"' EXIT
run node chain/genesis/build-genesis.js --network testnet --out-dir "$GENESIS_TMP/testnet" >/tmp/gold-gen-testnet.log
run node chain/scripts/preflight-validators.js \
  --genesis "$GENESIS_TMP/testnet/genesis.json" \
  --validators "$GENESIS_TMP/testnet/validators.conf" >/tmp/gold-validator-preflight.log
run node chain/scripts/persistent-testnet-acceptance.js --network testnet --offline --target-block 0 >/tmp/gold-persistent-acceptance-offline.log

validator_count="$(GENESIS_TMP="$GENESIS_TMP" node - <<'NODE'
const fs = require('fs');
const g = JSON.parse(fs.readFileSync(`${process.env.GENESIS_TMP}/testnet/genesis.json`, 'utf8'));
const hex = g.extraData.slice(2);
process.stdout.write(String(hex.slice(64, -130).length / 40));
NODE
)"
if (( validator_count < 3 )); then
  fail "persistent testnet requires 3+ validators; generated testnet has ${validator_count}"
fi

chain_id="$(GENESIS_TMP="$GENESIS_TMP" node -e "const fs=require('fs'); const g=JSON.parse(fs.readFileSync(process.env.GENESIS_TMP + '/testnet/genesis.json','utf8')); process.stdout.write(String(g.config.chainId))")"
[[ "$chain_id" != "56" ]] || fail "generated testnet genesis has forbidden chain ID 56"

# Acceptance tooling must include a real fresh transaction/receipt path, even when no live RPC is supplied to CI.
if ! grep -q 'eth_sendTransaction' chain/scripts/persistent-testnet-acceptance.js || \
   ! grep -q 'eth_getTransactionReceipt' chain/scripts/persistent-testnet-acceptance.js; then
  fail "persistent-testnet acceptance tooling lacks fresh transaction receipt check"
fi

if [[ -n "${GOLD_ACCEPTANCE_RPC:-}" ]]; then
  [[ -n "${GOLD_ACCEPTANCE_EXPECTED_CHAIN_ID:-}" ]] || fail "GOLD_ACCEPTANCE_EXPECTED_CHAIN_ID is required when GOLD_ACCEPTANCE_RPC is set"
  [[ -n "${GOLD_ACCEPTANCE_EXPECTED_GENESIS_HASH:-}" ]] || fail "GOLD_ACCEPTANCE_EXPECTED_GENESIS_HASH is required when GOLD_ACCEPTANCE_RPC is set"
  [[ -n "${GOLD_ACCEPTANCE_PROOF_OUT:-}" ]] || fail "GOLD_ACCEPTANCE_PROOF_OUT is required when GOLD_ACCEPTANCE_RPC is set"
  [[ -n "${GOLD_ACCEPTANCE_DATADIR:-}" ]] || fail "GOLD_ACCEPTANCE_DATADIR is required when GOLD_ACCEPTANCE_RPC is set"
  run node chain/scripts/persistent-testnet-acceptance.js \
    --network testnet \
    --launch-mode \
    --rpc "$GOLD_ACCEPTANCE_RPC" \
    --datadir "$GOLD_ACCEPTANCE_DATADIR" \
    --target-block "${GOLD_ACCEPTANCE_TARGET_BLOCK:-10000}" \
    --expected-chain-id "$GOLD_ACCEPTANCE_EXPECTED_CHAIN_ID" \
    --expected-genesis-hash "$GOLD_ACCEPTANCE_EXPECTED_GENESIS_HASH" \
    --proof-out "$GOLD_ACCEPTANCE_PROOF_OUT"
else
  echo "WARN: GOLD_ACCEPTANCE_RPC not set; live chainId/genesis/block/tx acceptance check not run" >&2
fi

# GOLD route/migration contracts must exist in canonical workspace.
for f in \
  gilt-genesis-contract/contracts/gold/GoldRouteToken.sol \
  gilt-genesis-contract/contracts/gold/GoldPhaseRegistry.sol \
  gilt-genesis-contract/contracts/gold/GoldBridgeMinter.sol \
  gilt-genesis-contract/contracts/gold/ReserveGoldController.sol \
  gilt-genesis-contract/contracts/gold/GoldMigrationController.sol \
  bridge/ethereum/contracts/GoldRootCustody.sol \
  bridge/gold-chain/contracts/GoldChildBridge.sol \
  bridge/shared/contracts/BridgeMessageLib.sol \
  bridge/shared/contracts/BridgeThresholdVerifier.sol; do
  [[ -f "$f" ]] || fail "missing canonical contract $f"
done

# Production bridge configuration must only name real PAXG/XAUT route IDs, not mock-only routes.
# Do not flag source code that rejects mock routes; only committed config/examples are production inputs.
if git grep -nEi 'mock.*route|route.*mock|dummy.*route|test.*route' -- \
  'bridge/relayer/**/*.json' 'bridge/relayer/**/*.yaml' 'bridge/relayer/**/*.yml' \
  ':!**/test/**' ':!**/README.md' >/tmp/gold-prod-gate.mock-routes 2>/dev/null; then
  cat /tmp/gold-prod-gate.mock-routes >&2
  fail "mock-only bridge route appears in production bridge config"
fi
if ! grep -q 'PAXG' bridge/relayer/src/constants.js || ! grep -q 'XAUT' bridge/relayer/src/constants.js; then
  fail "bridge relayer route constants must include PAXG and XAUT"
fi

if ! grep -q 'verifier.verify' bridge/ethereum/contracts/GoldRootCustody.sol || \
   ! grep -q 'verifier.verify' bridge/gold-chain/contracts/GoldChildBridge.sol; then
  fail "root and child bridge finalization must be threshold/proof-gated"
fi

if grep -n 'function finalizeWithdrawal' -A8 bridge/ethereum/contracts/GoldRootCustody.sol | grep -q 'onlyFinalizer'; then
  fail "ETH withdrawal release must be permissionless once threshold proof is valid"
fi

# GOLD authority split must be represented by separate bridge, reserve, migration, and phase contracts.
if ! grep -q 'contract GoldBridgeMinter' gilt-genesis-contract/contracts/gold/GoldBridgeMinter.sol || \
   ! grep -q 'contract ReserveGoldController' gilt-genesis-contract/contracts/gold/ReserveGoldController.sol || \
   ! grep -q 'contract GoldMigrationController' gilt-genesis-contract/contracts/gold/GoldMigrationController.sol || \
   ! grep -q 'contract GoldPhaseRegistry' gilt-genesis-contract/contracts/gold/GoldPhaseRegistry.sol; then
  fail "GOLD mint/migration authority is not split across the expected canonical contracts"
fi

if have forge; then
  run bash -c 'cd gilt-genesis-contract && forge test -vvv --match-contract "GoldProductionRoutes|GoldMigration|BridgeCustodyHardening|BridgeThresholdVerifier"'
else
  echo "WARN: forge not found; old bridged redemption/migration tests were not executed" >&2
fi

if have npm && [[ -d bridge/relayer ]]; then
  run bash -c 'cd bridge/relayer && npm run check && npm test'
  run node --input-type=module -e "import { validateRelayerConfig } from './bridge/relayer/src/config.js'; import fs from 'node:fs'; validateRelayerConfig(JSON.parse(fs.readFileSync('bridge/relayer/config.local.example.json','utf8')));"
else
  echo "WARN: npm or bridge/relayer missing; relayer tests were not executed" >&2
fi

echo "PRODUCTION GATE PASS"
