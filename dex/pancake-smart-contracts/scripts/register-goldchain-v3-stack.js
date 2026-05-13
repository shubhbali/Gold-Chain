const fs = require('fs')
const path = require('path')
const crypto = require('crypto')
const { ethers } = require('ethers')

const ROOT = path.resolve(__dirname, '..')
const OUT_FILE = path.resolve(ROOT, '../deployments/goldchain-v3-stack.json')
const CORE_V3_FILE = path.resolve(ROOT, '../deployments/goldchain-v3-core.json')
const ZERO = '0x0000000000000000000000000000000000000000'

function readCoreV3() {
  if (!fs.existsSync(CORE_V3_FILE)) {
    return {}
  }
  return JSON.parse(fs.readFileSync(CORE_V3_FILE, 'utf8'))
}

function requiredAddress(key, fallback) {
  const value = process.env[key] || fallback
  if (!value || value === ZERO || !/^0x[a-fA-F0-9]{40}$/.test(value)) {
    throw new Error(`Missing required v3 address env: ${key}`)
  }
  return value
}

function sha256Hex(input) {
  return `0x${crypto.createHash('sha256').update(input).digest('hex')}`
}

async function signManifestDigest(digestHex) {
  if (!process.env.GOLD_CHAIN_MANIFEST_SIGNER_KEY) {
    return null
  }
  const signer = new ethers.Wallet(process.env.GOLD_CHAIN_MANIFEST_SIGNER_KEY)
  const signature = await signer.signMessage(ethers.utils.arrayify(digestHex))
  return {
    signer: signer.address,
    signature,
    digest: digestHex,
  }
}

async function main() {
  const coreV3 = readCoreV3()
  const coreAddresses = coreV3.addresses || {}
  const resolved = {
    factory: process.env.NEXT_PUBLIC_GOLD_CHAIN_V3_FACTORY ? 'NEXT_PUBLIC_GOLD_CHAIN_V3_FACTORY' : 'core-manifest',
    poolDeployer: process.env.NEXT_PUBLIC_GOLD_CHAIN_V3_POOL_DEPLOYER
      ? 'NEXT_PUBLIC_GOLD_CHAIN_V3_POOL_DEPLOYER'
      : 'core-manifest',
    nftPositionManager: process.env.NEXT_PUBLIC_GOLD_CHAIN_V3_NFT_POSITION_MANAGER
      ? 'NEXT_PUBLIC_GOLD_CHAIN_V3_NFT_POSITION_MANAGER'
      : 'core-manifest',
    quoter: process.env.NEXT_PUBLIC_GOLD_CHAIN_V3_QUOTER ? 'NEXT_PUBLIC_GOLD_CHAIN_V3_QUOTER' : 'core-manifest',
    migrator: process.env.NEXT_PUBLIC_GOLD_CHAIN_V3_MIGRATOR ? 'NEXT_PUBLIC_GOLD_CHAIN_V3_MIGRATOR' : 'core-manifest',
    swapRouter:
      process.env.NEXT_PUBLIC_GOLD_CHAIN_V3_SWAP_ROUTER ||
      process.env.NEXT_PUBLIC_GOLD_CHAIN_SMART_ROUTER_ADDRESS
        ? process.env.NEXT_PUBLIC_GOLD_CHAIN_V3_SWAP_ROUTER
          ? 'NEXT_PUBLIC_GOLD_CHAIN_V3_SWAP_ROUTER'
          : 'NEXT_PUBLIC_GOLD_CHAIN_SMART_ROUTER_ADDRESS'
        : 'core-manifest',
    masterChefV3: process.env.NEXT_PUBLIC_GOLD_CHAIN_MASTERCHEF_V3_ADDRESS
      ? 'NEXT_PUBLIC_GOLD_CHAIN_MASTERCHEF_V3_ADDRESS'
      : 'core-manifest',
    positionDescriptor: process.env.NEXT_PUBLIC_GOLD_CHAIN_V3_POSITION_DESCRIPTOR
      ? 'NEXT_PUBLIC_GOLD_CHAIN_V3_POSITION_DESCRIPTOR'
      : 'core-manifest',
  }

  const manifest = {
    manifestVersion: 'goldchain.dex.v3.stack.v1',
    target: process.env.GOLD_CHAIN_DEPLOY_TARGET || 'testnet',
    chainId: Number(process.env.GOLD_CHAIN_CHAIN_ID || coreV3.chainId || '714'),
    addresses: {
      factory: requiredAddress('NEXT_PUBLIC_GOLD_CHAIN_V3_FACTORY', coreAddresses.factory),
      poolDeployer: requiredAddress('NEXT_PUBLIC_GOLD_CHAIN_V3_POOL_DEPLOYER', coreAddresses.poolDeployer),
      nftPositionManager: requiredAddress(
        'NEXT_PUBLIC_GOLD_CHAIN_V3_NFT_POSITION_MANAGER',
        coreAddresses.nftPositionManager,
      ),
      quoter: requiredAddress('NEXT_PUBLIC_GOLD_CHAIN_V3_QUOTER', coreAddresses.quoter),
      migrator: requiredAddress('NEXT_PUBLIC_GOLD_CHAIN_V3_MIGRATOR', coreAddresses.migrator),
      swapRouter: requiredAddress(
        'NEXT_PUBLIC_GOLD_CHAIN_V3_SWAP_ROUTER',
        process.env.NEXT_PUBLIC_GOLD_CHAIN_SMART_ROUTER_ADDRESS || coreAddresses.swapRouter,
      ),
      masterChefV3: requiredAddress('NEXT_PUBLIC_GOLD_CHAIN_MASTERCHEF_V3_ADDRESS', coreAddresses.masterChefV3),
      positionDescriptor: requiredAddress(
        'NEXT_PUBLIC_GOLD_CHAIN_V3_POSITION_DESCRIPTOR',
        coreAddresses.positionDescriptor,
      ),
    },
    resolution: resolved,
    sourceManifest: fs.existsSync(CORE_V3_FILE) ? CORE_V3_FILE : null,
    generatedAt: new Date().toISOString(),
  }

  const digest = sha256Hex(JSON.stringify(manifest, null, 2))
  manifest.manifestDigest = digest
  const signature = await signManifestDigest(digest)
  if (signature) {
    manifest.manifestSignature = signature
  }

  fs.mkdirSync(path.dirname(OUT_FILE), { recursive: true })
  fs.writeFileSync(OUT_FILE, `${JSON.stringify(manifest, null, 2)}\n`)
  console.error(JSON.stringify(manifest, null, 2))
}

main().catch((error) => {
  console.error(error)
  process.exit(1)
})
