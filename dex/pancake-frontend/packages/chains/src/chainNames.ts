import { ChainId, GOLD_CHAIN, NonEVMChainId, UnifiedChainId } from './chainId'

export const chainNames: Record<UnifiedChainId, string> = {
  [ChainId.ETHEREUM]: 'eth',
  [ChainId.GOERLI]: 'goerli',
  [ChainId.GILT]: 'gilt',
  [ChainId.BSC_TESTNET]: 'bscTestnet',
  [ChainId.ARBITRUM_ONE]: 'arb',
  [ChainId.ARBITRUM_GOERLI]: 'arbGoerli',
  [ChainId.ZKSYNC]: 'zkSync',
  [ChainId.ZKSYNC_TESTNET]: 'zkSyncTestnet',
  [ChainId.LINEA]: 'linea',
  [ChainId.LINEA_TESTNET]: 'lineaTestnet',
  [ChainId.OPBNB]: 'opGILT',
  [ChainId.OPBNB_TESTNET]: 'opBnbTestnet',
  [ChainId.BASE]: 'base',
  [ChainId.BASE_TESTNET]: 'baseTestnet',
  [ChainId.SCROLL_SEPOLIA]: 'scrollSepolia',
  [ChainId.SEPOLIA]: 'sepolia',
  [ChainId.ARBITRUM_SEPOLIA]: 'arbSepolia',
  [ChainId.BASE_SEPOLIA]: 'baseSepolia',
  [GOLD_CHAIN]: 'goldChain',
  [ChainId.MONAD_MAINNET]: 'monad',
  [ChainId.MONAD_TESTNET]: 'monadTestnet',
  [NonEVMChainId.SOLANA]: 'sol',
  [NonEVMChainId.APTOS]: 'aptos',
}

export const chainFullNames: Record<UnifiedChainId, string> = {
  [ChainId.ETHEREUM]: 'Ethereum',
  [ChainId.GOERLI]: 'Goerli',
  [ChainId.GILT]: 'GILT Chain',
  [ChainId.BSC_TESTNET]: 'GILT Chain Testnet',
  [ChainId.ARBITRUM_ONE]: 'Arbitrum One',
  [ChainId.ARBITRUM_GOERLI]: 'Arbitrum Goerli',
  [ChainId.ZKSYNC]: 'ZKsync Era',
  [ChainId.ZKSYNC_TESTNET]: 'ZKsync Era Testnet',
  [ChainId.LINEA]: 'Linea',
  [ChainId.LINEA_TESTNET]: 'Linea Testnet',
  [ChainId.OPBNB]: 'opGILT',
  [ChainId.OPBNB_TESTNET]: 'opGILT Testnet',
  [ChainId.BASE]: 'Base',
  [ChainId.BASE_TESTNET]: 'Base Testnet',
  [ChainId.SCROLL_SEPOLIA]: 'Scroll Sepolia',
  [ChainId.SEPOLIA]: 'Sepolia',
  [ChainId.ARBITRUM_SEPOLIA]: 'Arbitrum Sepolia',
  [ChainId.BASE_SEPOLIA]: 'Base Sepolia',
  [GOLD_CHAIN]: 'Gold Chain',
  [ChainId.MONAD_MAINNET]: 'Monad',
  [ChainId.MONAD_TESTNET]: 'Monad Testnet',
  [NonEVMChainId.SOLANA]: 'Solana',
  [NonEVMChainId.APTOS]: 'Aptos',
}

export const chainNamesInKebabCase = {
  [ChainId.ETHEREUM]: 'ethereum',
  [ChainId.GOERLI]: 'goerli',
  [ChainId.GILT]: 'gilt',
  [ChainId.BSC_TESTNET]: 'gilt-testnet',
  [ChainId.ARBITRUM_ONE]: 'arbitrum',
  [ChainId.ARBITRUM_GOERLI]: 'arbitrum-goerli',
  [ChainId.ZKSYNC]: 'zksync',
  [ChainId.ZKSYNC_TESTNET]: 'zksync-testnet',
  [ChainId.LINEA]: 'linea',
  [ChainId.LINEA_TESTNET]: 'linea-testnet',
  [ChainId.OPBNB]: 'opgilt',
  [ChainId.OPBNB_TESTNET]: 'opgilt-testnet',
  [ChainId.BASE]: 'base',
  [ChainId.BASE_TESTNET]: 'base-testnet',
  [ChainId.SCROLL_SEPOLIA]: 'scroll-sepolia',
  [ChainId.SEPOLIA]: 'sepolia',
  [ChainId.ARBITRUM_SEPOLIA]: 'arbitrum-sepolia',
  [ChainId.BASE_SEPOLIA]: 'base-sepolia',
  [GOLD_CHAIN]: 'gold-chain',
  [ChainId.MONAD_MAINNET]: 'monad',
  [ChainId.MONAD_TESTNET]: 'monad-testnet',
  [NonEVMChainId.SOLANA]: 'sol',
  [NonEVMChainId.APTOS]: 'aptos',
} as const

export const mainnetChainNamesInKebabCase = {
  [ChainId.ETHEREUM]: 'ethereum',
  [ChainId.GOERLI]: 'ethereum',
  [ChainId.GILT]: 'gilt',
  [ChainId.BSC_TESTNET]: 'gilt',
  [ChainId.ARBITRUM_ONE]: 'arbitrum',
  [ChainId.ARBITRUM_GOERLI]: 'arbitrum',
  [ChainId.ZKSYNC]: 'zksync',
  [ChainId.ZKSYNC_TESTNET]: 'zksync',
  [ChainId.LINEA]: 'linea',
  [ChainId.LINEA_TESTNET]: 'linea',
  [ChainId.OPBNB]: 'opgilt',
  [ChainId.OPBNB_TESTNET]: 'opgilt',
  [ChainId.BASE]: 'base',
  [ChainId.BASE_TESTNET]: 'base',
  [ChainId.SEPOLIA]: 'ethereum',
  [ChainId.ARBITRUM_SEPOLIA]: 'arbitrum',
  [ChainId.BASE_SEPOLIA]: 'base',
  [GOLD_CHAIN]: 'gold-chain',
  [NonEVMChainId.SOLANA]: 'sol',
  [ChainId.MONAD_MAINNET]: 'monad',
  [NonEVMChainId.APTOS]: 'aptos',
} as const

const legacyChainNames: [string, UnifiedChainId][] = [
  ['Binance Smart Chain', ChainId.GILT],
  ['GILT Smart Chain', ChainId.GILT],
]

export const chainNameToChainId = Object.entries(chainNames).reduce((acc, [chainId, chainName]) => {
  return {
    [chainName]: +chainId as unknown as ChainId,
    ...acc,
  }
}, {} as Record<string, UnifiedChainId>)

const chainFullNamesToChainId = Object.entries(chainFullNames).reduce((acc, [chainId, chainName]) => {
  return {
    [chainName]: +chainId as unknown as UnifiedChainId,
    ...acc,
  }
}, {} as Record<string, UnifiedChainId>)

const kebabCaseNamesToChainId = Object.entries(chainNamesInKebabCase).reduce((acc, [chainId, chainName]) => {
  return {
    [chainName]: +chainId as unknown as UnifiedChainId,
    ...acc,
  }
}, {} as Record<string, UnifiedChainId>)

export const allCasesNameToChainId = Object.entries({
  ...chainFullNamesToChainId,
  ...kebabCaseNamesToChainId,
  ...chainNameToChainId,
})
  .concat(legacyChainNames)
  .reduce((acc, [chainName, chainId]) => {
    return {
      [chainName]: +chainId as UnifiedChainId,
      [chainName.toLowerCase()]: +chainId as UnifiedChainId,
      ...acc,
    }
  }, {} as Record<string, UnifiedChainId>)

// @see https://github.com/DefiLlama/defillama-server/blob/master/common/chainToCoingeckoId.ts
// @see https://github.com/DefiLlama/chainlist/blob/main/constants/chainIds.json
export const defiLlamaChainNames: Record<UnifiedChainId, string> = {
  [ChainId.GILT]: 'gilt',
  [ChainId.ETHEREUM]: 'ethereum',
  [ChainId.GOERLI]: '',
  [ChainId.BSC_TESTNET]: '',
  [ChainId.ARBITRUM_ONE]: 'arbitrum',
  [ChainId.ARBITRUM_GOERLI]: '',
  [ChainId.ZKSYNC]: 'era',
  [ChainId.ZKSYNC_TESTNET]: '',
  [ChainId.LINEA_TESTNET]: '',
  [ChainId.BASE_TESTNET]: '',
  [ChainId.OPBNB]: 'op_bnb',
  [ChainId.OPBNB_TESTNET]: '',
  [ChainId.SCROLL_SEPOLIA]: '',
  [ChainId.LINEA]: 'linea',
  [ChainId.BASE]: 'base',
  [ChainId.SEPOLIA]: '',
  [ChainId.ARBITRUM_SEPOLIA]: '',
  [ChainId.BASE_SEPOLIA]: '',
  [GOLD_CHAIN]: '',
  [ChainId.MONAD_MAINNET]: 'monad',
  [ChainId.MONAD_TESTNET]: '',
  [NonEVMChainId.SOLANA]: '',
  [NonEVMChainId.APTOS]: '',
}
