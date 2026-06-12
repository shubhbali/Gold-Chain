#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

export PATH="$HOME/.foundry/bin:$PATH"

if ! command -v forge >/dev/null 2>&1; then
  echo "bridge-local-e2e: forge is required" >&2
  exit 1
fi
if ! command -v npm >/dev/null 2>&1; then
  echo "bridge-local-e2e: npm is required" >&2
  exit 1
fi

echo "+ forge bridge custody/threshold E2E and negative cases"
(
  cd gilt-genesis-contract
  forge test -vvv --match-contract 'BridgeCustodyHardening|BridgeThresholdVerifier|GoldProductionRoutes'
)

echo "+ relayer local finalized-event E2E and negative cases"
(
  cd bridge/relayer
  npm run check
  npm test
)

if [[ -n "${ROOT_RPC:-}" || -n "${GOLD_RPC:-}" ]]; then
  : "${ROOT_RPC:?ROOT_RPC must be set with GOLD_RPC for live local bridge smoke}"
  : "${GOLD_RPC:?GOLD_RPC must be set with ROOT_RPC for live local bridge smoke}"
  node chain/scripts/persistent-testnet-acceptance.js --network testnet --rpc "$GOLD_RPC" --target-block "${GOLD_TARGET_BLOCK:-1}"
  echo "WARN: live root-chain deployment is intentionally not mocked here; deploy contracts with production signer set and rerun relayer against the emitted addresses" >&2
fi

echo "BRIDGE LOCAL E2E PASS"
