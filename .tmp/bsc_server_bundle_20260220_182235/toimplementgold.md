# Gold Chain Execution Checklist (Plain English)

1. Define the rules first.
- Write down exactly how validators are chosen, how they vote, when a block is final, and how shard count can increase.
- Freeze these rules before coding.

2. Add a new consensus mode in config.
- Keep old modes for compatibility.
- Add validator mode and boot testnet with it.

3. Build validator identity and signing.
- Each validator has a key for block and vote signatures.
- Every node verifies signatures the same way.

4. Build validator set management.
- Keep active validator list per epoch.
- Store voting power per validator.
- Ensure deterministic validator list from chain state.

5. Replace proof-of-work seal check with proposer check.
- Check proposer is correct for slot.
- Check signature is valid.
- Reject block if either check fails.

6. Add vote/attestation logic.
- Validators vote on blocks.
- Collect and verify votes.
- Mark justified/finalized when quorum is reached.

7. Add finality rules.
- After finality, do not allow reorgs past finalized point.

8. Move stake logic into one shared power calculator.
- Compute power from both tokens:
- power = f(tokenA stake, tokenB stake, weights)
- Use this same function everywhere.

9. Launch with ratio disabled.
- Allow staking with either token from day 1.
- Do not enforce ratio at launch.

10. Add ratio activation switch for later.
- Governance can activate ratio at a defined block/epoch.
- After activation, enforce ratio policy for eligibility/power.

11. Implement shard expansion voting.
- Start at 8 shards.
- Validators can only vote for current+1.
- Max 16 shards.
- Never allow decrease.
- Execute increase only with quorum + delay.

12. Keep unified API behavior unchanged.
- Users should keep sending normal wallet/protocol inputs.
- Router continues shard handling automatically.

13. Add observability APIs.
- Expose validator set, validator power, finality status, shard activation status, and votes.

14. Test in layers.
- Unit tests: proposer checks, signatures, power calculator, ratio rules.
- Multi-node tests: deterministic proposer order, quorum, finality.
- Shard tests: 8->9 works, rollback attempts fail, >16 fails.

15. Run testnet in phases.
- Phase A: validator consensus + finality only.
- Phase B: dual-token power active, ratio off.
- Phase C: shard activation voting.
- Phase D: ratio activation governance test.
