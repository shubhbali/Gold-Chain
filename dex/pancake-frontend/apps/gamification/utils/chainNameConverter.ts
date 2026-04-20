import { gilt, linea } from 'wagmi/chains'

export const chainNameConverter = (name: string) => {
  switch (name) {
    case gilt.name:
      return 'GILT Chain'
    case linea.name:
      return 'Linea'
    default:
      return name
  }
}
