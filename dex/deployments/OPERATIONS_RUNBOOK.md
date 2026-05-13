# Gold Chain DEX Operations Runbook

## Emergency Pause Policy
- Scope: swaps, liquidity actions, farms, lottery actions with operator controls.
- Authority: timelock-approved emergency executor multisig only.
- Rule: user exits and withdrawals stay enabled whenever technically possible.

## Incident Severity
- `Sev-1`: active fund risk, cross-contract invariant break, bridge-accounting mismatch.
- `Sev-2`: persistent swap failure, broken pricing/indexing, or systemic transaction failures.
- `Sev-3`: degraded feature behavior without direct fund risk.

## Incident Response Flow
1. Detect and classify severity.
2. Freeze affected controls (pause module if required).
3. Publish incident status with impacted contracts and user actions.
4. Ship forward-fix on testnet and replay failure case.
5. Roll out fix on mainnet using timelock/multisig path.
6. Publish postmortem with root cause, corrective action, and prevention checks.

## Rollback/Forward-Fix Strategy
- Default strategy is forward-fix; avoid state rollbacks unless chain-level governance authorizes.
- For frontend/indexer incidents, roll back service config while contracts remain unchanged.
- For contract incidents, use pause + patched release path; no silent hotfixes.

## Access-Control Rotation
- Quarterly signer rotation for all launch multisigs.
- Immediate rotation on any key compromise signal.
- Rotation requires:
  - new signer attestation
  - threshold verification
  - on-chain event verification
