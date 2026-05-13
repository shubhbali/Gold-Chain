const fs = require('fs')
const path = require('path')
const crypto = require('crypto')
const { spawnSync } = require('child_process')
const { ethers } = require('ethers')

const ROOT = path.resolve(__dirname, '..')
const DEPLOYMENTS_DIR = path.resolve(ROOT, '../deployments')
const CORE_DEPLOYMENT_FILE = path.resolve(DEPLOYMENTS_DIR, 'goldchain-roughnet.json')
const V3_CORE_FILE = path.resolve(DEPLOYMENTS_DIR, 'goldchain-v3-core.json')
const V3_STACK_FILE = path.resolve(DEPLOYMENTS_DIR, 'goldchain-v3-stack.json')
const LAUNCH_MANIFEST_FILE = path.resolve(DEPLOYMENTS_DIR, 'goldchain-launch-manifest.json')
const MANIFEST_SCHEMA_FILE = path.resolve(DEPLOYMENTS_DIR, 'schemas/goldchain-dex-manifest.schema.json')
const FRONTEND_ENV_FILE = path.resolve(ROOT, '../pancake-frontend/apps/web/.env.local')
const WALLET_FILE = path.resolve(ROOT, '../../.roughnet-wallets/evm-wallets.json')

const ZERO_ADDRESS = '0x0000000000000000000000000000000000000000'
const ADDRESS_REGEX = /^0x[a-fA-F0-9]{40}$/
const FRONTEND_REQUIRED_GOLD_CHAIN_ADDRESS_KEYS = [
  'NEXT_PUBLIC_GOLD_CHAIN_MASTERCHEF_ADDRESS',
  'NEXT_PUBLIC_GOLD_CHAIN_MASTERCHEF_V3_ADDRESS',
  'NEXT_PUBLIC_GOLD_CHAIN_LOTTERY_ADDRESS',
  'NEXT_PUBLIC_GOLD_CHAIN_STABLE_SWAP_NATIVE_HELPER',
  'NEXT_PUBLIC_GOLD_CHAIN_V3_NFT_POSITION_MANAGER',
  'NEXT_PUBLIC_GOLD_CHAIN_V3_POOL_DEPLOYER',
  'NEXT_PUBLIC_GOLD_CHAIN_V3_MIGRATOR',
  'NEXT_PUBLIC_GOLD_CHAIN_V3_QUOTER',
  'NEXT_PUBLIC_GOLD_CHAIN_VCAKE_ADDRESS',
  'NEXT_PUBLIC_GOLD_CHAIN_REVENUE_SHARING_POOL',
  'NEXT_PUBLIC_GOLD_CHAIN_VECAKE_ADDRESS',
  'NEXT_PUBLIC_GOLD_CHAIN_REVENUE_SHARING_VECAKE',
  'NEXT_PUBLIC_GOLD_CHAIN_REVENUE_SHARING_CAKE_POOL',
  'NEXT_PUBLIC_GOLD_CHAIN_REVENUE_SHARING_POOL_GATEWAY',
]
const OWNERSHIP_ABI = [
  'function owner() view returns (address)',
  'function transferOwnership(address newOwner)',
  'function setOwner(address newOwner)',
]

function sha256Hex(input) {
  return `0x${crypto.createHash('sha256').update(input).digest('hex')}`
}

function isAddress(value) {
  return Boolean(value) && ADDRESS_REGEX.test(value)
}

function readJson(filePath) {
  if (!fs.existsSync(filePath)) {
    throw new Error(`Required file does not exist: ${filePath}`)
  }
  return JSON.parse(fs.readFileSync(filePath, 'utf8'))
}

function requireEnvAddress(env, key) {
  const value = env[key]
  if (!isAddress(value)) {
    throw new Error(`Missing required address env: ${key}`)
  }
  return value
}

function safeAddress(value) {
  return isAddress(value) ? value : null
}

function parseAddressFromRegex(logs, pattern, label) {
  const match = logs.match(pattern)
  if (!match || !isAddress(match[1])) {
    throw new Error(`Unable to parse ${label} from logs`)
  }
  return match[1]
}

function parseOptionalAddressFromRegex(logs, pattern) {
  const match = logs.match(pattern)
  if (!match || !isAddress(match[1])) {
    return null
  }
  return match[1]
}

function collectAddressValues(payload, out = []) {
  if (typeof payload === 'string') {
    if (isAddress(payload)) {
      out.push(payload)
    }
    return out
  }
  if (Array.isArray(payload)) {
    for (const item of payload) {
      collectAddressValues(item, out)
    }
    return out
  }
  if (payload && typeof payload === 'object') {
    for (const value of Object.values(payload)) {
      collectAddressValues(value, out)
    }
  }
  return out
}

function resolveDeployerKey(env) {
  if (env.KEY_GOLDCHAIN) {
    return env.KEY_GOLDCHAIN
  }
  if (env.GOLD_CHAIN_DEPLOYER_KEY) {
    return env.GOLD_CHAIN_DEPLOYER_KEY
  }
  const wallets = readJson(WALLET_FILE)
  if (!Array.isArray(wallets) || wallets.length === 0 || !wallets[0].private_key) {
    throw new Error(`Unable to resolve deployer key from ${WALLET_FILE}`)
  }
  return wallets[0].private_key
}

function runCommand(step, env) {
  const result = spawnSync(step.command, {
    cwd: step.cwd,
    shell: true,
    encoding: 'utf8',
    env,
  })
  const stdout = result.stdout || ''
  const stderr = result.stderr || ''
  const combinedOutput = `${stdout}\n${stderr}`.trim()
  if (result.status !== 0) {
    throw new Error(`Step failed (${step.name}): ${combinedOutput}`)
  }
  return combinedOutput
}

async function waitTx(txPromise) {
  const tx = await txPromise
  await tx.wait()
  return tx
}

async function enforceGovernanceHandoff(stepName, addresses, signer, governanceOwner, options = {}) {
  const { strictOwner = true } = options
  const results = []
  const unique = [...new Set(addresses.filter((addr) => isAddress(addr) && addr !== ZERO_ADDRESS))]
  const governanceLower = governanceOwner.toLowerCase()
  const deployerLower = signer.address.toLowerCase()

  for (const address of unique) {
    const contract = new ethers.Contract(address, OWNERSHIP_ABI, signer)
    let owner
    try {
      owner = await contract.owner()
    } catch (_error) {
      results.push({ address, status: 'non-ownable' })
      continue
    }

    if (!isAddress(owner)) {
      throw new Error(`[${stepName}] ownership check failed for ${address}: invalid owner value ${owner}`)
    }

    const ownerLower = owner.toLowerCase()
    if (ownerLower === governanceLower) {
      results.push({ address, status: 'already-governance' })
      continue
    }

    if (ownerLower !== deployerLower) {
      if (strictOwner) {
        throw new Error(`[${stepName}] cannot hand off ${address}; current owner is ${owner}`)
      }
      results.push({ address, status: 'external-owner', owner })
      continue
    }

    let methodUsed = null
    try {
      await waitTx(contract.transferOwnership(governanceOwner))
      methodUsed = 'transferOwnership'
    } catch (_error) {
      await waitTx(contract.setOwner(governanceOwner))
      methodUsed = 'setOwner'
    }

    const finalOwner = await contract.owner()
    if (!isAddress(finalOwner) || finalOwner.toLowerCase() !== governanceLower) {
      throw new Error(`[${stepName}] ownership handoff verification failed for ${address}`)
    }
    results.push({ address, status: 'transferred', method: methodUsed })
  }
  return results
}

function captureCoreStep(env) {
  const core = readJson(CORE_DEPLOYMENT_FILE)
  const outputs = {
    multicall3: safeAddress(core.multicall3),
    factory: safeAddress(core.factory),
    router: safeAddress(core.router),
    wgilt: safeAddress(core.wgilt),
    wgoldWrapper: safeAddress(core.wgoldWrapper),
    goldPaxg: safeAddress(core.goldPaxg),
    goldXaut: safeAddress(core.goldXaut),
    dex: safeAddress(core.dex),
    masterChef: safeAddress(core.masterChef),
    usdt: safeAddress(core.usdt),
  }

  const envUpdates = {}
  if (outputs.multicall3) {
    envUpdates.NEXT_PUBLIC_GOLD_CHAIN_MULTICALL3_ADDRESS = outputs.multicall3
    envUpdates.NEXT_PUBLIC_GOLD_CHAIN_MULTICALL_ADDRESS = outputs.multicall3
  }
  if (outputs.factory) {
    envUpdates.NEXT_PUBLIC_GOLD_CHAIN_FACTORY_ADDRESS = outputs.factory
    envUpdates.GOLD_CHAIN_FACTORY_ADDRESS = outputs.factory
  }
  if (outputs.router) {
    envUpdates.NEXT_PUBLIC_GOLD_CHAIN_ROUTER_ADDRESS = outputs.router
  }
  if (outputs.wgilt) {
    envUpdates.NEXT_PUBLIC_GOLD_CHAIN_WGILT_ADDRESS = outputs.wgilt
    envUpdates.GOLD_CHAIN_WGILT_ADDRESS = outputs.wgilt
  }
  if (outputs.wgoldWrapper) {
    envUpdates.NEXT_PUBLIC_GOLD_CHAIN_WGOLD_WRAPPER_ADDRESS = outputs.wgoldWrapper
  }
  if (outputs.goldPaxg) {
    envUpdates.NEXT_PUBLIC_GOLD_CHAIN_GOLD_PAXG_ADDRESS = outputs.goldPaxg
  }
  if (outputs.goldXaut) {
    envUpdates.NEXT_PUBLIC_GOLD_CHAIN_GOLD_XAUT_ADDRESS = outputs.goldXaut
  }
  if (outputs.dex) {
    envUpdates.NEXT_PUBLIC_GOLD_CHAIN_DEX_ADDRESS = outputs.dex
    envUpdates.GOLD_CHAIN_DEX_ADDRESS = outputs.dex
  }
  if (outputs.masterChef) {
    envUpdates.NEXT_PUBLIC_GOLD_CHAIN_MASTERCHEF_ADDRESS = outputs.masterChef
  }
  if (outputs.usdt) {
    envUpdates.NEXT_PUBLIC_GOLD_CHAIN_USDT_ADDRESS = outputs.usdt
    envUpdates.GOLD_CHAIN_USDT_ADDRESS = outputs.usdt
  }

  envUpdates.GOLD_CHAIN_DEPLOYMENT_MANIFEST = CORE_DEPLOYMENT_FILE
  if (core.startBlock) {
    envUpdates.GOLD_CHAIN_FACTORY_START_BLOCK = String(core.startBlock)
  }
  if (!env.NEXT_PUBLIC_GOLD_CHAIN_SMART_ROUTER_ADDRESS && outputs.router) {
    envUpdates.NEXT_PUBLIC_GOLD_CHAIN_SMART_ROUTER_ADDRESS = outputs.router
  }

  return {
    outputs,
    envUpdates,
    governanceTargets: [outputs.masterChef, outputs.factory].filter(Boolean),
  }
}

function captureV3CoreStep() {
  const v3 = readJson(V3_CORE_FILE)
  const addresses = v3.addresses || {}
  const outputs = {
    factory: safeAddress(addresses.factory),
    poolDeployer: safeAddress(addresses.poolDeployer),
    swapRouter: safeAddress(addresses.swapRouter),
    nftPositionManager: safeAddress(addresses.nftPositionManager),
    masterChefV3: safeAddress(addresses.masterChefV3),
    lmPoolDeployer: safeAddress(addresses.lmPoolDeployer),
    quoter: safeAddress(addresses.quoter),
    migrator: safeAddress(addresses.migrator),
    positionDescriptor: safeAddress(addresses.positionDescriptor),
  }

  if (!outputs.quoter || !outputs.migrator || !outputs.positionDescriptor) {
    throw new Error('V3 core manifest must include explicit quoter, migrator, and descriptor addresses')
  }

  const envUpdates = {
    NEXT_PUBLIC_GOLD_CHAIN_V3_FACTORY: outputs.factory,
    NEXT_PUBLIC_GOLD_CHAIN_V3_POOL_DEPLOYER: outputs.poolDeployer,
    NEXT_PUBLIC_GOLD_CHAIN_V3_NFT_POSITION_MANAGER: outputs.nftPositionManager,
    NEXT_PUBLIC_GOLD_CHAIN_MASTERCHEF_V3_ADDRESS: outputs.masterChefV3,
    NEXT_PUBLIC_GOLD_CHAIN_V3_QUOTER: outputs.quoter,
    NEXT_PUBLIC_GOLD_CHAIN_V3_MIGRATOR: outputs.migrator,
    NEXT_PUBLIC_GOLD_CHAIN_V3_POSITION_DESCRIPTOR: outputs.positionDescriptor,
    NEXT_PUBLIC_GOLD_CHAIN_V3_SWAP_ROUTER: outputs.swapRouter,
    NEXT_PUBLIC_GOLD_CHAIN_SMART_ROUTER_ADDRESS: outputs.swapRouter,
  }

  return {
    outputs,
    envUpdates,
    governanceTargets: collectAddressValues({
      factory: outputs.factory,
      masterChefV3: outputs.masterChefV3,
    }),
  }
}

function captureV3StackStep() {
  const manifest = readJson(V3_STACK_FILE)
  return {
    outputs: manifest.addresses || {},
    envUpdates: {},
    governanceTargets: [],
  }
}

function captureSingleAddress(logs, key, pattern, envPairs = []) {
  const value = parseAddressFromRegex(logs, pattern, key)
  const envUpdates = {}
  for (const envKey of envPairs) {
    envUpdates[envKey] = value
  }
  return {
    outputs: { [key]: value },
    envUpdates,
    governanceTargets: [value],
  }
}

function captureLottery(logs) {
  const rng = parseOptionalAddressFromRegex(logs, /RandomNumberGenerator deployed to:\s*(0x[a-fA-F0-9]{40})/i)
  const lottery = parseAddressFromRegex(logs, /PancakeSwapLottery deployed to:\s*(0x[a-fA-F0-9]{40})/i, 'lottery')
  const outputs = {
    randomNumberGenerator: rng,
    lottery,
  }
  return {
    outputs,
    envUpdates: {
      NEXT_PUBLIC_GOLD_CHAIN_LOTTERY_ADDRESS: lottery,
      ...(rng ? { GOLD_CHAIN_RANDOM_NUMBER_GENERATOR: rng } : {}),
    },
    governanceTargets: collectAddressValues(outputs),
  }
}

function captureVoter(logs) {
  const gaugeVoting = parseAddressFromRegex(logs, /GaugeVoting deployed to:\s*(0x[a-fA-F0-9]{40})/i, 'GaugeVoting')
  const gaugeVotingAdminUtil = parseAddressFromRegex(
    logs,
    /GaugeVotingAdminUtil deployed to:\s*(0x[a-fA-F0-9]{40})/i,
    'GaugeVotingAdminUtil',
  )
  const gaugeVotingCalc = parseAddressFromRegex(logs, /GaugeVotingCalc deployed to:\s*(0x[a-fA-F0-9]{40})/i, 'GaugeVotingCalc')

  return {
    outputs: {
      gaugeVoting,
      gaugeVotingAdminUtil,
      gaugeVotingCalc,
    },
    envUpdates: {
      NEXT_PUBLIC_GOLD_CHAIN_GAUGE_VOTING: gaugeVoting,
      NEXT_PUBLIC_GOLD_CHAIN_GAUGE_VOTING_ADMIN_UTIL: gaugeVotingAdminUtil,
      NEXT_PUBLIC_GOLD_CHAIN_GAUGE_VOTING_CALC: gaugeVotingCalc,
    },
    governanceTargets: [gaugeVoting],
  }
}

function mergeEnv(base, updates) {
  for (const [key, value] of Object.entries(updates)) {
    if (value === null || value === undefined || value === '') {
      continue
    }
    base[key] = String(value)
  }
}

function filteredGoldChainEnv(env) {
  return Object.fromEntries(
    Object.entries(env)
      .filter(([key]) => key.startsWith('GOLD_CHAIN_') || key.startsWith('NEXT_PUBLIC_GOLD_CHAIN_') || key === 'KEY_GOLDCHAIN')
      .sort(([a], [b]) => (a < b ? -1 : a > b ? 1 : 0)),
  )
}

function assertFrontendGoldChainAddressEnv(env) {
  for (const key of FRONTEND_REQUIRED_GOLD_CHAIN_ADDRESS_KEYS) {
    if (!isAddress(env[key])) {
      throw new Error(`[goldchain-launch] Missing required frontend Gold Chain address: ${key}`)
    }
  }
}

function writeFrontendEnv(env) {
  const lines = Object.entries(env)
    .filter(([key, value]) => key.startsWith('NEXT_PUBLIC_GOLD_CHAIN_') && value !== undefined && value !== null)
    .sort(([a], [b]) => (a < b ? -1 : a > b ? 1 : 0))
    .map(([key, value]) => `${key}=${value}`)
  fs.writeFileSync(FRONTEND_ENV_FILE, `${lines.join('\n')}\n`)
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
  const target = process.env.GOLD_CHAIN_DEPLOY_TARGET || 'testnet'
  const network = process.env.GOLD_CHAIN_DEPLOY_NETWORK || 'goldchain'
  const rpcUrl = process.env.GOLD_CHAIN_RPC_URL || process.env.NEXT_PUBLIC_GOLD_CHAIN_RPC || 'http://127.0.0.1:8545'

  const deploymentEnv = {
    ...process.env,
    GOLD_CHAIN_STRICT_CONFIG: 'true',
    GOLD_CHAIN_DEPLOY_NETWORK: network,
    GOLD_CHAIN_DEPLOY_TARGET: target,
    GOLD_CHAIN_ENFORCE_GOVERNANCE: 'true',
    GOLD_CHAIN_RPC_URL: rpcUrl,
    NEXT_PUBLIC_GOLD_CHAIN_RPC: process.env.NEXT_PUBLIC_GOLD_CHAIN_RPC || rpcUrl,
  }

  const governanceOwner = requireEnvAddress(deploymentEnv, 'GOLD_CHAIN_GOVERNANCE_OWNER')
  const deployerKey = resolveDeployerKey(deploymentEnv)
  deploymentEnv.KEY_GOLDCHAIN = deployerKey
  deploymentEnv.GOLD_CHAIN_DEPLOYER_KEY = deployerKey

  if (!deploymentEnv.GOLD_CHAIN_LOTTERY_OPERATOR) {
    deploymentEnv.GOLD_CHAIN_LOTTERY_OPERATOR = governanceOwner
  }
  if (!deploymentEnv.GOLD_CHAIN_LOTTERY_TREASURY) {
    deploymentEnv.GOLD_CHAIN_LOTTERY_TREASURY = governanceOwner
  }
  if (!deploymentEnv.GOLD_CHAIN_LOTTERY_INJECTOR) {
    deploymentEnv.GOLD_CHAIN_LOTTERY_INJECTOR = governanceOwner
  }

  const provider = new ethers.providers.JsonRpcProvider(rpcUrl)
  const signer = new ethers.Wallet(deployerKey, provider)
  const chain = await provider.getNetwork()
  if (chain.chainId !== 714) {
    throw new Error(`Expected Gold Chain 714, got ${chain.chainId}`)
  }

  const moduleSteps = [
    {
      name: 'core_v2_and_farms',
      cwd: ROOT,
      command: 'node scripts/deploy-goldchain-dex.js',
      capture: (_logs, env) => captureCoreStep(env),
      governanceRequired: true,
    },
    {
      name: 'prepare_v3_artifacts',
      cwd: ROOT,
      command: 'node scripts/prepare-goldchain-v3-artifacts.js',
      capture: (logs) => ({
        outputs: { artifactPreparation: logs },
        envUpdates: {},
        governanceTargets: [],
      }),
      governanceRequired: false,
    },
    {
      name: 'v3_core_deployment',
      cwd: ROOT,
      command: 'node scripts/deploy-goldchain-v3-core.js',
      capture: () => captureV3CoreStep(),
      governanceRequired: true,
    },
    {
      name: 'v3_stack_registration',
      cwd: ROOT,
      command: 'node scripts/register-goldchain-v3-stack.js',
      capture: () => captureV3StackStep(),
      governanceRequired: false,
    },
    {
      name: 'stable_swap_lp_factory',
      cwd: path.resolve(ROOT, 'projects/stable-swap'),
      command: `npx hardhat run --network ${network} scripts/deploy_LPFactory.ts`,
      capture: (logs) =>
        captureSingleAddress(
          logs,
          'stableSwapLpFactory',
          /pancakeStableSwapLPFactory deployed to:\s*(0x[a-fA-F0-9]{40})/i,
          ['GOLD_CHAIN_STABLE_SWAP_LP_FACTORY'],
        ),
      governanceRequired: true,
    },
    {
      name: 'stable_swap_two_pool_deployer',
      cwd: path.resolve(ROOT, 'projects/stable-swap'),
      command: `npx hardhat run --network ${network} scripts/deploy_swapTwoPoolDeployer.ts`,
      capture: (logs) =>
        captureSingleAddress(
          logs,
          'stableSwapTwoPoolDeployer',
          /pancakeStableSwapTwoPoolDeployer deployed to:\s*(0x[a-fA-F0-9]{40})/i,
          ['GOLD_CHAIN_STABLE_SWAP_TWO_POOL_DEPLOYER'],
        ),
      governanceRequired: true,
    },
    {
      name: 'stable_swap_three_pool_deployer',
      cwd: path.resolve(ROOT, 'projects/stable-swap'),
      command: `npx hardhat run --network ${network} scripts/deploy_swapThreePoolDeployer.ts`,
      capture: (logs) =>
        captureSingleAddress(
          logs,
          'stableSwapThreePoolDeployer',
          /pancakeStableSwapThreePoolDeployer deployed to:\s*(0x[a-fA-F0-9]{40})/i,
          ['GOLD_CHAIN_STABLE_SWAP_THREE_POOL_DEPLOYER'],
        ),
      governanceRequired: true,
    },
    {
      name: 'stable_swap_factory',
      cwd: path.resolve(ROOT, 'projects/stable-swap'),
      command: `npx hardhat run --network ${network} scripts/deploy.ts`,
      capture: (logs) =>
        captureSingleAddress(
          logs,
          'stableSwapFactory',
          /pancakeStableSwapFactory deployed to:\s*(0x[a-fA-F0-9]{40})/i,
          ['GOLD_CHAIN_STABLE_SWAP_FACTORY'],
        ),
      governanceRequired: true,
    },
    {
      name: 'vecake_proxy_factory',
      cwd: path.resolve(ROOT, 'projects/vecake'),
      command: `npx hardhat run --network ${network} scripts/deployProxyForCakePoolFactory.ts`,
      capture: (logs) =>
        captureSingleAddress(
          logs,
          'proxyForCakePoolFactory',
          /Deployed to\s*(0x[a-fA-F0-9]{40})/i,
          ['GOLD_CHAIN_PROXY_FOR_CAKE_POOL_FACTORY'],
        ),
      governanceRequired: true,
    },
    {
      name: 'vecake',
      cwd: path.resolve(ROOT, 'projects/vecake'),
      command: `npx hardhat run --network ${network} scripts/deploy.ts`,
      capture: (logs) => {
        const captured = captureSingleAddress(logs, 'vecake', /Deployed to\s*(0x[a-fA-F0-9]{40})/i, [
          'GOLD_CHAIN_VECAKE_ADDRESS',
          'NEXT_PUBLIC_GOLD_CHAIN_VECAKE_ADDRESS',
        ])
        return captured
      },
      governanceRequired: true,
    },
    {
      name: 'voter',
      cwd: path.resolve(ROOT, 'projects/voter'),
      command: `npx hardhat run --network ${network} scripts/deploy.ts`,
      capture: (logs) => captureVoter(logs),
      governanceRequired: true,
    },
    {
      name: 'vecake_farm_booster_v3',
      cwd: path.resolve(ROOT, 'projects/vecake-farm-booster/v3'),
      command: `npx hardhat run --network ${network} scripts/deploy.ts`,
      capture: (logs) =>
        captureSingleAddress(logs, 'farmBooster', /farmBooster deployed to:\s*(0x[a-fA-F0-9]{40})/i, [
          'GOLD_CHAIN_FARM_BOOSTER_ADDRESS',
        ]),
      governanceRequired: true,
    },
    {
      name: 'revenue_sharing_pool_factory',
      cwd: path.resolve(ROOT, 'projects/revenue-sharing-pool/v2'),
      command: `npx hardhat run --network ${network} scripts/deployFactory.ts`,
      capture: (logs) =>
        captureSingleAddress(logs, 'revenueSharingPoolFactory', /Deployed to\s*(0x[a-fA-F0-9]{40})/i, [
          'NEXT_PUBLIC_GOLD_CHAIN_REVENUE_SHARING_POOL_FACTORY',
        ]),
      governanceRequired: true,
    },
    {
      name: 'revenue_sharing_pool_keeper',
      cwd: path.resolve(ROOT, 'projects/revenue-sharing-pool/v2'),
      command: `npx hardhat run --network ${network} scripts/deployKeeper.ts`,
      capture: (logs) =>
        captureSingleAddress(logs, 'revenueSharingPoolKeeper', /Deployed to\s*(0x[a-fA-F0-9]{40})/i, [
          'GOLD_CHAIN_REVENUE_SHARING_POOL_TWO_KEEPER',
        ]),
      governanceRequired: true,
    },
    {
      name: 'lottery',
      cwd: path.resolve(ROOT, 'projects/lottery'),
      command: `npx hardhat run --network ${network} scripts/deploy.ts`,
      capture: (logs) => captureLottery(logs),
      governanceRequired: true,
    },
  ]

  const executed = []
  for (const step of moduleSteps) {
    console.error(`[goldchain-launch] running ${step.name}`)
    const logs = runCommand(step, deploymentEnv)
    const capture = step.capture(logs, deploymentEnv)
    mergeEnv(deploymentEnv, capture.envUpdates || {})

    const governanceTargets = collectAddressValues(capture.governanceTargets || capture.outputs || {})
    const ownership = step.governanceRequired
      ? await enforceGovernanceHandoff(step.name, governanceTargets, signer, governanceOwner, {
          strictOwner: step.governanceStrict !== false,
        })
      : []

    executed.push({
      name: step.name,
      cwd: step.cwd,
      command: step.command,
      outputs: capture.outputs || {},
      envUpdates: capture.envUpdates || {},
      ownership,
    })
  }

  if (!fs.existsSync(CORE_DEPLOYMENT_FILE)) {
    throw new Error(`Core deployment file was not produced: ${CORE_DEPLOYMENT_FILE}`)
  }
  if (!fs.existsSync(V3_CORE_FILE)) {
    throw new Error(`V3 core deployment file was not produced: ${V3_CORE_FILE}`)
  }
  if (!fs.existsSync(V3_STACK_FILE)) {
    throw new Error(`V3 stack deployment file was not produced: ${V3_STACK_FILE}`)
  }

  assertFrontendGoldChainAddressEnv(deploymentEnv)

  const core = readJson(CORE_DEPLOYMENT_FILE)
  const v3Core = readJson(V3_CORE_FILE)
  const v3Stack = readJson(V3_STACK_FILE)
  writeFrontendEnv(deploymentEnv)

  const manifest = {
    manifestVersion: 'goldchain.dex.launch.pipeline.v2',
    schema: MANIFEST_SCHEMA_FILE,
    target,
    network,
    chainId: chain.chainId,
    generatedAt: new Date().toISOString(),
    governanceOwner,
    coreDeploymentFile: CORE_DEPLOYMENT_FILE,
    v3CoreDeploymentFile: V3_CORE_FILE,
    v3StackDeploymentFile: V3_STACK_FILE,
    core,
    v3Core,
    v3Stack,
    steps: executed,
    env: filteredGoldChainEnv(deploymentEnv),
  }

  const digest = sha256Hex(JSON.stringify(manifest, null, 2))
  manifest.manifestDigest = digest
  const signature = await signManifestDigest(digest)
  if (signature) {
    manifest.manifestSignature = signature
  }

  fs.mkdirSync(path.dirname(LAUNCH_MANIFEST_FILE), { recursive: true })
  fs.writeFileSync(LAUNCH_MANIFEST_FILE, `${JSON.stringify(manifest, null, 2)}\n`)

  console.error(JSON.stringify(manifest, null, 2))
}

main().catch((error) => {
  console.error(error)
  process.exit(1)
})
