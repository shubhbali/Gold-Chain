# GILT Tokenomics Specification

## Role

GILT is Gold Chain's native gas, staking, validator reward, governance, and protocol security token.

GILT is not GOLD. GILT is not bridge-backed gold. GOLD contracts and bridge contracts must never mint GILT.

## Canonical launch supply

- Native symbol: `GILT`
- Decimals: `18`
- Initial supply: `3,000,000,000 GILT`
- Initial supply wei: `3000000000000000000000000000`
- Initial supply source: genesis allocation only
- Inflation start: `block_1`
- Reward source: `GILT_INFLATION_AND_FEES`

Genesis allocations must sum exactly to the inflation base supply. For the current launch configs that means six allocations of `500,000,000 GILT` each:

- `0xD1445cB51A14E781EB8032539e2aF254a67f1f03`: `500000000000000000000000000` wei
- `0x9020565B91E731B63aC8c3297101A9Fe83806CEb`: `500000000000000000000000000` wei
- `0x9E0d48A0c7459e2D13A2c693fdCFFdaC1E25dDc5`: `500000000000000000000000000` wei
- `0x5122281d3A2AdD52e05B2813694D02f662a6bBD0`: `500000000000000000000000000` wei
- `0x218D9e56fde6665646C6e0fc0EbA7dC609016655`: `500000000000000000000000000` wei
- `0xE6f904b6f319A1824E5A167A9Be1592F87A5E6C8`: `500000000000000000000000000` wei

## Inflation schedule

Inflation is deterministic and recorded by StakeHub day index.

- Day index formula: `dayIndex = block.timestamp / BREATHE_BLOCK_INTERVAL`
- Launch `BREATHE_BLOCK_INTERVAL`: one day (`86400` seconds)
- Initial annual inflation rate: `1000` bps (`10.00%`)
- Maximum annual inflation rate: `1000` bps (`10.00%`)
- Minimum annual inflation rate: `150` bps (`1.50%`)
- Yearly decay: `1500` bps of the excess above the minimum rate
- First-year nominal mint cap: `300000000000000000000000000` wei (`300,000,000 GILT`)
- First-day expected mint at launch supply/rate: `821917808219178082191780` wei

The canonical rate function is implemented in `StakeHubMath.currentInflationBps(dayIndex, inflationStartDayIndex, inflationRateInitialBps, inflationRateMinBps, inflationDecayBpsPerYear, POWER_SCALE)`. The rate starts at `1000` bps and decays toward, but never below, `150` bps.

## Mint formula

For an unrecorded day:

```text
inflationBps = currentInflationBps(dayIndex)
effectiveSupply = inflationBaseSupply + inflationMintedAmount
expectedMintAmount = floor(floor(effectiveSupply * inflationBps / 10000) / 365)
```

If inflation is disabled, `inflationBaseSupply` is zero, the day has already been recorded, or the current rate is zero, then `expectedMintAmount = 0`.

The per-day hard cap is the same calculation:

```text
maxMintForDay = floor(floor(effectiveSupply * inflationBps / 10000) / 365)
inflationMintedByDay[dayIndex] + totalReward <= maxMintForDay
```

A day can be recorded once. Duplicate same-day inflation minting must fail or mint zero.

## Reward flow and split

The only permitted inflation mint flow is:

```text
Parlia reward logic -> GiltValidatorSet.depositInflation(validator) -> StakeHub.recordInflationMint(validator) -> validator/delegator accounting
```

- `gilt-chain/consensus/parlia` queries StakeHub for `expectedInflationMintAmount(dayIndex)` and never computes a private alternative amount.
- `GiltValidatorSet.depositInflation` is callable only by the block coinbase/system path, requires zero gas price, and rejects any amount that does not match StakeHub's expected amount.
- `StakeHub.recordInflationMint` records the day, enforces the cap, updates total inflation minted, and distributes to the validator's staking accounting.
- Active validator/delegator distribution uses StakeHub/StakeCredit staking share accounting. If the validator is jailed or has no credit contract, the amount is redirected or queued through the configured system reward path rather than minted again.
- GOLD staking rewards may receive a configured share of GILT/fee rewards, but GOLD itself is never inflated and GOLD contracts never mint GILT.

## Supply authority rules

Only the protocol/system reward path may create inflationary GILT.

Required invariants:

- No externally owned account may mint GILT.
- No GOLD contract may mint GILT.
- No bridge contract may mint GILT.
- No arbitrary governance action may mint outside the schedule.
- Inflation must be testable by day/epoch and must match StakeHub's expected amount exactly.
- The configured genesis allocation sum must equal the configured inflation base supply.
- The configured launch `initialRateBps` must not exceed `maxAnnualInflationBps`.

## Governance-adjustable parameters and limits

Governance may adjust only explicit economics parameters through the configured governance/timelock path. Governance must not bypass StakeHub accounting or grant a second mint authority.

Allowed bounded parameters:

- `inflationRateInitialBps`: `1..1000`; cannot exceed `maxAnnualInflationBps`.
- `inflationRateMinBps`: `1..inflationRateInitialBps`.
- `inflationDecayBpsPerYear`: non-negative; cannot increase the rate above the maximum cap.
- Validator/delegator commission and reward-accounting parameters exposed by StakeHub/StakeCredit, subject to their contract bounds.
- GOLD staking reward split: may route a bounded share of GILT/fee rewards; must not create GOLD inflation.

Non-governable without a new audited migration and launch spec:

- A second GILT mint authority.
- Bridge minting of GILT.
- GOLD contract minting of GILT.
- Increasing annual inflation above `1000` bps.
- Treating GOLD as inflationary validator rewards.

## Canonical validation

The production gate must validate:

- `gilt.inflation.enabled === true`
- `gilt.inflation.starts === "block_1"`
- `gilt.inflation.rewardSource === "GILT_INFLATION_AND_FEES"`
- `gilt.inflation.baseSupplyWei === sum(gilt.allocations[*].balanceWei)`
- `gilt.inflation.initialRateBps <= gilt.inflation.maxAnnualInflationBps <= 1000`
- StakeHub expected mint amount is the sole Parlia inflation amount
- Same-day duplicate inflation mints zero/fails
- Inflation cap cannot be exceeded
