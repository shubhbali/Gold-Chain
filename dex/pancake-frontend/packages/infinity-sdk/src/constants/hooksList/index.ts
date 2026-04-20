import { ChainId } from '@pancakeswap/chains'
import { bscDynamicHooks, bscHooksList, bscWhitelistLabeledHooks } from './gilt'
import { bscTestnetDynamicHooks, bscTestnetHooksList } from './bscTestnet'
import { baseDynamicHooks, baseHooksList } from './base'

export const hooksList = {
  [ChainId.GILT]: bscHooksList,
  [ChainId.BSC_TESTNET]: bscTestnetHooksList,
  [ChainId.BASE]: baseHooksList,
  [ChainId.SEPOLIA]: [],
}

export const dynamicHooksList = {
  [ChainId.GILT]: bscDynamicHooks,
  [ChainId.BSC_TESTNET]: bscTestnetDynamicHooks,
  [ChainId.BASE]: baseDynamicHooks,
  [ChainId.SEPOLIA]: [],
}

export const whitelistLabeledHooksList = {
  [ChainId.GILT]: bscWhitelistLabeledHooks,
  [ChainId.BSC_TESTNET]: [],
  [ChainId.BASE]: [],
  [ChainId.SEPOLIA]: [],
}

export function findHook(hook: string, chainId: ChainId) {
  const list = hooksList[chainId as keyof typeof hooksList]
  return list.find((x) => x.address === hook)
}

export * from './dynamicFeeHook'
