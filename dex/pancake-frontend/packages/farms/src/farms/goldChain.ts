import { goldChainTokens } from '@pancakeswap/tokens'
import { getAddress } from 'viem'

import { SerializedFarmConfig } from '../types'

type OptionalFarmParams = {
  pid?: string
  lpAddress?: string
  lpSymbol: string
  token: SerializedFarmConfig['token']
  quoteToken: SerializedFarmConfig['quoteToken']
}

const createOptionalFarm = ({ pid, lpAddress, lpSymbol, token, quoteToken }: OptionalFarmParams) => {
  if (!pid || !lpAddress) return null

  return {
    pid: Number(pid),
    lpSymbol,
    lpAddress: getAddress(lpAddress),
    token,
    quoteToken,
  } satisfies SerializedFarmConfig
}

export const legacyFarmConfig: SerializedFarmConfig[] = [
  createOptionalFarm({
    pid: process.env.NEXT_PUBLIC_GOLD_CHAIN_DEX_GILT_FARM_PID,
    lpAddress: process.env.NEXT_PUBLIC_GOLD_CHAIN_DEX_GILT_LP_ADDRESS,
    lpSymbol: 'DEX-GILT LP',
    token: goldChainTokens.dex,
    quoteToken: goldChainTokens.gilt,
  }),
  createOptionalFarm({
    pid: process.env.NEXT_PUBLIC_GOLD_CHAIN_DEX_GOLD_FARM_PID,
    lpAddress: process.env.NEXT_PUBLIC_GOLD_CHAIN_DEX_GOLD_LP_ADDRESS,
    lpSymbol: 'DEX-GOLD LP',
    token: goldChainTokens.dex,
    quoteToken: goldChainTokens.gold,
  }),
  createOptionalFarm({
    pid: process.env.NEXT_PUBLIC_GOLD_CHAIN_GOLD_USDT_FARM_PID,
    lpAddress: process.env.NEXT_PUBLIC_GOLD_CHAIN_GOLD_USDT_LP_ADDRESS,
    lpSymbol: 'GOLD-USDT LP',
    token: goldChainTokens.gold,
    quoteToken: goldChainTokens.usdt,
  }),
  createOptionalFarm({
    pid: process.env.NEXT_PUBLIC_GOLD_CHAIN_GILT_USDT_FARM_PID,
    lpAddress: process.env.NEXT_PUBLIC_GOLD_CHAIN_GILT_USDT_LP_ADDRESS,
    lpSymbol: 'GILT-USDT LP',
    token: goldChainTokens.gilt,
    quoteToken: goldChainTokens.usdt,
  }),
  createOptionalFarm({
    pid: process.env.NEXT_PUBLIC_GOLD_CHAIN_GOLD_GILT_FARM_PID,
    lpAddress: process.env.NEXT_PUBLIC_GOLD_CHAIN_GOLD_GILT_LP_ADDRESS,
    lpSymbol: 'GOLD-GILT LP',
    token: goldChainTokens.gold,
    quoteToken: goldChainTokens.gilt,
  }),
].filter((farm): farm is SerializedFarmConfig => Boolean(farm))
