export const navItems = [
  { label: 'Home', href: '/' },
  { label: 'Tokens', href: '/tokens' },
  { label: 'Network', href: '/network' },
  { label: 'Bridge', href: '/bridge' },
  { label: 'Migration', href: '/migration' },
  { label: 'Validators', href: '/validators' },
  { label: 'Developers', href: '/developers' },
  { label: 'Security', href: '/security' },
  { label: 'Status', href: '/status' },
]

export const coreStats = [
  { label: 'Chain ID', value: '714' },
  { label: 'Core Tokens', value: '2' },
  { label: 'Bridge Paths', value: '3' },
  { label: 'Core Products', value: '4' },
]

export const tokenModel = [
  {
    symbol: 'GILT',
    title: 'Network Token',
    body: 'GILT powers gas, validator economics, governance, inflation, and chain-level rewards.',
  },
  {
    symbol: 'GOLD',
    title: 'Gold Asset Token',
    body: 'GOLD is the main user asset on Gold Chain and the destination model for bridged gold routes.',
  },
]

export const bridgeRoutes = [
  {
    route: 'PAXG Route',
    title: 'PAXG (Ethereum) -> GOLD (Gold Chain)',
    body: 'A PAXG deposit on Ethereum mints GOLD on Gold Chain only after final confirmation.',
    status: 'Live',
  },
  {
    route: 'XAUT Route',
    title: 'XAUT (Ethereum) -> GOLD (Gold Chain)',
    body: 'An XAUT deposit on Ethereum mints GOLD on Gold Chain only after final confirmation.',
    status: 'Live',
  },
  {
    route: 'GILT Route',
    title: 'Wrapped GILT <-> Native GILT',
    body: 'Wrapped GILT from Ethereum converts to native GILT on Gold Chain, and converts back on exit.',
    status: 'Live',
  },
]

export const migrationPhases = [
  {
    phase: '01',
    title: 'Migration Off By Default',
    body: 'Migration remains dormant until governance explicitly activates the lifecycle.',
  },
  {
    phase: '02',
    title: 'Activate Controlled Cutover',
    body: 'Governance moves migration to active state, then enables legacy-to-final conversion.',
  },
  {
    phase: '03',
    title: 'Close Old Bridge Path',
    body: 'Old path is moved to exit-only, then finalized after the cutoff window.',
  },
]

export const validatorRequirements = [
  'Run validator nodes in more than one region',
  'Protect validator keys with hardware or equivalent controls',
  'Monitor uptime, blocks, and signing health 24/7',
  'Maintain clear incident and upgrade runbooks',
]

export const devSurface = [
  { label: 'RPC', value: 'http://vmi3156027.contaboserver.net:8545' },
  { label: 'WS', value: 'ws://vmi3156027.contaboserver.net:8547' },
  { label: 'Chain ID', value: '714' },
  { label: 'Explorer', value: 'giltscan.com' },
]

export const statusRows = [
  { service: 'Chain RPC', state: 'Healthy', latency: '42 ms' },
  { service: 'Bridge Relayer', state: 'Healthy', latency: '58 ms' },
  { service: 'Migration Services', state: 'Healthy', latency: '35 ms' },
  { service: 'Developer Endpoints', state: 'Healthy', latency: '49 ms' },
]
