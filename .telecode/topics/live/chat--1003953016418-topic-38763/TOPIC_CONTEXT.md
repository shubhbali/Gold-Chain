# Topic Context

- Topic: chat--1003953016418-topic-38763
- Project: gold-chain
- Status: active
- Engine: codex
- Profile: 

## Transcript History
- [2026-04-28T17:18:28Z] assistant (assistant_message): Switched this topic to project 'gold-chain'.
- [2026-04-28T17:18:34Z] user (user_message): read only task, dont change codeÑ

Alright so read the code files now and tell me exactly how the blockchain works and what are the different features for this?
- [2026-04-28T17:22:50Z] assistant (assistant_message): Gold Chain works as a two-client blockchain: **GiltConsensus** handles validators, finality, checkpoints, and bridge attestation, while **Gilt** (execution client) runs EVM block production and transaction execution; bridge flow is **PAXG/XAUT locked on Ethereum after finality → GOLD minted/credited on Gold Chain → GOLD burned/debited on Gold Chain for redemption → PAXG/XAUT released on Ethereum**.

How it works end-to-end:
1. Validators stake and participate in consensus voting.
2. Consensus decides producer sets in span/sprint windows.
3. Execution client only accepts blocks from authorized producers for that span/sprint.
4. Transactions execute in EVM state; blocks are sealed with Gilt consensus rules.
5. Side-transaction vote extensions let validators attest external events (bridge/checkpoint/state-sync).
6. Only confirmed/finalized external events are accepted into state transitions.
7. Checkpoint and milestone logic anchor child-chain progress and finality assumptions.
8. Fee/reward allocation is distributed to active validators with chain rules.

Main features:
- Native validator lifecycle: join, update, signer update, unbond/exit.
- Validator-governed approvals with >2/3 power thresholds.
- Staking plus GOLD delegation accounting.
- Reward weighting with on-chain pricefeed snapshots.
- Chainmanager-controlled bridge/contract addresses and confirmation parameters.
- Clerk state-sync ingestion from Ethereum with replay protection.
- Checkpoint proposal/ack/nack flow with signature handling.
- Top-up and withdrawal fee-token accounting path.
- Milestone majority selection and continuity validation.
- Producer election/rotation logic (including planned downtime handling).
- EVM compatibility via execution client fork architecture.

Why this matters:
- This split architecture keeps execution performance and EVM compatibility while consensus enforces validator safety and bridge correctness, which is required for safe GOLD backing with locked Ethereum-side PAXG/XAUT.

What should be done next:
1. Define the final, non-temporary bridge confirmation policy (block confirmations/finality thresholds) per route.
2. Audit all bridge/event paths to ensure no non-finalized event can mint/credit/unlock value.
3. Run full integration tests for deposit, mint, checkpoint, redemption, and validator-rotation edge cases before mainnet gating.

## Run History
- b57f9f0e93da4134bf488c4a3a35384b | codex | done
  prompt: read only task, dont change codeÑ

Alright so read the code files now and tell me exactly how the blockchain works and what are the different features for this?
  final: Gold Chain works as a two-client blockchain: **GiltConsensus** handles validators, finality, checkpoints, and bridge attestation, while **Gilt** (execution client) runs EVM block production and transaction execution; bridge flow is **PAXG/XAUT locked on Ethereum after finality → GOLD minted/credited on Gold Chain →...
  event: Finished (0): sed -n '260,560p' bridge/gilt-exec/consensus/gilt/span_store.go
  event: Running: sed -n '1,280p' bridge/gilt-exec/consensus/gilt/snapshot.go
  event: Finished (0): sed -n '1,280p' bridge/gilt-exec/consensus/gilt/snapshot.go
  event: Running: sed -n '1,260p' bridge/gilt-exec/consensus/gilt/span_store.go
  event: Finished (0): sed -n '1,260p' bridge/gilt-exec/consensus/gilt/span_store.go
  event: Done.
