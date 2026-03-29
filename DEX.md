# DEX

## Current Direction

`Uniswap V2` or `Aerodrome` is not chosen yet.

The token-handling model is the same either way:

- Users see and use raw `GOLD`
- Users see and use raw `GILT`
- The DEX trades wrapped ERC20 forms underneath

## How It Works

### `GILT`

- `GILT` is the native chain coin
- The DEX uses `wGILT`
- The router wraps raw `GILT` into `wGILT` before the swap
- The router unwraps `wGILT` back into raw `GILT` on output

This is the same pattern as raw `ETH` and `WETH`.

### `GOLD`

- Raw `GOLD` is ERC1155
- The DEX does not trade raw ERC1155 directly
- The DEX uses `wGOLD`
- A wrapper contract takes raw `GOLD` in and mints ERC20 `wGOLD`
- On exit, the wrapper burns `wGOLD` and returns raw `GOLD`

## User Experience

To the user, both assets can feel like raw assets:

- swap `GOLD` for `GILT`
- add liquidity with `GOLD` and `GILT`
- remove liquidity back into `GOLD` and `GILT`

Under the hood, the DEX holds and trades:

- `wGOLD`
- `wGILT`

## Rule

Bridge, staking, migration, redemption, and the DEX must all use one clean final `GOLD` and `GILT` model.
