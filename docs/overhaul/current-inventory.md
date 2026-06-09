# Current Gold Chain Inventory Before Overhaul

This inventory records the pre-overhaul repo shape so destructive cleanup is explicit.

## Canonical production candidates

- `gilt-chain/` — canonical BSC/Geth/Parlia-style execution/consensus client candidate.
- `gilt-genesis-contract/` — current genesis, validator, system-contract, and GOLD/GILT contract workspace. This remains the source to mine/rewrite into the canonical genesis/system-contract path.

## Duplicate / non-canonical paths to remove from production

- `bridge/gilt-exec/` — duplicate Geth/execution-client tree. Not a production fallback.
- `bridge/gilt-consensus/` — Polygon/Heimdall-style consensus/checkpoint stack. Not part of the chosen Gold Chain architecture.
- `bridge/pos-contracts/` — Polygon PoS bridge contracts. Not part of the chosen Gold Chain architecture.
- `bridge/pos-portal/` — Polygon PoS portal contracts. Not part of the chosen Gold Chain architecture.

## Runtime/generated directories observed

- `.gold-testnet/`
- `.gold-testnet-v2/`
- `.sim-giltconsensus/`
- `.sim-live/`
- `.simulation-root/`
- `dex/pancake-frontend/apps/web/.next/`

These are generated runtime/build artifacts and must not be committed.

## Known launch/config problems found before overhaul

- Genesis/testnet validator `0x225D6AF01985dd4f627abbe1ee0062Fce8C3f5D0` did not match local `.gold-testnet-v2` keystores.
- Persistent testnet config used compressed fork-test scheduling around blocks `1..8`.
- `GILTChainConfig` inherited BSC chain ID `56`.
- Multiple inherited bridge/client trees made the canonical execution path ambiguous.

## Overhaul stance

The production path keeps one canonical chain and one canonical bridge architecture. Removed code is not a fallback unless a future ADR explicitly reintroduces it.
