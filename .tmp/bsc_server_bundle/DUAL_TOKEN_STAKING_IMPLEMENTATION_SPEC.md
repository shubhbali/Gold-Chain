# Dual-Token Staking and Security Implementation Spec

Status: Proposed  
Scope: Full product (not MVP)  
Target repo: `C:\gold\goquarkchain`

## 1) Product goals

- Allow validators/users to stake either native token independently.
- Keep staking open from day one for both tokens.
- Delay ratio enforcement to a later activation point.
- Keep cross-shard UX seamless for users.
- Increase security guarantees beyond current PoSW-only behavior.

## 2) Current code reality (baseline)

- Minor-chain PoSW stake source is default/native token balance:
  - `goquarkchain/core/minorblockchain.go:503`
- Optional GOLD:GILT ratio check exists and is activation-gated:
  - `goquarkchain/core/minorblockchain.go:478`
  - `goquarkchain/core/minorblockchain.go:484`
  - `goquarkchain/core/minorblockchain.go:485`
- Root-chain PoSW stake comes from root PoSW contract lookup:
  - `goquarkchain/core/minorblockchain.go:1758`
  - `goquarkchain/core/minorblockchain.go:1774`
- Root difficulty path consumes one returned stake amount:
  - `goquarkchain/core/rootblockchain.go:1137`

Implication:

- Today, consensus-relevant stake path is effectively single-stake-value oriented.
- Dual-token transfer exists at tx layer, not as independent consensus stake weights.

## 3) Target model (what to build)

- Two independently lockable stake pools:
  - `TokenA` (default/native, GOLD)
  - `TokenB` (second native, GILT)
- Both can be staked independently from genesis.
- Consensus uses a deterministic weighted stake function:
  - `effectiveStake = wA * lockedA + wB * lockedB`
- Ratio enforcement starts later by governance/activation rule:
  - Before activation: ratio check disabled.
  - After activation: minimum ratio constraints enforced.

## 4) Security model

- Keep one strong security anchor:
  - `TokenA` remains mandatory minimum for validator eligibility.
- `TokenB` contributes to weight/rewards within bounded caps.
- Add slashable accountability:
  - Double-sign slash.
  - Invalid vote slash.
  - Liveness penalties/jail.
- Add epoch-based finality votes (checkpoint finalization).

Rationale:

- Dual-token economics without making security depend on a weak or manipulable side path.

## 5) On-chain contract spec changes

File area:

- `goquarkchain/core/vm/contracts.go`

Current root PoSW contract call in code assumes single stake return via:

- `getLockedStakes(address)` selector usage in:
  - `goquarkchain/core/minorblockchain.go:1758`

Required contract interface upgrades:

- `getLockedStakesV2(address validator) returns (uint256 lockedA, uint256 lockedB, address signer, uint8 status)`
- `lockA(uint256 amount)`
- `unlockA(uint256 amount)` with unbonding delay
- `lockB(uint256 amount)`
- `unlockB(uint256 amount)` with unbonding delay
- `setSigner(address signer)`
- `slash(address validator, uint256 amountA, uint256 amountB, uint8 reason)` restricted to consensus module/system authority

State:

- Store independent balances:
  - `lockedA[validator]`
  - `lockedB[validator]`
- Store signer:
  - `signer[validator]`
- Store unbonding queues:
  - `pendingUnlockA[]`
  - `pendingUnlockB[]`

## 6) Consensus logic changes

### 6.1 Minor chain PoSW weighting

File area:

- `goquarkchain/core/minorblockchain.go`

Current:

- Uses only default token balance at `:503`.

Change:

- Replace single-token balance input to PoSW with `effectiveStake` derived from both token balances and config weights.
- Add hard floor:
  - validator must have `lockedA >= MinStakeA`.
- Optional cap:
  - `effectiveStakeFromB <= MaxBContributionPercent * effectiveStake`.

### 6.2 Root chain PoSW stake retrieval

File areas:

- `goquarkchain/core/minorblockchain.go:1732-1777`
- `goquarkchain/core/rootblockchain.go:1129-1152`

Change:

- Replace single `stakes` read with dual values from contract.
- Compute deterministic `effectiveStake` in Go consensus path.
- Keep signer recovery check unchanged in principle:
  - still require block signer == registered signer.

### 6.3 PoSW info RPC

File area:

- `goquarkchain/core/rootblockchain.go:1422+`
- `goquarkchain/cluster/rpc/grpc_types.go`

Change:

- Extend PoSWInfo to include:
  - `lockedA`
  - `lockedB`
  - `effectiveStake`
  - `weightA`
  - `weightB`
  - `ratioRequirementActive`

## 7) Config schema changes

File area:

- `goquarkchain/cluster/config/config.go`

Add fields to `POSWConfig`:

- `StakeTokenAID uint64`
- `StakeTokenBID uint64`
- `StakeWeightA uint64` (fixed-point, e.g., basis points)
- `StakeWeightB uint64`
- `MinStakeA *big.Int`
- `MinStakeB *big.Int` (optional)
- `MaxBContributionPercent uint64`
- `RatioActivationBlock uint64`
- `MinBtoARatioPercent uint64` (if ratio policy desired)
- `UseGovernanceForRatio bool`

Behavior:

- If current block < `RatioActivationBlock`, ratio checks disabled.
- After activation, enforce configured ratio and caps.

## 8) Validator voting for shard activation (8 -> max 16)

Goal:

- Replace block-height deterministic activation with validator vote activation.

Rules:

- Start active shards at 8.
- Max shards 16.
- Monotonic increase only.
- No downgrade.

Governance state:

- `currentActiveShards`
- `targetActiveShards` (must equal `current + 1`)
- `voteEpoch`
- `votes[validator]`
- `quorumThreshold` (e.g., >= 2/3 weighted by effective stake)
- `activationDelayBlocks`

Execution:

- At epoch boundary, evaluate votes.
- If quorum met, schedule activation at `epochEnd + delay`.
- Activation writes immutable checkpoint event for that increment.

Security:

- Votes signed by validator signer.
- One vote per validator per epoch.
- Replay protection with epoch+chain domain separator.

## 9) Rewards model

- Base block reward split by effective stake weight and performance.
- Reward components:
  - `baseReward`
  - `uptimeBonus`
  - `crossShardServiceBonus` (optional)
- Reward payout token options:
  - Option 1: payout in TokenA only.
  - Option 2: split payout by treasury policy.

Recommendation:

- Start with payout in TokenA to reduce accounting complexity.

## 10) Slashing and unbonding

- Slashable events:
  - double-sign at same height/slot
  - conflicting finality vote
  - invalid shard-activation vote signature or equivocation
- Penalty order:
  - slash TokenB first up to cap, then TokenA.
- Unbonding:
  - delayed withdrawal window.
- Jailing:
  - temporary disable from proposing/voting.

## 11) API and RPC changes

Add endpoints:

- `getValidatorStake(address)` -> `lockedA, lockedB, effectiveStake, signer, status`
- `getValidatorVotes(epoch)` -> votes and quorum progress
- `submitShardActivationVote(targetShards, epoch, signature)`
- `getShardActivationState()`

Update existing outputs:

- Include dual stake fields in block extra info and mining info endpoints.

## 12) Migration plan

Phase 0:

- Deploy upgraded root PoSW staking contract V2.
- Keep ratio inactive.
- Keep current shard count at 8.

Phase 1:

- Enable dual locking and effective stake calculation.
- Enable signer checks with V2 reads.
- Expose RPC fields.

Phase 2:

- Enable shard activation voting logic.
- Keep max cap at 16.
- Run dry epochs on testnet.

Phase 3:

- Enable ratio enforcement at configured activation block.
- Enable slashing and unbonding operations.

Phase 4:

- Enable finality vote penalties and governance hardening.

## 13) Test plan

Unit tests:

- Effective stake calculation edge cases.
- Min stake floor and B-cap behavior.
- Ratio activation off/on transitions.
- Signer mismatch rejection.
- Vote replay rejection.

Integration tests:

- Dual staking lock/unlock lifecycle with unbonding.
- Root and minor difficulty adjustment with dual stake.
- Shard activation 8 -> 9 -> ... -> 16 monotonic path.
- No downgrade attempts.

Adversarial tests:

- Conflicting votes.
- Double-sign blocks.
- Quorum manipulation attempts.
- Cross-shard load during shard activation.

Operational tests:

- Node restart during pending activation.
- Reorg around activation boundary.
- Contract upgrade rollback handling.

## 14) Acceptance criteria

- Validators can lock TokenA and/or TokenB independently.
- Consensus uses deterministic weighted effective stake.
- Ratio checks remain off until activation condition is reached.
- Shard activation is vote-driven, monotonic, and capped at 16.
- Slashing and unbonding are enforced in consensus-critical flow.
- RPC surfaces full validator stake/vote visibility.

## 15) Explicit non-goals

- No dependence on off-chain price feeds for consensus weighting.
- No shard deactivation path.
- No emergency admin override that can silently reduce active shards.

## 16) Immediate implementation order in this repo

1. Add config fields and defaults in `goquarkchain/cluster/config/config.go`.
2. Add contract V2 methods and call wrappers in `goquarkchain/core/vm/contracts.go`.
3. Upgrade root stake retrieval path in `goquarkchain/core/minorblockchain.go` and `goquarkchain/core/rootblockchain.go`.
4. Replace minor-chain single-token stake read with weighted dual-token effective stake in `goquarkchain/core/minorblockchain.go`.
5. Extend PoSW RPC structures and encoders.
6. Add shard activation vote data model and validation path.
7. Add slashing and unbonding enforcement hooks.
8. Add unit/integration/adversarial tests.

