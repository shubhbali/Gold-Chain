# Gold Chain DEX Security Gates

## Release Blocking Criteria
- No open critical or high findings across V2, WGILT/WGOLD wrappers, farms, stable-swap, ve/voter, and lottery.
- All medium findings must have either a merged fix or an approved compensating control with owner and expiry.
- Deployer keys must not retain privileged ownership after deployment finalization.

## Required Evidence Before Mainnet Cutover
- Internal security review report with commit hash and deployment manifest digest.
- External audit report(s) and remediation report mapped to exact commits.
- Differential test report comparing audited bytecode hashes to final deployment bytecode hashes.
- Access-control verification report:
  - multisig owners
  - timelock parameters
  - emergency pause roles
  - revoked deployer roles

## Freeze Window
- `T-72h`: code freeze for launch scope repositories.
- `T-48h`: final testnet replay from clean state with launch scripts only.
- `T-24h`: manifest-signature verification, final go/no-go review.
- `T-0h`: mainnet deploy.

## Post-Deploy Security Checks
- Verify bytecode and constructor args for all launch contracts.
- Verify ownership and timelock assignments on-chain.
- Verify subgraph indexing starts from expected factory block and no stale backfill gap.
