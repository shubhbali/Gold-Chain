# GOLD Route Accounting Specification

## Role

GOLD is the gold-backed asset layer. It is separate from GILT.

## Phase 1 backing

Phase 1 GOLD is route-backed by Ethereum custody of approved root assets:

- PAXG deposits create PAXG-backed GOLD route claims.
- XAUT deposits create XAUT-backed GOLD route claims.

Root-side PAXG and XAUT are locked in Ethereum custody after finality. They are not burned. Redemption burns/debits the matching Gold Chain GOLD route claim and releases the same root asset class.

## Canonical route IDs and simulated testnet tokens

The Ethereum-testnet launch uses simulated PAXG/XAUT contracts, but their token metadata must match mainnet decimals so accounting does not change at mainnet cutover.

- Route 1: PAXG-backed GOLD claim
  - symbol: PAXG
  - mainnet reference token: `0x45804880De22913dAFE09f4980848ECE6EcbAf78`
  - root decimals: 18
  - GOLD route decimals: 18
  - scaling: root amount × `10^(18 - 18)` = GOLD amount
- Route 2: XAUT-backed GOLD claim
  - symbol: XAUT
  - mainnet reference token: `0x68749665FF8D2d112Fa859AA293F07A622782F38`
  - root decimals: 6
  - GOLD route decimals: 18
  - scaling: root amount × `10^(18 - 6)` = GOLD amount

Production relayer config must include explicit scaling metadata for every enabled route. Missing route scaling is a configuration failure.

## Redemption rules

- PAXG-backed GOLD can only redeem PAXG.
- XAUT-backed GOLD can only redeem XAUT.
- The bridge must reject wrong-route withdrawals.
- XAUT redemptions must convert 18-decimal GOLD route units back to exact 6-decimal XAUT root units. Non-exact conversions must be rejected rather than rounded.

## Supply invariants

```text
routeSupply[PAXG] <= lockedPAXG scaled to 18-decimal GOLD units
routeSupply[XAUT] <= lockedXAUT scaled to 18-decimal GOLD units
```

## Phase 2 migration

Phase 2 introduces reserve-backed GOLD through a separate reserve controller. New old-route issuance and old-route yield can be stopped during migration, but old Phase 1 route claims remain redeemable unless the user explicitly migrates them through the migration controller.

Admin/governance must not be able to permanently stop old bridged GOLD redemptions while old PAXG/XAUT-backed claims remain outstanding. The migration path burns the old route claim first, then mints reserve-backed GOLD, so migrated claims cannot later redeem PAXG/XAUT.
