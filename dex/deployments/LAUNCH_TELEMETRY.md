# Gold Chain DEX Launch Telemetry

## Core KPIs
- Swap success rate (`target >= 99.9%`, excluding user slippage reverts).
- Revert reason distribution by router/function signature.
- LP TVL by pair (`DEX/GILT`, `GOLD-PAXG/GILT`, `GOLD-XAUT/GILT`, stableswap pools).
- Subgraph lag p95 (`target <= 2 blocks`).
- Finality lag from chain head for indexer/event consumers.

## Module Health Signals
- Farms:
  - emission rate and pending reward consistency
  - pool allocation sum integrity
- ve/voter:
  - vote checkpoint lag
  - emission distribution completeness
- Lottery:
  - round state progression
  - randomness fulfillment latency

## Alert Thresholds
- Sev-1 alerts:
  - swap success rate < 99.0% for 5m
  - unexpected contract ownership change
  - indexer finality lag > 20 blocks
- Sev-2 alerts:
  - subgraph p95 lag > 5 blocks for 10m
  - module-specific error spikes > 3x baseline

## Dashboards
- `dex-launch-overview`
- `dex-routing-errors`
- `dex-liquidity-and-volume`
- `dex-indexer-health`
- `dex-governance-and-roles`
