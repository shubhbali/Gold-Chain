const fs = require('fs')
const path = require('path')
const crypto = require('crypto')
const { ethers } = require('ethers')

const ROOT = path.resolve(__dirname, '..')
const DEPLOYMENTS_DIR = path.resolve(ROOT, '../deployments')
const CORE_DEPLOYMENT_FILE = path.resolve(DEPLOYMENTS_DIR, 'goldchain-roughnet.json')
const OUT_FILE = path.resolve(DEPLOYMENTS_DIR, 'goldchain-v3-core.json')
const WALLET_FILE = path.resolve(ROOT, '../../.roughnet-wallets/evm-wallets.json')
const V3_ARTIFACTS_DIR = path.resolve(
  ROOT,
  process.env.GOLD_CHAIN_V3_ARTIFACTS_DIR || 'deployments/v3-artifacts',
)
const LEGACY_V3_ARTIFACTS_DIR = path.resolve(ROOT, 'projects/vecake-farm-booster/v3/test/artifactsFile')

const ZERO_ADDRESS = '0x0000000000000000000000000000000000000000'
const ADDRESS_REGEX = /^0x[a-fA-F0-9]{40}$/

const provider = new ethers.providers.JsonRpcProvider(process.env.GOLD_CHAIN_RPC_URL || 'http://127.0.0.1:8545')

function sha256Hex(input) {
  return `0x${crypto.createHash('sha256').update(input).digest('hex')}`
}

function readJson(filePath) {
  if (!fs.existsSync(filePath)) {
    throw new Error(`Required file does not exist: ${filePath}`)
  }
  return JSON.parse(fs.readFileSync(filePath, 'utf8'))
}

function resolveArtifactsDir() {
  if (fs.existsSync(V3_ARTIFACTS_DIR)) {
    return V3_ARTIFACTS_DIR
  }
  if (process.env.GOLD_CHAIN_ALLOW_LEGACY_V3_ARTIFACTS === 'true' && fs.existsSync(LEGACY_V3_ARTIFACTS_DIR)) {
    console.error(`[goldchain-v3] warning: using legacy artifacts directory ${LEGACY_V3_ARTIFACTS_DIR}`)
    return LEGACY_V3_ARTIFACTS_DIR
  }
  throw new Error(
    [
      `Missing V3 deployment artifacts directory: ${V3_ARTIFACTS_DIR}`,
      'Run scripts/prepare-goldchain-v3-artifacts.js or set GOLD_CHAIN_V3_ARTIFACTS_DIR.',
    ].join(' '),
  )
}

function loadArtifact(name) {
  const artifactPath = path.resolve(resolveArtifactsDir(), `${name}.json`)
  const artifact = readJson(artifactPath)
  if (!artifact.abi || !artifact.bytecode) {
    throw new Error(`Artifact is missing abi/bytecode: ${artifactPath}`)
  }
  return artifact
}

function requireAddress(value, label) {
  if (!value || !ADDRESS_REGEX.test(value)) {
    throw new Error(`Missing or invalid ${label}: ${value || 'empty'}`)
  }
  return value
}

function optionalAddress(value) {
  if (!value) {
    return null
  }
  return ADDRESS_REGEX.test(value) ? value : null
}

function resolveExplicitAddress(label, keys, fallback = null) {
  for (const key of keys) {
    const value = optionalAddress(process.env[key])
    if (value) {
      return {
        address: value,
        source: key,
      }
    }
  }
  if (fallback && ADDRESS_REGEX.test(fallback)) {
    return {
      address: fallback,
      source: 'core-manifest',
    }
  }
  throw new Error(`Missing ${label}. Set one of: ${keys.join(', ')}`)
}

function getWallet() {
  const wallets = readJson(WALLET_FILE)
  if (!Array.isArray(wallets) || wallets.length === 0) {
    throw new Error(`No wallets found in ${WALLET_FILE}`)
  }
  return new ethers.Wallet(process.env.GOLD_CHAIN_DEPLOYER_KEY || wallets[0].private_key, provider)
}

function readCoreDeployment() {
  if (!fs.existsSync(CORE_DEPLOYMENT_FILE)) {
    return {}
  }
  return readJson(CORE_DEPLOYMENT_FILE)
}

function resolveAddress(candidates, label) {
  for (const value of candidates) {
    if (value && ADDRESS_REGEX.test(value)) {
      return value
    }
  }
  throw new Error(`Missing ${label}`)
}

async function deployArtifact(name, signer, args = []) {
  const artifact = loadArtifact(name)
  const factory = new ethers.ContractFactory(artifact.abi, artifact.bytecode, signer)
  const contract = await factory.deploy(...args)
  await contract.deployTransaction.wait()
  return { contract, artifact }
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
  const deployer = getWallet()
  const chain = await provider.getNetwork()
  if (chain.chainId !== 714) {
    throw new Error(`Expected Gold Chain 714, got ${chain.chainId}`)
  }

  const core = readCoreDeployment()
  const target = process.env.GOLD_CHAIN_DEPLOY_TARGET || 'testnet'
  const requireDescriptor = target === 'mainnet' || process.env.GOLD_CHAIN_REQUIRE_V3_DESCRIPTOR !== 'false'

  const wgiltAddress = resolveAddress(
    [process.env.GOLD_CHAIN_WGILT_ADDRESS, process.env.NEXT_PUBLIC_GOLD_CHAIN_WGILT_ADDRESS, core.wgilt],
    'WGILT address (GOLD_CHAIN_WGILT_ADDRESS or NEXT_PUBLIC_GOLD_CHAIN_WGILT_ADDRESS or core deployment)',
  )
  const dexTokenAddress = resolveAddress(
    [process.env.GOLD_CHAIN_DEX_ADDRESS, process.env.NEXT_PUBLIC_GOLD_CHAIN_DEX_ADDRESS, core.dex],
    'DEX token address (GOLD_CHAIN_DEX_ADDRESS or NEXT_PUBLIC_GOLD_CHAIN_DEX_ADDRESS or core deployment)',
  )

  const coreAddresses = core.v3 || {}
  const descriptorResolution = resolveExplicitAddress(
    'NonfungiblePositionDescriptor address',
    ['GOLD_CHAIN_V3_POSITION_DESCRIPTOR', 'NEXT_PUBLIC_GOLD_CHAIN_V3_POSITION_DESCRIPTOR'],
    coreAddresses.positionDescriptor,
  )
  const descriptorAddress = descriptorResolution.address
  if (requireDescriptor) {
    requireAddress(descriptorAddress, 'NonfungiblePositionDescriptor address')
  }

  const quoterResolution = resolveExplicitAddress(
    'V3 Quoter address',
    ['GOLD_CHAIN_V3_QUOTER', 'NEXT_PUBLIC_GOLD_CHAIN_V3_QUOTER'],
    coreAddresses.quoter,
  )
  const quoterAddress = quoterResolution.address

  const migratorResolution = resolveExplicitAddress(
    'V3 Migrator address',
    ['GOLD_CHAIN_V3_MIGRATOR', 'NEXT_PUBLIC_GOLD_CHAIN_V3_MIGRATOR'],
    coreAddresses.migrator,
  )
  const migratorAddress = migratorResolution.address

  const masterChefReceiver = optionalAddress(process.env.GOLD_CHAIN_MASTERCHEF_V3_RECEIVER) || ZERO_ADDRESS

  console.error('[goldchain-v3] deploying pool deployer')
  const poolDeployer = await deployArtifact('PancakeV3PoolDeployer', deployer)

  console.error('[goldchain-v3] deploying factory')
  const factory = await deployArtifact('PancakeV3Factory', deployer, [poolDeployer.contract.address])
  await (await poolDeployer.contract.setFactoryAddress(factory.contract.address)).wait()

  console.error('[goldchain-v3] deploying swap router')
  const swapRouter = await deployArtifact('SwapRouter', deployer, [
    poolDeployer.contract.address,
    factory.contract.address,
    wgiltAddress,
  ])

  console.error('[goldchain-v3] deploying NFT position manager')
  const positionManager = await deployArtifact('NonfungiblePositionManager', deployer, [
    poolDeployer.contract.address,
    factory.contract.address,
    wgiltAddress,
    descriptorAddress,
  ])

  console.error('[goldchain-v3] deploying MasterChefV3')
  const masterChefV3 = await deployArtifact('MasterChefV3', deployer, [
    dexTokenAddress,
    positionManager.contract.address,
    masterChefReceiver,
  ])

  console.error('[goldchain-v3] deploying LM pool deployer')
  const lmPoolDeployer = await deployArtifact('PancakeV3LmPoolDeployer', deployer, [masterChefV3.contract.address])
  await (await factory.contract.setLmPoolDeployer(lmPoolDeployer.contract.address)).wait()
  await (await masterChefV3.contract.setLMPoolDeployer(lmPoolDeployer.contract.address)).wait()

  const manifest = {
    manifestVersion: 'goldchain.dex.v3.core.v1',
    target,
    chainId: chain.chainId,
    deployer: deployer.address,
    rpcUrl: provider.connection.url,
    coreDeploymentFile: fs.existsSync(CORE_DEPLOYMENT_FILE) ? CORE_DEPLOYMENT_FILE : null,
    addresses: {
      poolDeployer: poolDeployer.contract.address,
      factory: factory.contract.address,
      swapRouter: swapRouter.contract.address,
      nftPositionManager: positionManager.contract.address,
      masterChefV3: masterChefV3.contract.address,
      lmPoolDeployer: lmPoolDeployer.contract.address,
      quoter: quoterAddress,
      migrator: migratorAddress,
      positionDescriptor: descriptorAddress,
      wgilt: wgiltAddress,
      dexToken: dexTokenAddress,
      masterChefReceiver,
    },
    resolution: {
      descriptor: descriptorResolution,
      quoter: quoterResolution,
      migrator: migratorResolution,
    },
    bytecodeHashes: {
      poolDeployer: ethers.utils.keccak256(poolDeployer.artifact.bytecode),
      factory: ethers.utils.keccak256(factory.artifact.bytecode),
      swapRouter: ethers.utils.keccak256(swapRouter.artifact.bytecode),
      nftPositionManager: ethers.utils.keccak256(positionManager.artifact.bytecode),
      masterChefV3: ethers.utils.keccak256(masterChefV3.artifact.bytecode),
      lmPoolDeployer: ethers.utils.keccak256(lmPoolDeployer.artifact.bytecode),
    },
    artifactsDirectory: resolveArtifactsDir(),
    createdAt: new Date().toISOString(),
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
