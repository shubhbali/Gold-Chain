const fs = require('fs')
const path = require('path')

const ROOT = path.resolve(__dirname, '..')
const templatePath = path.resolve(ROOT, 'subgraph.goldchain.template.yaml')
const outputPath = path.resolve(ROOT, 'subgraph.goldchain.yaml')
const pricingConfigPath = path.resolve(ROOT, 'src/mappings/goldchainPricingConfig.ts')
const defaultDeploymentManifest = path.resolve(ROOT, '../deployments/goldchain-roughnet.json')

const ZERO_ADDRESS = '0x0000000000000000000000000000000000000000'

function isAddress(value) {
  return /^0x[a-fA-F0-9]{40}$/.test(value)
}

function normalizeAddress(value) {
  return value.toLowerCase()
}

function readJsonIfExists(filePath) {
  if (!fs.existsSync(filePath)) {
    return null
  }
  return JSON.parse(fs.readFileSync(filePath, 'utf8'))
}

function requiredAddress(label, candidates) {
  for (const candidate of candidates) {
    if (candidate && isAddress(candidate)) {
      return normalizeAddress(candidate)
    }
  }
  throw new Error(`Missing required ${label}`)
}

function optionalAddress(candidates) {
  for (const candidate of candidates) {
    if (candidate && isAddress(candidate)) {
      return normalizeAddress(candidate)
    }
  }
  return null
}

function parseAddressList(value) {
  if (!value) {
    return []
  }
  return value
    .split(',')
    .map((entry) => entry.trim())
    .filter((entry) => isAddress(entry))
    .map((entry) => normalizeAddress(entry))
}

function uniqueNonZero(addresses) {
  return [...new Set(addresses.map((entry) => normalizeAddress(entry)).filter((entry) => entry !== ZERO_ADDRESS))]
}

function main() {
  const network = process.env.GOLD_CHAIN_SUBGRAPH_NETWORK || 'goldchain'
  const deploymentManifestPath = process.env.GOLD_CHAIN_DEPLOYMENT_MANIFEST || defaultDeploymentManifest
  const deployment = readJsonIfExists(deploymentManifestPath) || {}

  const factoryAddress = requiredAddress('factory address', [
    process.env.GOLD_CHAIN_FACTORY_ADDRESS,
    process.env.NEXT_PUBLIC_GOLD_CHAIN_FACTORY_ADDRESS,
    deployment.factory,
  ])

  const startBlock = process.env.GOLD_CHAIN_FACTORY_START_BLOCK || deployment.startBlock
  if (!startBlock) {
    throw new Error('Missing required factory start block (GOLD_CHAIN_FACTORY_START_BLOCK or deployment manifest startBlock)')
  }

  const wgiltAddress = requiredAddress('WGILT address', [
    process.env.GOLD_CHAIN_WGILT_ADDRESS,
    process.env.NEXT_PUBLIC_GOLD_CHAIN_WGILT_ADDRESS,
    deployment.wgilt,
  ])
  const usdtAddress = optionalAddress([
    process.env.GOLD_CHAIN_USDT_ADDRESS,
    process.env.NEXT_PUBLIC_GOLD_CHAIN_USDT_ADDRESS,
    deployment.usdt,
  ])
  const usdcAddress = optionalAddress([process.env.GOLD_CHAIN_USDC_ADDRESS, process.env.NEXT_PUBLIC_GOLD_CHAIN_USDC_ADDRESS])
  const quoteTokenAddresses = uniqueNonZero([
    ...parseAddressList(process.env.GOLD_CHAIN_QUOTE_TOKEN_ADDRESSES),
    ...(usdtAddress ? [usdtAddress] : []),
    ...(usdcAddress ? [usdcAddress] : []),
  ])

  const routeTokenAddresses = uniqueNonZero([
    ...parseAddressList(process.env.GOLD_CHAIN_ROUTE_TOKEN_ADDRESSES),
    ...[process.env.NEXT_PUBLIC_GOLD_CHAIN_GOLD_PAXG_ADDRESS, process.env.NEXT_PUBLIC_GOLD_CHAIN_GOLD_XAUT_ADDRESS].filter(
      Boolean,
    ),
    ...[deployment.goldPaxg, deployment.goldXaut].filter(Boolean),
  ])

  const template = fs.readFileSync(templatePath, 'utf8')
  const rendered = template
    .replaceAll('{{network}}', network)
    .replaceAll('{{factoryAddress}}', factoryAddress)
    .replaceAll('{{startBlock}}', startBlock)

  fs.writeFileSync(outputPath, rendered)

  const configSource = [
    `export const WGILT_ADDRESS = '${wgiltAddress}'`,
    '',
    `export const QUOTE_TOKEN_ADDRESSES: string[] = [${quoteTokenAddresses.map((token) => `'${token}'`).join(', ')}]`,
    '',
    `export const ROUTE_TOKEN_ADDRESSES: string[] = [${routeTokenAddresses.map((token) => `'${token}'`).join(', ')}]`,
    '',
  ].join('\n')
  fs.writeFileSync(pricingConfigPath, configSource)

  console.log(`Rendered ${outputPath}`)
  console.log(`Rendered ${pricingConfigPath}`)
}

main()
