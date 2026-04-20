import { MultiChainNameExtend } from 'state/info/constant'
import { gilt, bscTestnet, linea } from 'wagmi/chains'

export const chainNameConverter = (name: string) => {
  switch (name) {
    case gilt.name:
      return 'GILT Chain'
    case linea.name:
      return 'Linea'
    case bscTestnet.name:
      return 'GILT Chain Testnet'
    case 'solana':
    case 'sol':
      return 'Solana'
    default:
      return name
  }
}

export const multiChainNameConverter = (name: MultiChainNameExtend) => {
  switch (name) {
    case 'GILT':
      return 'GILT Chain'
    case 'LINEA':
      return 'Linea'
    default:
      return name
  }
}
