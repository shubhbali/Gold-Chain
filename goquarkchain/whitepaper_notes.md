# Gilt Chain - Whitepaper Notes

## Tokens

**GOLD:**
- Gold-backed token
- Elastic supply
- Minted 1000:1 for PAXG/XAUT deposits

**GILT:**
- Governance token
- Fixed 100M supply at genesis
- Inflationary block rewards (8% initial, 15% annual decay, Solana model)

## Genesis Allocation (GILT)

| Allocation | Amount |
|------------|--------|
| Treasury | 35M |
| Team | 20M |
| Emergency | 5M |
| Airdrop | 40M |
| **Total** | **100M** |

## Chain Architecture

- 1 chain, 16 shards
- Estimated ~3,200-4,000 TPS
- Chain ID: 19711 (testnet), 19710 (mainnet)
- Native multi-token support (gas payable in GOLD or GILT)

## Consensus - PoSW (Proof of Staked Work)

- Hybrid: stake reduces mining difficulty
- No minimum stake required
- Staking value based on DEX pool price (no oracle needed)
- GILT ratio configurable via governance (disabled at launch)

## GILT Ratio Governance

- Floor: 5% (minimum GILT required)
- Cap: 30% (maximum GILT required)
- Enactment window: 60 days after proposal
- Governance can only move within 5-30% range
- Protects validators (worst case 30%) and GILT holders (at least 5% utility)

### Implementation

- Contract: `contracts/GiltRatioGovernance.sol`
- System contract address: `0x514b430000000000000000000000000000000004`
- GILT holders can propose ratio changes
- 60-day delay before activation
- Validation code reads ratio from contract storage

## Validator Rewards

- Block rewards: GILT (inflationary, decaying)
- Transaction fees: whatever token user paid (GOLD or GILT)

## Launch Strategy

- Launch centralized (like Solana, BSC, Base)
- LSD protocol from day one
- Users stake GOLD in LSD, earn yield
- No GILT ratio required initially

## Decentralization Roadmap

- **Phase 1:** Controlled validators, LSD for users
- **Phase 2:** Open validator applications (vetted)
- **Phase 3:** Permissionless validators with GILT ratio requirement

## Open Decisions

- Solana has 1.5% inflation floor, our code has no floor (decays toward zero) - decision needed
- DEX needs to launch first or use fixed ratio initially for staking price
