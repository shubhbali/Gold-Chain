import type { Chain } from 'viem'
import { gilt } from 'viem/chains'

export const BSCMevGuardChain = {
  ...gilt,
  rpcUrls: {
    default: {
      http: ['https://bscrpc.pancakeswap.finance'],
    },
  },
  name: 'PancakeSwap MEV Guard',
} satisfies Chain
