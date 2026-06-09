#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

run() {
  echo "+ $*" >&2
  "$@"
}

run_in() {
  local dir="$1"
  shift
  echo "+ (cd $dir && $*)" >&2
  (cd "$dir" && "$@")
}

have() { command -v "$1" >/dev/null 2>&1; }

# Canonical genesis and validator preflight must run before any client/contract tests.
run node chain/genesis/build-genesis.js --network testnet
run node chain/genesis/build-genesis.js --network mainnet
run node chain/scripts/preflight-validators.js \
  --genesis chain/genesis/out/testnet/genesis.json \
  --validators chain/genesis/out/testnet/validators.conf
run node chain/scripts/check-chain-invariants.js --network testnet --datadir "${GOLD_TESTNET_DATADIR:-.gold-testnet-mainnet-grade}"
run node chain/scripts/check-chain-invariants.js --network mainnet
run node chain/scripts/persistent-testnet-acceptance.js --network testnet --offline --target-block 0

if have go; then
  # Run the Gold Chain client packages that are part of the canonical production path.
  # Avoid upstream geth fixture suites that depend on legacy Ethereum testdata/services.
  run_in gilt-chain go test ./params ./consensus/parlia ./cmd/faucet
else
  echo "WARN: go not found; skipping gilt-chain Go tests" >&2
fi

if have forge; then
  run_in gilt-genesis-contract forge build
  run_in gilt-genesis-contract forge test -vvv --match-contract "GoldLaunchAcceptance|GoldProductionRoutes|GoldMigration|ValidatorSetBootstrap|PhysicalGold1155Bridge"

  # Bridge contracts currently live under top-level bridge/* while the Foundry project
  # remains gilt-genesis-contract. Compile them explicitly until a dedicated Foundry
  # workspace is added under each bridge component.
  run_in gilt-genesis-contract forge build --contracts ../bridge/ethereum/contracts
  run_in gilt-genesis-contract forge build --contracts ../bridge/gold-chain/contracts
elif have npx; then
  rm -rf /tmp/gold-solc-out /tmp/gold-bridge-solc-out
  mkdir -p /tmp/gold-solc-out /tmp/gold-bridge-solc-out
  (
    cd gilt-genesis-contract
    run npx --no-install solc --base-path . --include-path node_modules --abi --bin \
      contracts/gold/GoldRouteToken.sol \
      contracts/gold/GoldPhaseRegistry.sol \
      contracts/gold/GoldBridgeMinter.sol \
      contracts/gold/ReserveGoldController.sol \
      contracts/gold/GoldMigrationController.sol \
      -o /tmp/gold-solc-out
    run npx --no-install solc --base-path .. --include-path node_modules --abi --bin \
      ../bridge/ethereum/contracts/GoldRootCustody.sol \
      ../bridge/gold-chain/contracts/GoldChildBridge.sol \
      -o /tmp/gold-bridge-solc-out
  )
else
  echo "WARN: neither forge nor npx found; skipping Solidity compile/tests" >&2
fi

if [[ -d bridge/relayer ]]; then
  if have npm; then
    run_in bridge/relayer npm run check
    run_in bridge/relayer npm test
  else
    echo "WARN: npm not found; skipping bridge/relayer tests" >&2
  fi
fi

run bash scripts/production-gate.sh
