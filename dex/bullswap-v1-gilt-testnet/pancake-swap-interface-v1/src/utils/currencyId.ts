import { Currency, ETHER, Token } from '@pancakeswap-libs/sdk'

export function currencyId(currency: Currency): string {
  if (currency === ETHER) return 'GILT'
  if (currency instanceof Token) return currency.address
  throw new Error('invalid currency')
}

export default currencyId
