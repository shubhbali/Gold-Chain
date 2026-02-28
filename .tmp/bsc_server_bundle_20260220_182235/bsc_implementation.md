# BSC Implementation Strategy

1. Keep Parlia (PoSA) as the base consensus.
2. Replace single-token voting power with dual-token effective power in `StakeHub`.
3. Enforce TokenA minimum stake for validator eligibility (security anchor).
4. Keep ratio enforcement disabled by default.
5. Add governance-controlled ratio activation switch (no fixed launch block required).
6. When activated, apply ratio policy as power cap/reduction first (not hard kick).
7. Add slashing support for both stake components with clear slash order.
8. Keep GOLD non-inflationary/backed; no GOLD emissions.
9. Add declining inflation only on GOV/GILT reward side.
10. Route GOLD-only user yield through LSD/pool layer, not direct validator security path.
11. Update Parlia election consumption to use new `getValidatorElectionInfo` power output.
12. Regenerate/update stake ABI used by `bsc/consensus/parlia/abi.go`.
13. Update hardfork/system contract packaging in `bsc/core/systemcontracts/upgrade.go`.
14. Keep backward compatibility for existing validators/delegators (no forced migration).
15. Add full tests for:
- dual-stake power math
- governance ratio on/off behavior
- slashing
- election determinism
- reward accounting
16. Launch with ratio off, governance controls on, and validator expansion policy active.
17. Keep a future optional path to deeper PoS/finality changes, but do not block launch on that rewrite.
