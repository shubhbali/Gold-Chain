# PoSW in Plain English (With Real-World Examples)

This document explains what the current code does when people say:

`"PoSW state gives an edge"`

It is based directly on the code in this repo.

## 1) What "PoSW gives an edge" actually means

In this codebase, the edge is:

- If a miner/validator has enough stake
- And has not already mined too many recent blocks
- Then the system lowers their **effective mining difficulty**
- Which means they can mine more easily than someone without that PoSW condition

This logic is implemented in:

- `goquarkchain/consensus/posw/posw.go`

Core lines:

- Threshold from stake: `blockThreshold = stakes / stakePerBlock` (`posw.go:49`)
- No threshold => no advantage (`posw.go:50-52`)
- If mined count is below threshold, difficulty is reduced by `DiffDivider` (`posw.go:64-66`)

So "edge" is not vague in this repo. It is a specific formula-based difficulty reduction.

## 2) Simple formula view

The code behavior is effectively:

1. `mineable_blocks = floor(stakes / stake_per_block)`
2. Clamp to window size
3. Count how many blocks this coinbase already mined in recent window
4. If `mined_blocks < mineable_blocks`, apply easier difficulty:
   - `effective_difficulty = normal_difficulty / DiffDivider`
5. Otherwise no PoSW benefit

## 3) Real-world style examples

## Example A: You get the PoSW edge

Assume:

- `stake_per_block = 100 tokens`
- Your stake = `350 tokens`
- So your threshold = `3` mineable blocks (floor of 350/100)
- In current window, you have only mined `1` block
- `DiffDivider = 20`

Result:

- Because `1 < 3`, PoSW applies
- Your effective difficulty becomes `normal_difficulty / 20`
- You get easier mining for this block

## Example B: You lose the edge for now

Same setup, but now you already mined `3` blocks in the window.

Result:

- `mined_blocks == threshold`
- Condition `mined < threshold` is false
- No difficulty reduction
- You mine at normal difficulty until window dynamics change

## Example C: Not enough stake

Assume:

- `stake_per_block = 100 tokens`
- Your stake = `80 tokens`
- Threshold = `0`

Result:

- Code immediately returns normal difficulty
- No PoSW benefit

## 4) Where this is applied in the chain flow

PoSW-adjusted difficulty is wired into root and shard chains:

- Root chain path:
  - `goquarkchain/core/rootblockchain.go:1063` (`GetAdjustedDifficultyToMine`)
  - `goquarkchain/core/rootblockchain.go:1101` (`GetAdjustedDifficulty`)
- Minor (shard) chain path:
  - `goquarkchain/core/minorblockchain.go:466` (`GetAdjustedDifficulty`)

This means it is active in consensus difficulty decisions when enabled.

## 5) PoSW can also block some transactions

Separate from mining difficulty, PoSW also builds a sender disallow map:

- Built in: `goquarkchain/consensus/posw/posw.go:71-90`
- Applied to EVM state: `goquarkchain/core/minorblockchain.go:418-423`
- Enforced during tx execution:
  - Check: `goquarkchain/core/state_transition.go:439-445`
  - Error path: `goquarkchain/core/state_transition.go:240-241` and `332-336`

Plain English:

- If sender falls into a PoSW balance restriction condition, tx can fail with `ErrPoSWSenderNotAllowed`.

## 6) When PoSW is turned on

PoSW is only active when:

- `Enabled == true`
- `time >= EnableTimestamp`
- `height > 0`

Code:

- `goquarkchain/consensus/posw/posw.go:93-95`

## 7) Important: POW_SIMULATE is not production security

In simulate mode:

- Seal verification always returns success (`return nil`)
- File: `goquarkchain/consensus/simulate/simualte.go:54-56`

Plain English:

- This mode is for testing/simulation behavior, not real secure PoW validation.

## 8) Production question: tokens, infrastructure, or both?

Based on this repo's current logic:

- **PoSW edge** is token/stake-driven (stake amount vs per-block threshold).
- **Infrastructure** still matters in practical mining performance, but this code's PoSW advantage itself is computed from stake and recent mined count.

So for production mining competitiveness, it is effectively both:

- Token side (for PoSW advantage)
- Infrastructure side (for raw mining/operations ability)

## 9) Config knobs that control behavior

Main config fields:

- `DiffDivider`
- `WindowSize`
- `TotalStakePerBlock`
- `EnableTimestamp`
- `Enabled`

Defined in:

- `goquarkchain/cluster/config/config.go:66-85`

Defaults are also set there for root and shard PoSW configs.

## 10) One-line summary

In this repo, "PoSW gives an edge" means:

- Stake can buy you a temporary, rule-based reduction in effective mining difficulty, as long as you are below your stake-derived mined-block allowance in the recent window.

## 11) Cross-shard interoperability in plain English

This section explains how cross-shard works right now in this code, and where it is already seamless vs not seamless.

## 11.1 How the code decides a tx is cross-shard

A tx is cross-shard when source and destination chain/shard differ.

Code:

- `goquarkchain/core/types/transaction.go:216-218`

Plain English:

- If sender shard and target shard are different, it is treated as cross-shard.

## 11.2 What happens when a cross-shard tx is executed

Execution path:

- In state transition, if `msg.IsCrossShard()`, code routes to `AddCrossShardTxDeposit(...)`
- `goquarkchain/core/state_transition.go:228-230`

Inside that path, code:

- Deducts sender balance (`state.SubBalance(...)`)
- Creates a `CrossShardTransactionDeposit` object with from/to shard keys and payload
- Appends it to cross-shard list (`state.AppendXShardList(...)`)

Code:

- `goquarkchain/core/state_transition.go:338-409`

Plain English:

- The sending shard does not fully execute the remote action immediately.
- It creates a deposit record for the receiving shard to process.

## 11.3 How receiving shard applies it

Receiving flow:

- `RunCrossShardTxWithCursor(...)` iterates incoming cross-shard deposits
- Applies each deposit via `ApplyCrossShardDeposit(...)`
- Stops if cross-shard gas limit is reached

Code:

- `goquarkchain/core/minorblockchain_addon.go:1785-1823`

Plain English:

- Incoming cross-shard messages are processed in order, with gas caps, not magically instant.

## 11.4 Network propagation between shards

Broadcast code sends cross-shard deposit lists to neighbor shards and enforces neighbor checks.

Code:

- `goquarkchain/cluster/slave/conn_manager.go:117-133`
- `goquarkchain/cluster/slave/conn_manager.go:149-156`

Plain English:

- The system currently expects shard-to-shard forwarding with neighbor rules in this path.

## 11.5 What is seamless today vs what is not

### Seamless today

- User can submit a tx that targets another shard.
- System creates and routes deposit records automatically once a valid cross-shard tx exists.

### Not seamless today (important)

1. Depends on which API surface is used

- Legacy/base RPC path (`SendTxArgs`) still requires `fromFullShardKey`.
- Unified router path derives shard keys from addresses and routes automatically.

Code:

- Legacy requirement: `goquarkchain/internal/qkcapi/input_args.go:193-198`
- Unified derivation/routing:
  - `goquarkchain/internal/qkcapi/unified_api.go:29-31`
  - `goquarkchain/internal/qkcapi/unified_api.go:123-127`
  - `goquarkchain/internal/qkcapi/unified_api.go:438-446`

Plain English:

- If clients call legacy RPC directly, shard key inputs are still expected.
- If clients use your Unified API/router flow, users can send normal addresses and the system computes shard keys internally.

2. Cross-shard tx is rejected if target shard is not initialized

Code:

- `goquarkchain/core/minorblockchain_addon.go:273-283`

3. Cross-shard tx is rejected if destination is not a neighbor in current topology rules

Code:

- `goquarkchain/core/minorblockchain_addon.go:286-287`

4. Cross-shard gas limit constraints can reject/limit processing

Code:

- `goquarkchain/core/minorblockchain_addon.go:294-295`
- `goquarkchain/core/minorblockchain_addon.go:1818-1819`

## 11.6 Real-world examples (cross-shard)

## Example A: Normal same-shard transfer

- Alice and Bob are in shard S1.
- Tx is not cross-shard.
- It executes directly in one shard path.

## Example B: Cross-shard transfer that works

- Alice is in S1, Bob is in S3.
- Tx marked cross-shard.
- Sending shard creates deposit entry.
- Deposit is broadcast and later applied in receiving shard.
- User sees it may take longer than same-shard.

## Example C: Cross-shard transfer that fails early

- Alice sends to target shard not initialized yet.
- Tx is rejected with "shard is not initialized yet."
- Code path: `goquarkchain/core/minorblockchain_addon.go:281-283`

## Example D: Cross-shard blocked by topology rule

- Alice sends from S1 to a non-neighbor shard under current rules.
- Tx rejected as `ErrNotNeighbor`.
- Code path: `goquarkchain/core/minorblockchain_addon.go:286-287`

## 11.7 Bottom line for your goal

Your goal is:

- User should not care where the other wallet/protocol lives
- RPC should decide/reroute automatically

Current code partially supports cross-shard execution, but **does not fully hide shard complexity at API/validation level yet** because:

- caller-facing shard keys are still required in API path
- neighbor and initialization constraints are hard checks

So today it is "cross-shard capable," but not fully "shard-abstracted UX" end-to-end.
