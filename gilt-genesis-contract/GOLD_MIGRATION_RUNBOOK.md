# Gold Migration Runbook

This runbook describes the dormant-until-activated migration model now built into the contracts.

## Target Model

- `old GOLD` stays redeemable
- migration remains off until governance explicitly activates it
- `old GOLD` stops being used for staking only at cutover
- `new GOLD` becomes the live staking gold
- `GILT` stays live
- staked `old GOLD` is auto-converted
- wallet `old GOLD` migrates through the migration controller
- `old GOLD` taken from migration goes into protocol reserve
- each deployed `PhysicalGold1155` has an immutable bridge ratio

## What Is Already In Code

- `GoldMigrationController` lifecycle states: `INACTIVE -> PREPARE -> ACTIVE -> EXIT_ONLY -> FINALIZED`
- `StakeHub` migration cutover is governance-controlled
- wallet + stake conversions use one canonical conversion engine
- old unbond requests created before cutover still claim old gold
- reserve vault contract exists for captured legacy assets
- `PhysicalGold1155` mints only from bridge deposits and controller-gated migration while migration minting is enabled
- `PhysicalGold1155` has immutable bridge ratio

## What Still Needs Forge Later

- compile and test the contracts
- package the updated `StakeHub` into the Gilt Chain node
- deploy the new contracts on a real test network

## Before Cutover

You need these addresses ready:

- new gold token
- reserve vault
- swap contract
- validator address to test
- delegator wallet to test

No pre-funding reserve is required for conversion. Conversion mints `new GOLD` against captured `old GOLD`.

## Cutover Order

1. Deploy `new GOLD` (with explicit ratio constructor args), reserve vault, and migration controller.
2. Deploy optional router contract (`GoldMigrationSwap1155`) at any time; it no longer requires prepared controller token addresses at deploy time.
3. Set `migrationController` on `new GOLD` to migration controller address.
4. Submit governance calls to:
   - set `StakeHub` migration controller
   - controller `activatePrepare(...)`
   - optional controller `setWalletMigrationRouter(...)`
   - controller `activateMigration()`
   - `GovHub.updateParam("activateTokenBMigration", abi.encode(newGold, reserveVault), stakeHub)`
   - direct `StakeHub.activateTokenBMigration(...)` is intentionally disabled in production flow
5. From that point on, new staking uses new gold.
6. Wallet users migrate old gold to new gold 1:1 via controller/router.
7. Staked users auto-convert when they interact with staking.
8. Move old bridge path to `EXIT_ONLY`, then `FINALIZED` after cutoff using one governance bundle per phase.

## Bridge Ratio Policy

- bridge ratio is fixed in `PhysicalGold1155` constructor and cannot be changed afterward
- `setBridgeDepositor` rotates only bridge operator address; it does not change ratio
- changing ratio requires deploying a new `GOLD` contract and migrating bridge route/state to that new deployment
- `DEFAULT_ADMIN_ROLE` must be held by governance timelock/multisig, not an operator hot key

## RPC Scripts Added

These do not need Forge once contracts are live.

### 1. Generate governance calldata for activation

```bash
LEGACY_GOLD_ADDRESS=... \
FINAL_GOLD_ADDRESS=... \
RESERVE_VAULT_ADDRESS=... \
MIGRATION_CONTROLLER_ADDRESS=... \
node scripts/activate-gold-migration.js
```

### 2. Check migration state

```bash
RPC_URL=... \
VALIDATOR_ADDRESS=... \
DELEGATOR_ADDRESS=... \
RESERVE_VAULT_ADDRESS=... \
TOKEN_IDS=1,2 \
node scripts/check-gold-migration-state.js
```

### 3. Swap old gold to new gold

```bash
RPC_URL=... \
PRIVATE_KEY=... \
SWAP_CONTRACT_ADDRESS=... \
TOKEN_ID=1 \
AMOUNT_WEI=... \
node scripts/swap-legacy-gold.js
```

## Phase transition bundle

The old Polygon PoS portal phase script was removed in the production overhaul. Phase transitions now belong to the canonical Gold contracts:

```bash
# Generate/apply governance calldata through the canonical GoldPhaseRegistry,
# GoldBridgeMinter, GoldRootCustody, and GoldMigrationController stack.
# Do not use the removed Polygon PoS portal; it is not a production fallback.
```

Use `GoldPhaseRegistry` transitions in order:

```text
BridgeBacked -> MigrationAnnounced -> BridgeDepositsStopped -> MigrationOpen -> LegacyRedemptionOnly
```

## Dry Run Checklist

### Wallet swap

- user starts with old gold
- user approves migration controller
- user runs swap/router
- user ends with new gold
- reserve vault receives old gold

### Staked migration

- validator has delegated old gold
- migration controller is `ACTIVE`
- cutover is activated
- delegator undelegates or claims reward
- old staked gold moves to reserve
- position becomes new-gold-backed via minted active gold in `StakeHub`

### Legacy unstake check

- user had already unstaked old gold before cutover
- after cutover, claim still pays old gold

## Success Looks Like

- `StakeHub` shows new gold as active gold
- old gold shows as legacy gold
- reserve balance goes up
- delegator active stake stays the same amount
- delegator legacy stake goes to zero
- migration counters reconcile per token ID: captured old gold == minted new gold
