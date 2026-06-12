# Gold Bridge Threat Model

## Assets at Risk

- Root PAXG custody balances.
- Root XAUT custody balances.
- Route-backed GOLD claims on Gold Chain.
- Reserve-backed GOLD after migration.
- Bridge finalizer/signer authority.
- Relayer persistent state and cursors.

## Actors

- User depositing root assets or withdrawing route-backed GOLD.
- Relayer observing finalized events and submitting bridge finalization transactions.
- Root custody governance.
- Child bridge governance.
- Threshold bridge signer committee.
- Gold Chain validator set.
- Attacker with RPC/log spoofing capability.
- Attacker with one or more compromised signer/finalizer keys.
- Attacker controlling a fee-on-transfer or rebasing token misconfigured as a route asset.

## Security Invariants

1. PAXG route ID `1` can only mint/release PAXG-backed GOLD.
2. XAUT route ID `2` can only mint/release XAUT-backed GOLD.
3. Root custody must only lock supported route IDs.
4. Root custody accounting must equal actual token balance received.
5. Relayed events must bind chain ID, bridge address, block hash, tx hash, log index, route, amount, and recipient.
6. Replays must be rejected on-chain and ignored safely by the relayer after restart.
7. Production finality must require conservative confirmations plus safe/finalized tags where supported.
8. A single hot relayer key must not be sufficient to forge arbitrary production mints/releases.

## Attack Classes Covered

- Forged mint from wrong root event.
- Forged release from wrong child event.
- Replay of deposits or withdrawals.
- Reorg/finality failure.
- Wrong route/token/symbol mapping.
- Fee-on-transfer overmint.
- Malformed recipient.
- Cursor advancement skipping pending events.
- Relayer crash after on-chain success but before state save.
- Governance route mutation after route finalization.
- Compromised minority threshold signer.

## Current Trust Model

The hardened bridge path uses threshold-signed, domain-separated bridge messages for destination-chain mint/release authorization. The relayer is a convenience submitter for gasless UX; it is not a trust or liveness dependency for root-chain release once a valid threshold proof exists.

## Permissionless Withdrawal Execution

Root-chain token release is permissionless after a finalized Gold Chain burn/withdrawal event has a valid threshold proof. Any wallet, keeper, sponsor, or project relayer may submit the proof. `GoldRootCustody` authorizes release only through threshold signature verification, source/destination chain binding, source/destination bridge binding, route/token binding, amount/recipient binding, signer-set version binding, locked-route accounting, and replay protection.

No bridge mint or root release may be executed from mempool state, pending transactions, or unfinalized events. Emergency pause and route withdrawal disable remain intentional incident-response controls.

## Required Production Trust Model

Production bridge finalization must verify threshold/quorum signatures or proof-based source-chain state on-chain. The signed/proven message must bind all security-critical fields and route metadata. Governance updates to signer sets and bridge parameters must be timelocked and covered by emergency pause procedures.
