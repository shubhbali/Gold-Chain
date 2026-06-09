# ADR-0001: Canonical Gold Chain Architecture

## Status

Accepted for overhaul branch `overhaul/production-gold-chain`.

## Decision

Gold Chain production architecture is:

1. `gilt-chain/` is the only canonical execution/consensus client.
2. Gold Chain uses a BSC/Parlia-style validator system.
3. `gilt-genesis-contract/` remains the legacy source for existing system-contract work while the canonical generated genesis path is built under `chain/genesis/` and `chain/spec/`.
4. The production bridge is a custom Ethereum custody bridge plus Gold Chain child bridge.
5. Polygon/Bor/Heimdall/PoS bridge stacks are not part of production Gold Chain.
6. Duplicate execution clients are not fallback paths.

## Consequences

- `bridge/gilt-exec/` must be removed from production references.
- `bridge/gilt-consensus/`, `bridge/pos-contracts/`, and `bridge/pos-portal/` must be removed from production references.
- Bridge code may depend on Gold Chain RPC/contracts, but must not include another chain implementation.
- All genesis, validators, chain IDs, fork schedule, and system-contract addresses must come from `chain/spec/*.yaml` and generated outputs.

## Non-negotiables

- No Gold Chain config may use BSC chain ID `56`.
- Persistent testnet/mainnet may not use compressed fork-test schedules.
- Validator signer keys must match genesis validators before launch.
- GOLD route accounting must preserve backing route: PAXG-backed claims redeem PAXG, XAUT-backed claims redeem XAUT.
- GILT remains native gas/staking/reward token; GOLD remains separate backed asset.
