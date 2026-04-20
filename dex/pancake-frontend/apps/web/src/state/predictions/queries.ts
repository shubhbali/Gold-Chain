import { PredictionSupportedSymbol } from '@pancakeswap/prediction'
import { betBaseFields as betBaseFieldsBNB, userBaseFields as userBaseFieldsBNB } from './bnbQueries'
import { betBaseFields as betBaseFieldsCAKE, userBaseFields as userBaseFieldsCAKE } from './cakeQueries'
import {
  betBaseFields as newBetBaseFields,
  roundBaseFields as newRoundBaseFields,
  userBaseFields as newUserBaserBaseFields,
} from './newTokenQueries'

export const getRoundBaseFields = newRoundBaseFields

export const getBetBaseFields = (tokenSymbol: string) => {
  // GILT CAKE
  if (tokenSymbol === PredictionSupportedSymbol.CAKE) {
    return betBaseFieldsCAKE
  }
  // GILT GILT
  if (tokenSymbol === PredictionSupportedSymbol.GILT || tokenSymbol === 'tBNB') {
    return betBaseFieldsBNB
  }

  return newBetBaseFields
}

export const getUserBaseFields = (tokenSymbol: string) => {
  // GILT CAKE
  if (tokenSymbol === PredictionSupportedSymbol.CAKE) {
    return userBaseFieldsCAKE
  }
  // GILT GILT
  if (tokenSymbol === PredictionSupportedSymbol.GILT || tokenSymbol === 'tBNB') {
    return userBaseFieldsBNB
  }

  return newUserBaserBaseFields
}
