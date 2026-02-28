# BSC Dual-Token Implementation Steps

This document is the execution guide for the BSC-based chain upgrade.

## 1. Consensus Direction
1. Keep Parlia (PoSA) as the base consensus engine.
2. Upgrade staking/election economics to stake-dominant behavior.
3. Keep future PoS/finality rewrite optional and separate from launch scope.

## 2. Token Roles (Locked)
1. TokenA = GILT (security anchor, fixed supply governance token).
2. TokenB = GOLD (backed/elastic token, additional stake contribution).

## 3. Launch Rules (Locked)
1. Both TokenA and TokenB are stakeable from launch.
2. Ratio enforcement is disabled at launch.
3. Validator security floor remains on TokenA self-delegation.

## 4. Staking Power Model
1. Effective validator power:
   `power = weightedA + weightedB`
2. Weighted components:
   `weightedA = stakeA * stakeWeightA / 10000`
   `weightedB = stakeB * stakeWeightB / 10000`
3. TokenB contribution is capped by TokenA-derived power.
4. If ratio is enabled and ratio is not met, TokenB contribution is reduced/ignored.

## 5. Governance Ratio Policy (Locked)
1. Governance can activate ratio later.
2. Minimum ratio starts at 10% GOLD vs GILT.
3. Governance can increase ratio up to 50%.
4. Initial enforcement mode is soft (reduce/remove TokenB contribution), not immediate validator kickout.

## 6. Slashing Policy
1. Keep existing slashing/jailing active from day one.
2. Dual-asset slash order:
   - Slash TokenB first.
   - Slash TokenA for the remainder.
3. Keep validator liveness and equivocation penalties strict.

## 7. Reward and Inflation Policy
1. GOLD remains non-inflationary and backed (no GOLD emissions).
2. GILT carries declining inflation emissions (Solana-style decay curve).
3. Reward sources:
   - GILT emissions
   - Gas/fee rewards
4. Baseline reward split:
   - 70% delegators
   - 20% validator operator
   - 10% treasury

## 8. Contract Layer Tasks
1. Extend `StakeHub` with dual-token power parameters and governance updates.
2. Add TokenB delegation/undelegation accounting.
3. Add TokenB unbond-delay queue (production-safe unstake path).
4. Add/complete dual-asset slashing hooks.
5. Preserve backward compatibility for existing TokenA stake state.

## 9. Consensus Layer Tasks
1. Ensure `getValidatorElectionInfo` returns dual-token effective power.
2. Sync Parlia ABI with updated StakeHub interface.
3. Validate top-validator election remains deterministic.
4. Verify voting power scaling/normalization safety.

## 10. System Upgrade Wiring
1. Rebuild/update system contract artifacts.
2. Wire updated contract bytecode in `bsc/core/systemcontracts/upgrade.go`.
3. Ensure network profile consistency (mainnet/chapel/rialto targets used by project).

## 11. Test Requirements
1. Dual-token power math and caps.
2. Ratio off/on governance transitions.
3. TokenB stake lifecycle and unbond behavior.
4. Slashing order and penalty correctness.
5. Election determinism and validator ordering.
6. Reward accounting consistency.

## 12. Rollout Safety Gates
1. Start with ratio disabled.
2. Enable governance controls and observability first.
3. Activate ratio only after live stability review.
4. Keep emergency pause controls for staking extensions.

## 13. Out of Scope for Current Delivery
1. Full consensus-engine rewrite away from Parlia.
2. Hard validator ejection on first ratio violation.
3. Any change to GOLD backing model.
