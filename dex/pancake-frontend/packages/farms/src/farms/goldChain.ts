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
    pid: process.env.NEXT_PUBLIC_GOLD_CHAIN_DEX_GOLD_PAXG_FARM_PID,
    lpAddress: process.env.NEXT_PUBLIC_GOLD_CHAIN_DEX_GOLD_PAXG_LP_ADDRESS,
    lpSymbol: 'DEX-GOLD(PAXG) LP',
    token: goldChainTokens.dex,
    quoteToken: goldChainTokens.goldPaxg,
  }),
  createOptionalFarm({
    pid: process.env.NEXT_PUBLIC_GOLD_CHAIN_DEX_GOLD_XAUT_FARM_PID,
    lpAddress: process.env.NEXT_PUBLIC_GOLD_CHAIN_DEX_GOLD_XAUT_LP_ADDRESS,
    lpSymbol: 'DEX-GOLD(XAUT) LP',
    token: goldChainTokens.dex,
    quoteToken: goldChainTokens.goldXaut,
  }),
  createOptionalFarm({
    pid: process.env.NEXT_PUBLIC_GOLD_CHAIN_GOLD_PAXG_USDT_FARM_PID,
    lpAddress: process.env.NEXT_PUBLIC_GOLD_CHAIN_GOLD_PAXG_USDT_LP_ADDRESS,
    lpSymbol: 'GOLD(PAXG)-USDT LP',
    token: goldChainTokens.goldPaxg,
    quoteToken: goldChainTokens.usdt,
  }),
  createOptionalFarm({
    pid: process.env.NEXT_PUBLIC_GOLD_CHAIN_GOLD_XAUT_USDT_FARM_PID,
    lpAddress: process.env.NEXT_PUBLIC_GOLD_CHAIN_GOLD_XAUT_USDT_LP_ADDRESS,
    lpSymbol: 'GOLD(XAUT)-USDT LP',
    token: goldChainTokens.goldXaut,
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
    pid: process.env.NEXT_PUBLIC_GOLD_CHAIN_GOLD_PAXG_GILT_FARM_PID,
    lpAddress: process.env.NEXT_PUBLIC_GOLD_CHAIN_GOLD_PAXG_GILT_LP_ADDRESS,
    lpSymbol: 'GOLD(PAXG)-GILT LP',
    token: goldChainTokens.goldPaxg,
    quoteToken: goldChainTokens.gilt,
  }),
  createOptionalFarm({
    pid: process.env.NEXT_PUBLIC_GOLD_CHAIN_GOLD_XAUT_GILT_FARM_PID,
    lpAddress: process.env.NEXT_PUBLIC_GOLD_CHAIN_GOLD_XAUT_GILT_LP_ADDRESS,
    lpSymbol: 'GOLD(XAUT)-GILT LP',
    token: goldChainTokens.goldXaut,
    quoteToken: goldChainTokens.gilt,
  }),
].filter((farm): farm is SerializedFarmConfig => Boolean(farm))
