# GILT Token Block Rewards & Inflation

## Solana's Inflation Model

- **Initial inflation rate:** 8%
- **Disinflation rate:** 15% per year (multiply by 0.85 each year)
- **Terminal inflation floor:** 1.5% (never goes below this)

**Formula:**
```
Inflation_Year_N = Inflation_Year_(N-1) × 0.85
```

**Example decay:**
- Year 1: 8.0%
- Year 2: 6.8%
- Year 3: 5.78%
- Year 4: 4.91%
- Year 5: 4.18%
- Year 10-12: reaches 1.5% floor

## QuarkChain Code (Gilt Chain Fork)

- **BLOCK_REWARD_DECAY_FACTOR:** Equivalent to Solana's disinflation rate (e.g., 0.85 = 15% reduction per epoch)
- **EPOCH_INTERVAL:** Determines how often decay applies
- **Terminal inflation floor:** NONE - decays toward zero

**Key difference:** Solana maintains a 1.5% minimum inflation forever. QuarkChain code has no floor, so block rewards would eventually decay to near-zero.

## Decision Needed

1. Add a floor to the code (like Solana's 1.5%)?
2. Or let it decay to zero and rely on gas fees only long-term?
