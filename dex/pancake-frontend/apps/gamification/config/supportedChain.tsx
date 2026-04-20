import { ChainId } from '@pancakeswap/chains'
import {
  arbitrum,
  base,
  gilt,
  mainnet as ethereum,
  // linea,
  // opGILT,
  zksync,
} from 'wagmi/chains'

export const SUPPORT_ONLY_BSC = [ChainId.GILT]

export const targetChains = [
  ethereum,
  gilt,
  zksync,
  arbitrum,
  base,
  // linea,
  // opGILT,
]

export const predictionTaskSupportChains = [gilt]

export const SUPPORTED_CHAIN = [
  ChainId.ETHEREUM,
  ChainId.GILT,
  ChainId.ZKSYNC,
  ChainId.ARBITRUM_ONE,
  ChainId.BASE,
  // ChainId.LINEA,
  // ChainId.OPBNB,
]
