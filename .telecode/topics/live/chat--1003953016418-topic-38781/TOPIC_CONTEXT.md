# Topic Context

- Topic: chat--1003953016418-topic-38781
- Project: gold-chain
- Status: active
- Engine: codex
- Profile: 

## Transcript History
- [2026-04-28T17:19:24Z] assistant (assistant_message): Switched this topic to project 'gold-chain'.
- [2026-04-28T17:19:29Z] user (user_message): read only task, dont change codeÑ

Alright so read the code files now and tell me exactly how the blockchain works and what are the different features for this?
- [2026-04-28T17:23:51Z] assistant (assistant_message): Gold Chain works as a dual-client blockchain: **GiltConsensus** runs validator consensus and bridge coordination, and **Gilt** runs EVM execution and block production.

How it works end-to-end:
1. Validators stake and participate in consensus on GiltConsensus.
2. GiltConsensus decides producer sets in spans/sprints and feeds that authority to Gilt.
3. Gilt only accepts blocks from valid scheduled producers and executes EVM transactions.
4. Bridge events are processed with confirmation/finality rules before state changes are accepted.
5. For gold assets: `PAXG`/`XAUT` are locked on Ethereum, `GOLD` is minted or credited on Gold Chain, `GOLD` is burned or debited on redemption, then `PAXG`/`XAUT` are released on Ethereum.
6. Checkpoints/milestones/state-sync keep Ethereum-side and Gold Chain-side state aligned.

Main features in this repo:
- Validator lifecycle: join, update, signer rotation, exit, slashing-related controls.
- Staking and delegation: `GILT` staking plus `GOLD` delegation/accounting paths.
- Governance-linked validator approval voting (>2/3 power finalization logic).
- Checkpoint and milestone finality pipeline.
- Bridge listeners/processors/worker queue for root-chain and child-chain flows.
- Side-transaction voting via vote extensions (ABCI++) for external-data safety.
- Chain manager settings for contract addresses and confirmation parameters.
- Price feed and reward weighting logic for validator economics.
- Full EVM execution client with custom Gilt consensus rules (span/sprint producer model).
- RPC, sync, txpool, tracing, and node operation surfaces from the execution client stack.

Why this matters for the project objective:
- It gives one coherent architecture where `GILT`, `GOLD`, bridge, staking, migration/redemption, and validator economics work as one production chain model instead of disconnected subsystems.

What should be done next:
1. Freeze this as the canonical architecture spec (one-page system contract).
2. Run a gap audit for any path that still behaves like temporary compatibility logic.
3. Validate bridge finality rules and `PAXG`/`XAUT` custody/release invariants with dedicated integration tests and operator runbooks.

## Run History
- 3f9333b170a84cfb813fbda2b4e79921 | codex | done
  prompt: read only task, dont change codeÑ

Alright so read the code files now and tell me exactly how the blockchain works and what are the different features for this?
  final: Gold Chain works as a dual-client blockchain: **GiltConsensus** runs validator consensus and bridge coordination, and **Gilt** runs EVM execution and block production. How it works end-to-end: 1. Validators stake and participate in consensus on GiltConsensus. 2. GiltConsensus decides producer sets in spans/sprints a...
  event: Finished (0): sed -n '1,340p' bridge/gilt-exec/consensus/gilt/api.go
  event: Running: sed -n '340,760p' bridge/gilt-exec/consensus/gilt/api.go
  event: Finished (0): sed -n '340,760p' bridge/gilt-exec/consensus/gilt/api.go
  event: Running: sed -n '1,340p' bridge/gilt-exec/consensus/gilt/errors.go
  event: Finished (0): sed -n '1,340p' bridge/gilt-exec/consensus/gilt/errors.go
  event: Done.
