import { GOLD_CHAIN } from '@pancakeswap/chains'
import dynamic from 'next/dynamic'
import { NextPageWithLayout } from 'utils/page.types'
import SwapLayout from 'views/Swap/SwapLayout'

const SwapView = dynamic(() => import('views/SwapSimplify'), { ssr: false })

const Swap = () => {
  return (
    <SwapLayout>
      <SwapView />
    </SwapLayout>
  )
}

const SwapPage = dynamic(() => Promise.resolve(Swap), {
  ssr: false,
}) as NextPageWithLayout

SwapPage.chains = [GOLD_CHAIN]
SwapPage.forceMultipleNetworkModal = true
SwapPage.screen = true

export default SwapPage
