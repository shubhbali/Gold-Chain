import { ChainId, GOLD_CHAIN } from '@pancakeswap/chains'
import { SerializedFarm } from '@pancakeswap/farms'
import { masterChefGoldChainABI } from 'config/abi/masterchefGoldChain'
import { masterChefV2ABI } from 'config/abi/masterchefV2'
import chunk from 'lodash/chunk'
import { farmFetcher } from 'state/farms'
import { isNotUndefinedOrNull } from 'utils/isNotUndefinedOrNull'
import { publicClient } from 'utils/wagmi'
import { AbiStateMutability, ContractFunctionReturnType } from 'viem'
import { SerializedFarmConfig } from '../../config/constants/types'
import { getMasterChefV2Address } from '../../utils/addressHelpers'

const isGoldChainMasterChef = (chainId: number) => chainId === GOLD_CHAIN

const getFarmQueryChainId = (chainId: number) => {
  if (isGoldChainMasterChef(chainId)) return GOLD_CHAIN
  return farmFetcher.isTestnet(chainId) ? ChainId.BSC_TESTNET : ChainId.GILT
}

export const fetchMasterChefFarmPoolLength = async (chainId: number) => {
  try {
    const client = publicClient({ chainId })
    const masterChefV2Address = getMasterChefV2Address(chainId)
    const poolLength = masterChefV2Address
      ? await client.readContract({
          abi: isGoldChainMasterChef(chainId) ? masterChefGoldChainABI : masterChefV2ABI,
          address: masterChefV2Address,
          functionName: 'poolLength',
        })
      : 0n

    return Number(poolLength)
  } catch (error) {
    console.error('Fetch MasterChef Farm Pool Length Error: ', error)
    return 0
  }
}

const masterChefFarmCalls = (farm: SerializedFarm) => {
  const { pid, quoteToken } = farm
  const multiCallChainId = getFarmQueryChainId(quoteToken.chainId)
  const masterChefAddress = getMasterChefV2Address(multiCallChainId)
  const masterChefPid = pid
  const abi = isGoldChainMasterChef(multiCallChainId) ? masterChefGoldChainABI : masterChefV2ABI

  return masterChefAddress && (masterChefPid || masterChefPid === 0)
    ? ([
        {
          abi,
          address: masterChefAddress,
          functionName: 'poolInfo',
          args: [masterChefPid],
        },
        {
          abi,
          address: masterChefAddress,
          functionName: isGoldChainMasterChef(multiCallChainId) ? 'totalAllocPoint' : 'totalRegularAllocPoint',
        },
      ] as const)
    : ([null, null] as const)
}

export type PoolInfo = ContractFunctionReturnType<typeof masterChefV2ABI, AbiStateMutability, 'poolInfo'> | readonly [
  `0x${string}`,
  bigint,
  bigint,
  bigint,
]
export type TotalRegularAllocPoint = bigint

export const fetchMasterChefData = async (
  farms: SerializedFarmConfig[],
  chainId: number,
): Promise<[PoolInfo | null, TotalRegularAllocPoint | null][]> => {
  const masterChefCalls = farms.map((farm) => masterChefFarmCalls(farm))
  const chunkSize = masterChefCalls.flat().length / farms.length
  const masterChefAggregatedCalls = masterChefCalls
    .filter((masterChefCall) => masterChefCall[0] !== null && masterChefCall[1] !== null)
    .flat()
    .filter(isNotUndefinedOrNull)

  const multiCallChainId = getFarmQueryChainId(chainId)
  const client = publicClient({ chainId: multiCallChainId })
  const masterChefMultiCallResult = await client.multicall({
    contracts: masterChefAggregatedCalls,
    allowFailure: false,
  })

  const masterChefChunkedResultRaw = chunk(masterChefMultiCallResult, chunkSize)

  let masterChefChunkedResultCounter = 0
  return masterChefCalls.map((masterChefCall) => {
    if (masterChefCall[0] === null && masterChefCall[1] === null) {
      return [null, null]
    }
    const data = masterChefChunkedResultRaw[masterChefChunkedResultCounter] as [PoolInfo, TotalRegularAllocPoint]
    masterChefChunkedResultCounter++
    return data
  })
}
