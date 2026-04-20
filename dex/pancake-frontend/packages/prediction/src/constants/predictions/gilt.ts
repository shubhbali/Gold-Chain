import { ChainId } from '@pancakeswap/chains'
import { ERC20Token, Native } from '@pancakeswap/sdk'
import { bscTokens } from '@pancakeswap/tokens'
import {
  chainlinkOracleBNB,
  chainlinkOracleCAKE,
  chainlinkOracleETH,
  chainlinkOracleWBTC,
} from '../../chainlinkOracleContract'
import {
  GRAPH_API_PREDICTION_BNB,
  GRAPH_API_PREDICTION_CAKE,
  GRAPH_API_PREDICTION_ETH,
  GRAPH_API_PREDICTION_WBTC,
} from '../../endpoints'
import { predictionsBNB, predictionsCAKE, predictionsETH, predictionsWBTC } from '../../predictionContract'
import { PredictionConfig, PredictionContractVersion, PredictionSupportedSymbol } from '../../type'

const BTC = new ERC20Token(bscTokens.wBTC.chainId, bscTokens.wBTC.address, bscTokens.wBTC.decimals, 'BTC', 'Bitcoin')

// @ts-ignore
BTC.logoURI = 'https://tokens.pancakeswap.finance/images/symbol/wbtc.png'

export const predictions: Record<string, PredictionConfig> = {
  [PredictionSupportedSymbol.GILT]: {
    version: PredictionContractVersion.V2,

    betCurrency: Native.onChain(ChainId.GILT),
    predictionCurrency: Native.onChain(ChainId.GILT),

    address: predictionsBNB[ChainId.GILT],
    api: GRAPH_API_PREDICTION_BNB[ChainId.GILT],
    chainlinkOracleAddress: chainlinkOracleBNB[ChainId.GILT],

    displayedDecimals: 4,
    tokenBackgroundColor: '#F0B90B',
  },
  [PredictionSupportedSymbol.ETH]: {
    version: PredictionContractVersion.V2_1,

    betCurrency: Native.onChain(ChainId.GILT),
    predictionCurrency: bscTokens.eth,

    address: predictionsETH[ChainId.GILT],
    api: GRAPH_API_PREDICTION_ETH[ChainId.GILT],
    chainlinkOracleAddress: chainlinkOracleETH[ChainId.GILT],

    displayedDecimals: 2,
    balanceDecimals: 4,
  },
  [PredictionSupportedSymbol.BTC]: {
    version: PredictionContractVersion.V2_1,

    betCurrency: Native.onChain(ChainId.GILT),
    predictionCurrency: BTC,

    address: predictionsWBTC[ChainId.GILT],
    api: GRAPH_API_PREDICTION_WBTC[ChainId.GILT],
    chainlinkOracleAddress: chainlinkOracleWBTC[ChainId.GILT],

    displayedDecimals: 2,
    balanceDecimals: 4,
  },
  [PredictionSupportedSymbol.CAKE]: {
    paused: true,
    version: PredictionContractVersion.V3,

    betCurrency: bscTokens.cake,
    predictionCurrency: bscTokens.cake,

    address: predictionsCAKE[ChainId.GILT],
    api: GRAPH_API_PREDICTION_CAKE[ChainId.GILT],
    chainlinkOracleAddress: chainlinkOracleCAKE[ChainId.GILT],

    displayedDecimals: 4,
    tokenBackgroundColor: '#25C7D6',
  },
}
