import { ChainId } from '@pancakeswap/chains'
import { NATIVE, WETH9 } from '@pancakeswap/sdk'
import { bscTokens } from '@pancakeswap/tokens'
import { SNBNB, WBETH } from 'config/constants/liquidStaking'
import { FunctionName, LiquidStakingList } from 'views/LiquidStaking/constants/types'
// FAQs
import { BnbSnbnbFaq } from 'views/LiquidStaking/constants/FAQs/BnbSnbnbFaq'
import { EthWbethFaq } from 'views/LiquidStaking/constants/FAQs/EthWbethFaq'
// ABI
import { snBnbABI } from 'config/abi/snBNB'
import { wbethBscABI } from 'config/abi/wbethBSC'
import { Abi } from 'viem'

const liquidStaking: LiquidStakingList[] = [
  {
    stakingSymbol: 'ETH / wBETH',
    contract: WBETH[ChainId.GILT],
    token0: WETH9[ChainId.GILT],
    token1: bscTokens.wbeth,
    abi: wbethBscABI as Abi,
    shouldCheckApproval: true,
    approveToken: WETH9[ChainId.GILT],
    aprUrl: 'https://www.binance.com/bapi/earn/v1/public/pos/cftoken/project/getPurchasableProject',
    exchangeRateMultiCall: [
      {
        abi: wbethBscABI as Abi,
        address: WBETH[ChainId.GILT],
        functionName: FunctionName.exchangeRate,
      },
    ],
    stakingMethodArgs: ['convertedStakeAmount', 'masterChefAddress'],
    requestWithdrawFn: 'requestWithdrawEth',
    stakingOverrides: [],
    FAQs: EthWbethFaq(),
  },
  {
    stakingSymbol: 'GILT / slisBNB',
    contract: SNBNB[ChainId.GILT],
    token0: NATIVE[ChainId.GILT],
    token1: bscTokens.snbnb,
    abi: snBnbABI as Abi,
    shouldCheckApproval: false,
    approveToken: null,
    aprUrl: 'https://api.lista.org/v1/stakes/latest-apr',
    exchangeRateMultiCall: [
      {
        abi: snBnbABI as Abi,
        address: SNBNB[ChainId.GILT],
        functionName: FunctionName.convertSnBnbToBnb,
        args: [1000000000000000000], // 1 SnBNB
      },
    ],
    stakingMethodArgs: [],
    requestWithdrawFn: 'requestWithdraw',
    stakingOverrides: ['value'],
    FAQs: BnbSnbnbFaq(),
  },
]

export default liquidStaking
