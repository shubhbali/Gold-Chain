import { GOLD_CHAIN } from '@pancakeswap/chains'
import { ERC20Token, WNATIVE } from '@pancakeswap/sdk'

import { CAKE, USDT } from './common'

const GOLD_CHAIN_WEBSITE = process.env.NEXT_PUBLIC_GOLD_CHAIN_WEBSITE || 'http://localhost:3000'
const GOLD_CHAIN_GOLD_ADDRESS =
  (process.env.NEXT_PUBLIC_GOLD_CHAIN_GOLD_ADDRESS || '0x0000000000000000000000000000000000000000') as `0x${string}`
const wgilt = WNATIVE[GOLD_CHAIN]!

export const goldChainTokens = {
  wgilt,
  gilt: new ERC20Token(GOLD_CHAIN, wgilt.address, 18, 'GILT', 'Gold Chain GILT', GOLD_CHAIN_WEBSITE),
  gold: new ERC20Token(GOLD_CHAIN, GOLD_CHAIN_GOLD_ADDRESS, 18, 'GOLD', 'Gold Chain GOLD', GOLD_CHAIN_WEBSITE),
  dex: CAKE[GOLD_CHAIN],
  usdt: USDT[GOLD_CHAIN],
}
