/* eslint-disable prefer-const */
import { Pair, Token, Bundle } from '../types/schema'
import { BigDecimal, Address } from '@graphprotocol/graph-ts/index'
import { ZERO_BD, factoryContract, ADDRESS_ZERO, ONE_BD } from './helpers'
import { WGILT_ADDRESS, QUOTE_TOKEN_ADDRESSES, ROUTE_TOKEN_ADDRESSES } from './goldchainPricingConfig'

function normalizeAddress(address: string): string {
  return address.toLowerCase()
}

function isZeroAddress(address: string): boolean {
  return normalizeAddress(address) == ADDRESS_ZERO
}

function isWhitelisted(address: string): boolean {
  let normalized = normalizeAddress(address)
  for (let i = 0; i < WHITELIST.length; i++) {
    if (WHITELIST[i] == normalized) {
      return true
    }
  }
  return false
}

function isRouteToken(address: string): boolean {
  let normalized = normalizeAddress(address)
  for (let i = 0; i < ROUTE_TOKEN_ADDRESSES.length; i++) {
    if (normalizeAddress(ROUTE_TOKEN_ADDRESSES[i]) == normalized) {
      return true
    }
  }
  return false
}

function derivedEth(token: Token): BigDecimal {
  return token.derivedETH === null ? ZERO_BD : (token.derivedETH as BigDecimal)
}

export function getEthPriceInUSD(): BigDecimal {
  let stableTokens: string[] = QUOTE_TOKEN_ADDRESSES.filter((token) => !isZeroAddress(token))

  let weightedPrice = ZERO_BD
  let totalWeight = ZERO_BD
  for (let i = 0; i < stableTokens.length; i++) {
    let stable = normalizeAddress(stableTokens[i])
    let pairAddress = factoryContract.getPair(Address.fromString(WGILT_ADDRESS), Address.fromString(stable))
    if (pairAddress.toHexString() == ADDRESS_ZERO) {
      continue
    }
    let pair = Pair.load(pairAddress.toHexString())
    if (pair === null) {
      continue
    }

    let wgiltReserve = pair.token0.toLowerCase() == WGILT_ADDRESS ? pair.reserve0 : pair.reserve1
    if (wgiltReserve.equals(ZERO_BD)) {
      continue
    }
    let wgiltPriceInStable = pair.token0.toLowerCase() == WGILT_ADDRESS ? pair.token0Price : pair.token1Price
    weightedPrice = weightedPrice.plus(wgiltPriceInStable.times(wgiltReserve))
    totalWeight = totalWeight.plus(wgiltReserve)
  }

  if (totalWeight.equals(ZERO_BD)) {
    return ZERO_BD
  }
  return weightedPrice.div(totalWeight)
}

// token where amounts should contribute to tracked volume and liquidity
let WHITELIST: string[] = [WGILT_ADDRESS]

for (let i = 0; i < QUOTE_TOKEN_ADDRESSES.length; i++) {
  let token = normalizeAddress(QUOTE_TOKEN_ADDRESSES[i])
  if (!isZeroAddress(token) && !isWhitelisted(token)) {
    WHITELIST.push(token)
  }
}

// minimum liquidity for price to get tracked
let MINIMUM_LIQUIDITY_THRESHOLD_ETH = BigDecimal.fromString('1')

/**
 * Search through graph to find derived Eth per token.
 * @todo update to be derived ETH (add stablecoin estimates)
 **/
export function findEthPerToken(token: Token): BigDecimal {
  if (normalizeAddress(token.id) == WGILT_ADDRESS) {
    return ONE_BD
  }

  // GOLD route tokens on Gold Chain should be priced directly against WGILT.
  if (isRouteToken(token.id)) {
    let pairAddress = factoryContract.getPair(Address.fromString(token.id), Address.fromString(WGILT_ADDRESS))
    if (pairAddress.toHexString() != ADDRESS_ZERO) {
      let pair = Pair.load(pairAddress.toHexString())
      if (pair !== null && pair.reserveETH.gt(MINIMUM_LIQUIDITY_THRESHOLD_ETH)) {
        return pair.token0.toLowerCase() == normalizeAddress(token.id) ? pair.token0Price : pair.token1Price
      }
    }
  }

  // loop through whitelist and check if paired with any
  for (let i = 0; i < WHITELIST.length; ++i) {
    let pairAddress = factoryContract.getPair(Address.fromString(token.id), Address.fromString(normalizeAddress(WHITELIST[i])))
    if (pairAddress.toHexString() != ADDRESS_ZERO) {
      let pair = Pair.load(pairAddress.toHexString())
      if (pair === null) {
        continue
      }

      if (pair.token0 == token.id && pair.reserveETH.gt(MINIMUM_LIQUIDITY_THRESHOLD_ETH)) {
        let token1 = Token.load(pair.token1)
        if (token1 !== null) {
          return pair.token1Price.times(derivedEth(token1)) // return token1 per our token * Eth per token 1
        }
      }
      if (pair.token1 == token.id && pair.reserveETH.gt(MINIMUM_LIQUIDITY_THRESHOLD_ETH)) {
        let token0 = Token.load(pair.token0)
        if (token0 !== null) {
          return pair.token0Price.times(derivedEth(token0)) // return token0 per our token * ETH per token 0
        }
      }
    }
  }
  return ZERO_BD // nothing was found return 0
}

/**
 * Accepts tokens and amounts, return tracked amount based on token whitelist
 * If one token on whitelist, return amount in that token converted to USD.
 * If both are, return average of two amounts
 * If neither is, return 0
 */
export function getTrackedVolumeUSD(
  tokenAmount0: BigDecimal,
  token0: Token,
  tokenAmount1: BigDecimal,
  token1: Token
): BigDecimal {
  let bundle = Bundle.load('1') as Bundle
  let price0 = derivedEth(token0).times(bundle.ethPrice)
  let price1 = derivedEth(token1).times(bundle.ethPrice)

  // both are whitelist tokens, take average of both amounts
  if (isWhitelisted(token0.id) && isWhitelisted(token1.id)) {
    return tokenAmount0
      .times(price0)
      .plus(tokenAmount1.times(price1))
      .div(BigDecimal.fromString('2'))
  }

  // take full value of the whitelisted token amount
  if (isWhitelisted(token0.id) && !isWhitelisted(token1.id)) {
    return tokenAmount0.times(price0)
  }

  // take full value of the whitelisted token amount
  if (!isWhitelisted(token0.id) && isWhitelisted(token1.id)) {
    return tokenAmount1.times(price1)
  }

  // neither token is on white list, tracked volume is 0
  return ZERO_BD
}

/**
 * Accepts tokens and amounts, return tracked amount based on token whitelist
 * If one token on whitelist, return amount in that token converted to USD * 2.
 * If both are, return sum of two amounts
 * If neither is, return 0
 */
export function getTrackedLiquidityUSD(
  bundle: Bundle,
  tokenAmount0: BigDecimal,
  token0: Token,
  tokenAmount1: BigDecimal,
  token1: Token
): BigDecimal {
  let price0 = derivedEth(token0).times(bundle.ethPrice)
  let price1 = derivedEth(token1).times(bundle.ethPrice)

  // both are whitelist tokens, take average of both amounts
  if (isWhitelisted(token0.id) && isWhitelisted(token1.id)) {
    return tokenAmount0.times(price0).plus(tokenAmount1.times(price1))
  }

  // take double value of the whitelisted token amount
  if (isWhitelisted(token0.id) && !isWhitelisted(token1.id)) {
    return tokenAmount0.times(price0).times(BigDecimal.fromString('2'))
  }

  // take double value of the whitelisted token amount
  if (!isWhitelisted(token0.id) && isWhitelisted(token1.id)) {
    return tokenAmount1.times(price1).times(BigDecimal.fromString('2'))
  }

  // neither token is on white list, tracked volume is 0
  return ZERO_BD
}
