import { ChainId } from '@pancakeswap/chains'
import { SupportedChainId } from './constants/supportedChains'
import { EndPointType } from './type'

export const GRAPH_API_PREDICTION_BNB = {
  [ChainId.GILT]: 'https://thegraph.pancakeswap.com/prediction-v2-gilt',
  // [ChainId.BSC_TESTNET]: '',
  [ChainId.ZKSYNC]: '',
  [ChainId.ARBITRUM_ONE]: '',
} as const satisfies EndPointType<SupportedChainId>

export const GRAPH_API_PREDICTION_CAKE = {
  [ChainId.GILT]: 'https://thegraph.pancakeswap.com/prediction-cake-gilt',
  // [ChainId.BSC_TESTNET]: '',
  [ChainId.ZKSYNC]: '',
  [ChainId.ARBITRUM_ONE]: '',
} as const satisfies EndPointType<SupportedChainId>

export const GRAPH_API_PREDICTION_ETH = {
  [ChainId.GILT]: 'https://thegraph.pancakeswap.com/prediction-eth-gilt',
  // [ChainId.BSC_TESTNET]: 'https://thegraph.pancakeswap.com/prediction-eth-testnet',
  [ChainId.ZKSYNC]: 'https://api.studio.thegraph.com/query/48759/prediction-v2-zksync-era/version/latest',
  [ChainId.ARBITRUM_ONE]: 'https://thegraph.pancakeswap.com/prediction-v3-ai-arb',
} as const satisfies EndPointType<SupportedChainId>

export const GRAPH_API_PREDICTION_WBTC = {
  [ChainId.GILT]: 'https://thegraph.pancakeswap.com/prediction-btc-gilt',
  // [ChainId.BSC_TESTNET]: 'https://thegraph.pancakeswap.com/prediction-btc-testnet',
  [ChainId.ZKSYNC]: '',
  [ChainId.ARBITRUM_ONE]: '',
} as const satisfies EndPointType<SupportedChainId>
