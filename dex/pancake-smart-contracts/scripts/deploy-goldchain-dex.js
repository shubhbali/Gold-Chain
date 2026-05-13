const fs = require('fs')
const path = require('path')
const crypto = require('crypto')
const { ethers } = require('ethers')

const ROOT = path.resolve(__dirname, '..')
const WALLET_FILE = path.resolve(ROOT, '../../.roughnet-wallets/evm-wallets.json')
const ADDRESS_FILE = path.resolve(ROOT, '../../.live-roughnet/live-bridge-addresses.json')
const FRONTEND_ENV_FILE = path.resolve(ROOT, '../pancake-frontend/apps/web/.env.local')
const DEPLOYMENT_FILE = path.resolve(ROOT, '../deployments/goldchain-roughnet.json')
const ADDRESS_REGEX = /^0x[a-fA-F0-9]{40}$/

const provider = new ethers.providers.JsonRpcProvider(process.env.GOLD_CHAIN_RPC_URL || 'http://127.0.0.1:8545')

function readJson(filePath) {
  if (!fs.existsSync(filePath)) {
    throw new Error(`Required file does not exist: ${filePath}`)
  }
  return JSON.parse(fs.readFileSync(filePath, 'utf8'))
}

function loadArtifact(relativePath) {
  const artifact = readJson(path.resolve(ROOT, relativePath))
  return {
    abi: artifact.abi,
    bytecode: artifact.bytecode,
  }
}

function sha256Hex(input) {
  return `0x${crypto.createHash('sha256').update(input).digest('hex')}`
}

function extractLibraryInitCodeHash() {
  const libraryPath = path.resolve(ROOT, 'projects/exchange-protocol/contracts/libraries/PancakeLibrary.sol')
  const source = fs.readFileSync(libraryPath, 'utf8')
  const match = source.match(/PAIR_INIT_CODE_HASH\s*=\s*hex"([0-9a-fA-F]{64})"/)
  if (!match) {
    throw new Error('PAIR_INIT_CODE_HASH constant not found in PancakeLibrary.sol')
  }
  return `0x${match[1].toLowerCase()}`
}

function normalizeHexHash(value) {
  return value.toLowerCase()
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

function getOptionalAddress(key) {
  const value = process.env[key]
  if (!value) {
    return null
  }
  if (!/^0x[a-fA-F0-9]{40}$/.test(value)) {
    throw new Error(`Invalid address format for ${key}`)
  }
  return value
}

function requireAddress(value, label) {
  if (!value || !ADDRESS_REGEX.test(value)) {
    throw new Error(`Missing or invalid ${label}: ${value || 'empty'}`)
  }
  return value
}

function getWallets() {
  const wallets = readJson(WALLET_FILE)
  if (!Array.isArray(wallets) || wallets.length < 3) {
    throw new Error(`Expected at least 3 wallets in ${WALLET_FILE}`)
  }
  return {
    deployer: new ethers.Wallet(process.env.GOLD_CHAIN_DEPLOYER_KEY || wallets[0].private_key, provider),
    goldOwner: new ethers.Wallet(process.env.GOLD_CHAIN_GOLD_OWNER_KEY || wallets[2].private_key, provider),
  }
}

function getAddressBook() {
  const data = readJson(ADDRESS_FILE)
  return {
    rawGold: requireAddress(process.env.GOLD_CHAIN_RAW_GOLD_ADDRESS || data.child?.gold, 'raw GOLD address'),
    bridgedWeth: requireAddress(data.child?.weth, 'bridged WETH address'),
    usdt: requireAddress(process.env.GOLD_CHAIN_USDT_ADDRESS || data.child?.usdt, 'USDT address'),
  }
}

async function deploy(artifact, signer, args = []) {
  const factory = new ethers.ContractFactory(artifact.abi, artifact.bytecode, signer)
  const contract = await factory.deploy(...args)
  await contract.deployTransaction.wait()
  return contract
}

async function wait(txPromise) {
  const tx = await txPromise
  await tx.wait()
  return tx
}

async function main() {
  const { deployer, goldOwner } = getWallets()
  const addressBook = getAddressBook()

  const multicallArtifact = loadArtifact('projects/exchange-protocol/artifacts/contracts/Multicall3.sol/Multicall3.json')
  const wgoldWrapperArtifact = loadArtifact('projects/exchange-protocol/artifacts/contracts/WGOLD.sol/WGOLD.json')
  const wgoldRouteTokenArtifact = loadArtifact(
    'projects/exchange-protocol/artifacts/contracts/WGOLDRouteToken.sol/WGOLDRouteToken.json',
  )
  const wgiltArtifact = loadArtifact('projects/exchange-protocol/artifacts/contracts/libraries/WBNB.sol/WBNB.json')
  const factoryArtifact = loadArtifact(
    'projects/exchange-protocol/artifacts/contracts/PancakeFactory.sol/PancakeFactory.json',
  )
  const routerArtifact = loadArtifact(
    'projects/exchange-protocol/artifacts/contracts/PancakeRouter.sol/PancakeRouter.json',
  )
  const pairArtifact = loadArtifact('projects/exchange-protocol/artifacts/contracts/PancakePair.sol/PancakePair.json')
  const dexArtifact = loadArtifact('projects/farms-pools/artifacts/contracts/CakeToken.sol/CakeToken.json')
  const syrupArtifact = loadArtifact('projects/farms-pools/artifacts/contracts/SyrupBar.sol/SyrupBar.json')
  const masterChefArtifact = loadArtifact('projects/farms-pools/artifacts/contracts/MasterChef.sol/MasterChef.json')

  const erc20Abi = [
    'function approve(address spender, uint256 amount) returns (bool)',
    'function balanceOf(address account) view returns (uint256)',
    'function transferOwnership(address newOwner)',
    'function mint(address to, uint256 amount)',
  ]
  const erc1155Abi = [
    'function mint(address account, uint256 tokenId, uint256 amount)',
    'function setApprovalForAll(address operator, bool approved)',
    'function balanceOf(address account, uint256 id) view returns (uint256)',
  ]
  const wgoldWrapperAbi = [
    'function wrap(uint256 tokenId, uint256 amount)',
    'function setApprovalForAll(address operator, bool approved)',
    'function balanceOf(address account, uint256 id) view returns (uint256)',
  ]
  const wgoldRouteAbi = [
    'function wrap(uint256 amount)',
    'function approve(address spender, uint256 amount) returns (bool)',
    'function balanceOf(address account) view returns (uint256)',
  ]
  const routerAbi = [
    'function addLiquidity(address tokenA, address tokenB, uint256 amountADesired, uint256 amountBDesired, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) returns (uint256 amountA, uint256 amountB, uint256 liquidity)',
    'function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity)',
  ]
  const factoryAbi = ['function getPair(address tokenA, address tokenB) view returns (address pair)']
  const masterChefAbi = [
    'function add(uint256 allocPoint, address lpToken, bool withUpdate)',
    'function poolLength() view returns (uint256)',
    'function deposit(uint256 pid, uint256 amount)',
    'function transferOwnership(address newOwner)',
  ]

  const governanceOwner = getOptionalAddress('GOLD_CHAIN_GOVERNANCE_OWNER')
  const factoryFeeTo = getOptionalAddress('GOLD_CHAIN_FACTORY_FEE_TO')
  const enforceGovernance = process.env.GOLD_CHAIN_ENFORCE_GOVERNANCE === 'true'
  if (enforceGovernance && !governanceOwner) {
    throw new Error('GOLD_CHAIN_GOVERNANCE_OWNER must be set when GOLD_CHAIN_ENFORCE_GOVERNANCE=true')
  }

  const dexPerBlock = ethers.utils.parseEther(process.env.GOLD_CHAIN_DEX_PER_BLOCK || '1')
  const dexMintAmount = ethers.utils.parseEther(process.env.GOLD_CHAIN_DEX_INITIAL_MINT || '1000000')
  const dexLiquidityAmount = ethers.utils.parseEther(process.env.GOLD_CHAIN_DEX_LIQUIDITY || '250000')
  const giltLiquidityAmount = ethers.utils.parseEther(process.env.GOLD_CHAIN_GILT_LIQUIDITY || '250000')
  const goldPaxgWrapAmount = ethers.utils.parseEther(
    process.env.GOLD_CHAIN_GOLD_PAXG_WRAP || process.env.GOLD_CHAIN_GOLD_WRAP || '125000',
  )
  const goldXautWrapAmount = ethers.utils.parseEther(
    process.env.GOLD_CHAIN_GOLD_XAUT_WRAP || process.env.GOLD_CHAIN_GOLD_WRAP || '125000',
  )
  const goldPaxgGiltLiquidityAmount = ethers.utils.parseEther(
    process.env.GOLD_CHAIN_GOLD_PAXG_GILT_LIQUIDITY || process.env.GOLD_CHAIN_GILT_LIQUIDITY || '125000',
  )
  const goldXautGiltLiquidityAmount = ethers.utils.parseEther(
    process.env.GOLD_CHAIN_GOLD_XAUT_GILT_LIQUIDITY || process.env.GOLD_CHAIN_GILT_LIQUIDITY || '125000',
  )
  const dexGoldPaxgLiquidityAmount = ethers.utils.parseEther(
    process.env.GOLD_CHAIN_DEX_GOLD_PAXG_LIQUIDITY || process.env.GOLD_CHAIN_DEX_GOLD_LIQUIDITY || '125000',
  )
  const dexGoldXautLiquidityAmount = ethers.utils.parseEther(
    process.env.GOLD_CHAIN_DEX_GOLD_XAUT_LIQUIDITY || process.env.GOLD_CHAIN_DEX_GOLD_LIQUIDITY || '125000',
  )
  const totalGoldPaxgWrapAmount = goldPaxgWrapAmount.mul(2)
  const totalGoldXautWrapAmount = goldXautWrapAmount.mul(2)
  const deadline = Math.floor(Date.now() / 1000) + 60 * 60

  const chain = await provider.getNetwork()
  if (chain.chainId !== 714) {
    throw new Error(`Expected Gold Chain 714, got ${chain.chainId}`)
  }

  const compiledPairInitCodeHash = normalizeHexHash(ethers.utils.keccak256(pairArtifact.bytecode))
  const libraryPairInitCodeHash = extractLibraryInitCodeHash()
  if (compiledPairInitCodeHash !== libraryPairInitCodeHash) {
    throw new Error(
      `PAIR_INIT_CODE_HASH mismatch: compiled=${compiledPairInitCodeHash} library=${libraryPairInitCodeHash}. Recompile and update PancakeLibrary before deployment.`,
    )
  }

  console.error('deploying multicall')
  const multicall = await deploy(multicallArtifact, deployer)

  console.error('deploying wrapped gold route wrapper')
  const wgold = await deploy(wgoldWrapperArtifact, deployer, [addressBook.rawGold])

  console.error('deploying wrapped gold route tokens')
  const wgoldPaxg = await deploy(wgoldRouteTokenArtifact, deployer, [wgold.address, 1, 'Wrapped GOLD (PAXG)', 'WGOLD-PAXG'])
  const wgoldXaut = await deploy(wgoldRouteTokenArtifact, deployer, [wgold.address, 2, 'Wrapped GOLD (XAUT)', 'WGOLD-XAUT'])

  console.error('deploying wrapped native gilt')
  const wgilt = await deploy(wgiltArtifact, deployer)

  console.error('deploying factory and router')
  const pancakeFactory = await deploy(factoryArtifact, deployer, [deployer.address])
  const pancakeRouter = await deploy(routerArtifact, deployer, [pancakeFactory.address, wgilt.address])
  const factoryInitCodeHash = normalizeHexHash(await pancakeFactory.INIT_CODE_PAIR_HASH())
  if (factoryInitCodeHash !== compiledPairInitCodeHash) {
    throw new Error(
      `INIT_CODE_PAIR_HASH mismatch after deployment: factory=${factoryInitCodeHash} compiled=${compiledPairInitCodeHash}`,
    )
  }

  console.error('deploying DEX token and farm contracts')
  const dexToken = await deploy(dexArtifact, deployer)
  const syrup = await deploy(syrupArtifact, deployer, [dexToken.address])
  const startBlock = (await provider.getBlockNumber()) + 1
  const masterChef = await deploy(masterChefArtifact, deployer, [
    dexToken.address,
    syrup.address,
    deployer.address,
    dexPerBlock,
    startBlock,
  ])

  const dexTokenWrite = new ethers.Contract(dexToken.address, erc20Abi, deployer)
  const syrupWrite = new ethers.Contract(syrup.address, erc20Abi, deployer)
  const rawGoldWrite = new ethers.Contract(addressBook.rawGold, erc1155Abi, goldOwner)
  const rawGoldForDeployer = new ethers.Contract(addressBook.rawGold, erc1155Abi, deployer)
  const wgoldWrite = new ethers.Contract(wgold.address, wgoldWrapperAbi, deployer)
  const wgoldPaxgWrite = new ethers.Contract(wgoldPaxg.address, wgoldRouteAbi, deployer)
  const wgoldXautWrite = new ethers.Contract(wgoldXaut.address, wgoldRouteAbi, deployer)
  const routerWrite = new ethers.Contract(pancakeRouter.address, routerAbi, deployer)
  const factoryRead = new ethers.Contract(pancakeFactory.address, factoryAbi, deployer)
  const masterChefWrite = new ethers.Contract(masterChef.address, masterChefAbi, deployer)

  console.error('minting initial DEX supply to deployer')
  await wait(dexTokenWrite.mint(deployer.address, dexMintAmount))

  console.error('funding deployer with route-specific raw GOLD and wrapping it')
  await wait(rawGoldWrite.mint(deployer.address, 1, totalGoldPaxgWrapAmount))
  await wait(rawGoldWrite.mint(deployer.address, 2, totalGoldXautWrapAmount))
  await wait(rawGoldForDeployer.setApprovalForAll(wgold.address, true))
  await wait(wgoldWrite.wrap(1, totalGoldPaxgWrapAmount))
  await wait(wgoldWrite.wrap(2, totalGoldXautWrapAmount))
  await wait(wgoldWrite.setApprovalForAll(wgoldPaxg.address, true))
  await wait(wgoldWrite.setApprovalForAll(wgoldXaut.address, true))
  await wait(wgoldPaxgWrite.wrap(totalGoldPaxgWrapAmount))
  await wait(wgoldXautWrite.wrap(totalGoldXautWrapAmount))

  console.error('approving router')
  await wait(dexTokenWrite.approve(pancakeRouter.address, dexMintAmount))
  await wait(wgoldPaxgWrite.approve(pancakeRouter.address, totalGoldPaxgWrapAmount))
  await wait(wgoldXautWrite.approve(pancakeRouter.address, totalGoldXautWrapAmount))

  console.error('adding DEX/GILT liquidity')
  await wait(
    routerWrite.addLiquidityETH(
      dexToken.address,
      dexLiquidityAmount,
      0,
      0,
      deployer.address,
      deadline,
      { value: giltLiquidityAmount },
    ),
  )

  console.error('adding GOLD(PAXG)/GILT liquidity')
  await wait(
    routerWrite.addLiquidityETH(wgoldPaxg.address, goldPaxgWrapAmount, 0, 0, deployer.address, deadline, {
      value: goldPaxgGiltLiquidityAmount,
    }),
  )

  console.error('adding GOLD(XAUT)/GILT liquidity')
  await wait(
    routerWrite.addLiquidityETH(wgoldXaut.address, goldXautWrapAmount, 0, 0, deployer.address, deadline, {
      value: goldXautGiltLiquidityAmount,
    }),
  )

  console.error('adding DEX/GOLD(PAXG) liquidity')
  await wait(
    routerWrite.addLiquidity(
      dexToken.address,
      wgoldPaxg.address,
      dexGoldPaxgLiquidityAmount,
      goldPaxgWrapAmount,
      0,
      0,
      deployer.address,
      deadline,
    ),
  )

  console.error('adding DEX/GOLD(XAUT) liquidity')
  await wait(
    routerWrite.addLiquidity(
      dexToken.address,
      wgoldXaut.address,
      dexGoldXautLiquidityAmount,
      goldXautWrapAmount,
      0,
      0,
      deployer.address,
      deadline,
    ),
  )

  const dexGiltPair = await factoryRead.getPair(dexToken.address, wgilt.address)
  const goldPaxgGiltPair = await factoryRead.getPair(wgoldPaxg.address, wgilt.address)
  const goldXautGiltPair = await factoryRead.getPair(wgoldXaut.address, wgilt.address)
  const dexGoldPaxgPair = await factoryRead.getPair(dexToken.address, wgoldPaxg.address)
  const dexGoldXautPair = await factoryRead.getPair(dexToken.address, wgoldXaut.address)
  const lpAbi = ['function approve(address spender, uint256 amount) returns (bool)', 'function balanceOf(address account) view returns (uint256)']
  const dexGiltLp = new ethers.Contract(dexGiltPair, lpAbi, deployer)
  const goldPaxgGiltLp = new ethers.Contract(goldPaxgGiltPair, lpAbi, deployer)
  const goldXautGiltLp = new ethers.Contract(goldXautGiltPair, lpAbi, deployer)
  const dexGoldPaxgLp = new ethers.Contract(dexGoldPaxgPair, lpAbi, deployer)
  const dexGoldXautLp = new ethers.Contract(dexGoldXautPair, lpAbi, deployer)

  console.error('handing DEX minting to MasterChef')
  await wait(dexTokenWrite.transferOwnership(masterChef.address))
  await wait(syrupWrite.transferOwnership(masterChef.address))

  console.error('adding farm pools')
  await wait(masterChefWrite.add(1000, dexGiltPair, false))
  await wait(masterChefWrite.add(1000, goldPaxgGiltPair, false))
  await wait(masterChefWrite.add(1000, goldXautGiltPair, false))
  await wait(masterChefWrite.add(1000, dexGoldPaxgPair, false))
  await wait(masterChefWrite.add(1000, dexGoldXautPair, false))

  const dexGiltLpBalance = await dexGiltLp.balanceOf(deployer.address)
  const goldPaxgGiltLpBalance = await goldPaxgGiltLp.balanceOf(deployer.address)
  const goldXautGiltLpBalance = await goldXautGiltLp.balanceOf(deployer.address)
  const dexGoldPaxgLpBalance = await dexGoldPaxgLp.balanceOf(deployer.address)
  const dexGoldXautLpBalance = await dexGoldXautLp.balanceOf(deployer.address)
  await wait(dexGiltLp.approve(masterChef.address, dexGiltLpBalance))
  await wait(goldPaxgGiltLp.approve(masterChef.address, goldPaxgGiltLpBalance))
  await wait(goldXautGiltLp.approve(masterChef.address, goldXautGiltLpBalance))
  await wait(dexGoldPaxgLp.approve(masterChef.address, dexGoldPaxgLpBalance))
  await wait(dexGoldXautLp.approve(masterChef.address, dexGoldXautLpBalance))
  await wait(masterChefWrite.deposit(1, dexGiltLpBalance))
  await wait(masterChefWrite.deposit(2, goldPaxgGiltLpBalance))
  await wait(masterChefWrite.deposit(3, goldXautGiltLpBalance))
  await wait(masterChefWrite.deposit(4, dexGoldPaxgLpBalance))
  await wait(masterChefWrite.deposit(5, dexGoldXautLpBalance))

  if (factoryFeeTo) {
    console.error(`setting factory feeTo=${factoryFeeTo}`)
    await wait(pancakeFactory.setFeeTo(factoryFeeTo))
  }
  if (governanceOwner) {
    console.error(`transferring governance ownership to ${governanceOwner}`)
    await wait(masterChefWrite.transferOwnership(governanceOwner))
    await wait(pancakeFactory.setFeeToSetter(governanceOwner))
  }

  const initCodeHash = compiledPairInitCodeHash
  const manifestVersion = 'goldchain.dex.launch.v1'
  const target = process.env.GOLD_CHAIN_DEPLOY_TARGET || 'testnet'

  const deployment = {
    manifestVersion,
    target,
    chainId: chain.chainId,
    rpcUrl: provider.connection.url,
    deployer: deployer.address,
    rawGold: addressBook.rawGold,
    wgilt: wgilt.address,
    wgoldWrapper: wgold.address,
    goldPaxg: wgoldPaxg.address,
    goldXaut: wgoldXaut.address,
    bridgedWeth: addressBook.bridgedWeth,
    usdt: addressBook.usdt,
    multicall3: multicall.address,
    factory: pancakeFactory.address,
    router: pancakeRouter.address,
    dex: dexToken.address,
    syrup: syrup.address,
    masterChef: masterChef.address,
    initCodeHash,
    initCodeHashSources: {
      compiled: compiledPairInitCodeHash,
      library: libraryPairInitCodeHash,
      factory: factoryInitCodeHash,
    },
    bytecodeHashes: {
      pancakePair: ethers.utils.keccak256(pairArtifact.bytecode),
      pancakeFactory: ethers.utils.keccak256(factoryArtifact.bytecode),
      pancakeRouter: ethers.utils.keccak256(routerArtifact.bytecode),
      wgilt: ethers.utils.keccak256(wgiltArtifact.bytecode),
      wgoldWrapper: ethers.utils.keccak256(wgoldWrapperArtifact.bytecode),
      wgoldRouteToken: ethers.utils.keccak256(wgoldRouteTokenArtifact.bytecode),
      dexToken: ethers.utils.keccak256(dexArtifact.bytecode),
      syrup: ethers.utils.keccak256(syrupArtifact.bytecode),
      masterChef: ethers.utils.keccak256(masterChefArtifact.bytecode),
    },
    pairs: {
      dexGilt: dexGiltPair,
      goldPaxgGilt: goldPaxgGiltPair,
      goldXautGilt: goldXautGiltPair,
      dexGoldPaxg: dexGoldPaxgPair,
      dexGoldXaut: dexGoldXautPair,
    },
    farms: {
      dexGiltPid: 1,
      goldPaxgGiltPid: 2,
      goldXautGiltPid: 3,
      dexGoldPaxgPid: 4,
      dexGoldXautPid: 5,
    },
    startBlock,
    ownership: {
      dexTokenOwner: masterChef.address,
      syrupOwner: masterChef.address,
      factoryFeeToSetter: governanceOwner || deployer.address,
      masterChefOwner: governanceOwner || deployer.address,
    },
    governance: {
      owner: governanceOwner,
      factoryFeeTo,
      enforced: enforceGovernance,
    },
    createdAt: new Date().toISOString(),
  }

  const unsignedPayload = JSON.stringify(deployment, null, 2)
  const digest = sha256Hex(unsignedPayload)
  const signature = await signManifestDigest(digest)
  deployment.manifestDigest = digest
  if (signature) {
    deployment.manifestSignature = signature
  }

  fs.mkdirSync(path.dirname(DEPLOYMENT_FILE), { recursive: true })
  fs.writeFileSync(DEPLOYMENT_FILE, `${JSON.stringify(deployment, null, 2)}\n`)

  const env = [
    `NEXT_PUBLIC_GOLD_CHAIN_RPC=${provider.connection.url}`,
    `NEXT_PUBLIC_GOLD_CHAIN_BACKUP_RPC=${provider.connection.url}`,
    `NEXT_PUBLIC_GOLD_CHAIN_EXPLORER=http://localhost`,
    `NEXT_PUBLIC_GOLD_CHAIN_WEBSITE=http://localhost:3000`,
    `NEXT_PUBLIC_GOLD_CHAIN_MULTICALL3_ADDRESS=${multicall.address}`,
    `NEXT_PUBLIC_GOLD_CHAIN_MULTICALL_ADDRESS=${multicall.address}`,
    `NEXT_PUBLIC_GOLD_CHAIN_FACTORY_ADDRESS=${pancakeFactory.address}`,
    `NEXT_PUBLIC_GOLD_CHAIN_ROUTER_ADDRESS=${pancakeRouter.address}`,
    `NEXT_PUBLIC_GOLD_CHAIN_SMART_ROUTER_ADDRESS=${pancakeRouter.address}`,
    `NEXT_PUBLIC_GOLD_CHAIN_INIT_CODE_HASH=${initCodeHash}`,
    `NEXT_PUBLIC_GOLD_CHAIN_WGILT_ADDRESS=${wgilt.address}`,
    `NEXT_PUBLIC_GOLD_CHAIN_WGOLD_WRAPPER_ADDRESS=${wgold.address}`,
    `NEXT_PUBLIC_GOLD_CHAIN_GOLD_PAXG_ADDRESS=${wgoldPaxg.address}`,
    `NEXT_PUBLIC_GOLD_CHAIN_GOLD_XAUT_ADDRESS=${wgoldXaut.address}`,
    `NEXT_PUBLIC_GOLD_CHAIN_RAW_GOLD_ADDRESS=${addressBook.rawGold}`,
    `NEXT_PUBLIC_GOLD_CHAIN_DEX_ADDRESS=${dexToken.address}`,
    `NEXT_PUBLIC_GOLD_CHAIN_USDT_ADDRESS=${addressBook.usdt}`,
    `NEXT_PUBLIC_GOLD_CHAIN_MASTERCHEF_ADDRESS=${masterChef.address}`,
    `NEXT_PUBLIC_GOLD_CHAIN_MASTERCHEF_V3_ADDRESS=${process.env.NEXT_PUBLIC_GOLD_CHAIN_MASTERCHEF_V3_ADDRESS || ''}`,
    `NEXT_PUBLIC_GOLD_CHAIN_DEX_GILT_LP_ADDRESS=${dexGiltPair}`,
    `NEXT_PUBLIC_GOLD_CHAIN_DEX_GILT_FARM_PID=1`,
    `NEXT_PUBLIC_GOLD_CHAIN_GOLD_PAXG_GILT_LP_ADDRESS=${goldPaxgGiltPair}`,
    `NEXT_PUBLIC_GOLD_CHAIN_GOLD_PAXG_GILT_FARM_PID=2`,
    `NEXT_PUBLIC_GOLD_CHAIN_GOLD_XAUT_GILT_LP_ADDRESS=${goldXautGiltPair}`,
    `NEXT_PUBLIC_GOLD_CHAIN_GOLD_XAUT_GILT_FARM_PID=3`,
    `NEXT_PUBLIC_GOLD_CHAIN_DEX_GOLD_PAXG_LP_ADDRESS=${dexGoldPaxgPair}`,
    `NEXT_PUBLIC_GOLD_CHAIN_DEX_GOLD_PAXG_FARM_PID=4`,
    `NEXT_PUBLIC_GOLD_CHAIN_DEX_GOLD_XAUT_LP_ADDRESS=${dexGoldXautPair}`,
    `NEXT_PUBLIC_GOLD_CHAIN_DEX_GOLD_XAUT_FARM_PID=5`,
    'NEXT_PUBLIC_GOLD_CHAIN_GILT_USDT_LP_ADDRESS=',
    'NEXT_PUBLIC_GOLD_CHAIN_GILT_USDT_FARM_PID=',
    'NEXT_PUBLIC_GOLD_CHAIN_GOLD_PAXG_USDT_LP_ADDRESS=',
    'NEXT_PUBLIC_GOLD_CHAIN_GOLD_PAXG_USDT_FARM_PID=',
    'NEXT_PUBLIC_GOLD_CHAIN_GOLD_XAUT_USDT_LP_ADDRESS=',
    'NEXT_PUBLIC_GOLD_CHAIN_GOLD_XAUT_USDT_FARM_PID=',
    'NEXT_PUBLIC_GOLD_CHAIN_TOKEN_LIST=',
    `NEXT_PUBLIC_GOLD_CHAIN_V2_SUBGRAPH=${process.env.NEXT_PUBLIC_GOLD_CHAIN_V2_SUBGRAPH || ''}`,
    `NEXT_PUBLIC_GOLD_CHAIN_V3_SUBGRAPH=${process.env.NEXT_PUBLIC_GOLD_CHAIN_V3_SUBGRAPH || ''}`,
    `NEXT_PUBLIC_GOLD_CHAIN_STABLESWAP_SUBGRAPH=${process.env.NEXT_PUBLIC_GOLD_CHAIN_STABLESWAP_SUBGRAPH || ''}`,
    `NEXT_PUBLIC_GOLD_CHAIN_LOTTERY_SUBGRAPH=${process.env.NEXT_PUBLIC_GOLD_CHAIN_LOTTERY_SUBGRAPH || ''}`,
    `NEXT_PUBLIC_GOLD_CHAIN_LOTTERY_ADDRESS=${process.env.NEXT_PUBLIC_GOLD_CHAIN_LOTTERY_ADDRESS || ''}`,
    `NEXT_PUBLIC_GOLD_CHAIN_V3_FACTORY=${process.env.NEXT_PUBLIC_GOLD_CHAIN_V3_FACTORY || ''}`,
    `NEXT_PUBLIC_GOLD_CHAIN_V3_POOL_DEPLOYER=${process.env.NEXT_PUBLIC_GOLD_CHAIN_V3_POOL_DEPLOYER || ''}`,
    `NEXT_PUBLIC_GOLD_CHAIN_V3_NFT_POSITION_MANAGER=${process.env.NEXT_PUBLIC_GOLD_CHAIN_V3_NFT_POSITION_MANAGER || ''}`,
    `NEXT_PUBLIC_GOLD_CHAIN_V3_MIGRATOR=${process.env.NEXT_PUBLIC_GOLD_CHAIN_V3_MIGRATOR || ''}`,
    `NEXT_PUBLIC_GOLD_CHAIN_V3_QUOTER=${process.env.NEXT_PUBLIC_GOLD_CHAIN_V3_QUOTER || ''}`,
    `NEXT_PUBLIC_GOLD_CHAIN_STABLE_SWAP_INFO_ADDRESS=${process.env.NEXT_PUBLIC_GOLD_CHAIN_STABLE_SWAP_INFO_ADDRESS || ''}`,
    `NEXT_PUBLIC_GOLD_CHAIN_STABLE_SWAP_NATIVE_HELPER=${process.env.NEXT_PUBLIC_GOLD_CHAIN_STABLE_SWAP_NATIVE_HELPER || ''}`,
    `NEXT_PUBLIC_GOLD_CHAIN_VCAKE_ADDRESS=${process.env.NEXT_PUBLIC_GOLD_CHAIN_VCAKE_ADDRESS || ''}`,
    `NEXT_PUBLIC_GOLD_CHAIN_VECAKE_ADDRESS=${process.env.NEXT_PUBLIC_GOLD_CHAIN_VECAKE_ADDRESS || ''}`,
    `NEXT_PUBLIC_GOLD_CHAIN_REVENUE_SHARING_POOL=${process.env.NEXT_PUBLIC_GOLD_CHAIN_REVENUE_SHARING_POOL || ''}`,
    `NEXT_PUBLIC_GOLD_CHAIN_REVENUE_SHARING_VECAKE=${process.env.NEXT_PUBLIC_GOLD_CHAIN_REVENUE_SHARING_VECAKE || ''}`,
    `NEXT_PUBLIC_GOLD_CHAIN_REVENUE_SHARING_CAKE_POOL=${process.env.NEXT_PUBLIC_GOLD_CHAIN_REVENUE_SHARING_CAKE_POOL || ''}`,
    `NEXT_PUBLIC_GOLD_CHAIN_REVENUE_SHARING_POOL_GATEWAY=${process.env.NEXT_PUBLIC_GOLD_CHAIN_REVENUE_SHARING_POOL_GATEWAY || ''}`,
    'NEXT_PUBLIC_GOLD_CHAIN_EXPLORER_CHAIN_NAME=gold-chain',
  ].join('\n')

  fs.writeFileSync(FRONTEND_ENV_FILE, `${env}\n`)

  console.error(JSON.stringify(deployment, null, 2))
}

main().catch((error) => {
  console.error(error)
  process.exit(1)
})
