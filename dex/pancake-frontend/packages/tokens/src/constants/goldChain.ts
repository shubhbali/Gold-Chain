import { GOLD_CHAIN } from '@pancakeswap/chains'
import { ERC20Token, WNATIVE } from '@pancakeswap/sdk'

import { CAKE, USDT } from './common'

const GOLD_CHAIN_WEBSITE = process.env.NEXT_PUBLIC_GOLD_CHAIN_WEBSITE || 'http://localhost:3000'
const isGoldChainProdBuild =
  process.env.NODE_ENV === 'production' && process.env.NEXT_PUBLIC_VERCEL_ENV !== 'preview'
const ZERO_ADDRESS_PATTERN = /^0x0{40}$/i

function requireGoldChainAddressEnv(key: string, fallback: `0x${string}`): `0x${string}` {
  const value = (process.env[key] || fallback) as `0x${string}`
  if (isGoldChainProdBuild && ZERO_ADDRESS_PATTERN.test(value)) {
    throw new Error(`[gold-chain-config] Missing required address env: ${key}`)
  }
  return value
}

const GOLD_CHAIN_GOLD_PAXG_ADDRESS =
  requireGoldChainAddressEnv('NEXT_PUBLIC_GOLD_CHAIN_GOLD_PAXG_ADDRESS', '0x0000000000000000000000000000000000000000')
const GOLD_CHAIN_GOLD_XAUT_ADDRESS =
  requireGoldChainAddressEnv('NEXT_PUBLIC_GOLD_CHAIN_GOLD_XAUT_ADDRESS', '0x0000000000000000000000000000000000000000')
const wgilt = WNATIVE[GOLD_CHAIN]!

export const goldChainTokens = {
  wgilt,
  gilt: new ERC20Token(GOLD_CHAIN, wgilt.address, 18, 'GILT', 'Gold Chain GILT', GOLD_CHAIN_WEBSITE),
  goldPaxg: new ERC20Token(
    GOLD_CHAIN,
    GOLD_CHAIN_GOLD_PAXG_ADDRESS,
    18,
    'GOLD-PAXG',
    'Gold Chain GOLD (PAXG Route)',
    GOLD_CHAIN_WEBSITE,
  ),
  goldXaut: new ERC20Token(
    GOLD_CHAIN,
    GOLD_CHAIN_GOLD_XAUT_ADDRESS,
    18,
    'GOLD-XAUT',
    'Gold Chain GOLD (XAUT Route)',
    GOLD_CHAIN_WEBSITE,
  ),
  gold: new ERC20Token(
    GOLD_CHAIN,
    GOLD_CHAIN_GOLD_PAXG_ADDRESS,
    18,
    'GOLD-PAXG',
    'Gold Chain GOLD (PAXG Route)',
    GOLD_CHAIN_WEBSITE,
  ),
  dex: CAKE[GOLD_CHAIN],
  usdt: USDT[GOLD_CHAIN],
}
