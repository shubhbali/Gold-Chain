# Gold Migration Runbook

This is the simple migration model now built into the contracts.

## Target Model

- `old GOLD` stays redeemable
- `old GOLD` stops being used for staking
- `new GOLD` becomes the live staking gold
- `GILT` stays live
- staked `old GOLD` is auto-converted
- `old GOLD` taken from migration goes into protocol reserve

## What Is Already In Code

- `StakeHub` can switch from old gold to new gold
- still-staked old gold can auto-convert
- old gold already waiting in the unstake queue still comes out as old gold
- a reserve vault contract exists
- a simple 1:1 wallet swap contract exists
- a new gold token contract exists

## What Still Needs Forge Later

- compile and test the contracts
- package the updated `StakeHub` into the BSC node
- deploy the new contracts on a real test network

## Before Cutover

You need these addresses ready:

- new gold token
- reserve vault
- swap contract
- validator address to test
- delegator wallet to test

You also need enough new gold ready to fund the migration reserve inside `StakeHub`.

## Cutover Order

1. Deploy new gold, reserve vault, and swap contract.
2. Make sure swap contract has enough new gold for wallet swaps.
3. Activate migration in `StakeHub`.
4. Fund the `StakeHub` migration reserve with new gold.
5. From that point on, new staking uses new gold.
6. Wallet users can swap old gold to new gold 1:1.
7. Staked users get auto-converted when they interact with staking.

## RPC Scripts Added

These do not need Forge once contracts are live.

### 1. Activate cutover and fund reserve

```bash
RPC_URL=... \
PRIVATE_KEY=... \
NEW_GOLD_ADDRESS=... \
RESERVE_VAULT_ADDRESS=... \
MIGRATION_RESERVE_WEI=... \
node scripts/activate-gold-migration.js
```

### 2. Check migration state

```bash
RPC_URL=... \
VALIDATOR_ADDRESS=... \
DELEGATOR_ADDRESS=... \
RESERVE_VAULT_ADDRESS=... \
node scripts/check-gold-migration-state.js
```

### 3. Swap old gold to new gold

```bash
RPC_URL=... \
PRIVATE_KEY=... \
SWAP_CONTRACT_ADDRESS=... \
AMOUNT_WEI=... \
node scripts/swap-legacy-gold.js
```

## Dry Run Checklist

### Wallet swap

- user starts with old gold
- user runs swap
- user ends with new gold
- reserve vault receives old gold

### Staked migration

- validator has delegated old gold
- cutover is activated
- reserve is funded
- delegator undelegates or claims reward
- old staked gold moves to reserve
- position becomes new-gold-backed

### Legacy unstake check

- user had already unstaked old gold before cutover
- after cutover, claim still pays old gold

## Success Looks Like

- `StakeHub` shows new gold as active gold
- old gold shows as legacy gold
- reserve balance goes up
- delegator active stake stays the same amount
- delegator legacy stake goes to zero
