# GOLD Route Accounting Specification

## Role

GOLD is the gold-backed asset layer. It is separate from GILT.

## Phase 1 backing

Phase 1 GOLD is backed by Ethereum custody of root assets:

- PAXG deposits create PAXG-backed GOLD claims.
- XAUT deposits create XAUT-backed GOLD claims.

## Route IDs

Recommended canonical route tokens:

```text
1 = PAXG-backed GOLD claim
2 = XAUT-backed GOLD claim
```

## Redemption rules

- PAXG-backed GOLD can only redeem PAXG.
- XAUT-backed GOLD can only redeem XAUT.
- The bridge must reject wrong-route withdrawals.

## Supply invariants

```text
routeSupply[PAXG] <= lockedPAXG * PAXG_TO_GOLD_RATIO
routeSupply[XAUT] <= lockedXAUT * XAUT_TO_GOLD_RATIO
```

## Phase 2 migration

Phase 2 introduces reserve-backed GOLD through a separate reserve controller. Old Phase 1 route claims remain redeemable unless the user explicitly migrates them through the migration controller.
