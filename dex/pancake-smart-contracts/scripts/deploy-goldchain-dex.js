const fs = require('fs')
const path = require('path')
const { ethers } = require('ethers')

const ROOT = path.resolve(__dirname, '..')
const WALLET_FILE = path.resolve(ROOT, '../../.roughnet-wallets/evm-wallets.json')
const ADDRESS_FILE = path.resolve(ROOT, '../../.live-roughnet/live-bridge-addresses.json')
const FRONTEND_ENV_FILE = path.resolve(ROOT, '../pancake-frontend/apps/web/.env.local')
const DEPLOYMENT_FILE = path.resolve(ROOT, '../deployments/goldchain-roughnet.json')

const provider = new ethers.providers.JsonRpcProvider(process.env.GOLD_CHAIN_RPC_URL || 'http://127.0.0.1:8545')

function readJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, 'utf8'))
}

function loadArtifact(relativePath) {
  const artifact = readJson(path.resolve(ROOT, relativePath))
  return {
    abi: artifact.abi,
    bytecode: artifact.bytecode,
  }
}

function getWallets() {
  const wallets = readJson(WALLET_FILE)
  return {
    deployer: new ethers.Wallet(process.env.GOLD_CHAIN_DEPLOYER_KEY || wallets[0].private_key, provider),
    goldOwner: new ethers.Wallet(process.env.GOLD_CHAIN_GOLD_OWNER_KEY || wallets[2].private_key, provider),
  }
}

function getAddressBook() {
  const data = readJson(ADDRESS_FILE)
  return {
    rawGold: process.env.GOLD_CHAIN_RAW_GOLD_ADDRESS || data.child.gold,
    bridgedWeth: data.child.weth,
    usdt: process.env.GOLD_CHAIN_USDT_ADDRESS || data.child.usdt,
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
  const wgoldArtifact = loadArtifact('projects/exchange-protocol/artifacts/contracts/WGOLD.sol/WGOLD.json')
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
  const wgoldAbi = [
    'function wrap(uint256 tokenId, uint256 amount)',
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
  ]

  const dexPerBlock = ethers.utils.parseEther(process.env.GOLD_CHAIN_DEX_PER_BLOCK || '1')
  const dexMintAmount = ethers.utils.parseEther(process.env.GOLD_CHAIN_DEX_INITIAL_MINT || '1000000')
  const dexLiquidityAmount = ethers.utils.parseEther(process.env.GOLD_CHAIN_DEX_LIQUIDITY || '250000')
  const giltLiquidityAmount = ethers.utils.parseEther(process.env.GOLD_CHAIN_GILT_LIQUIDITY || '250000')
  const goldWrapAmount = ethers.utils.parseEther(process.env.GOLD_CHAIN_GOLD_WRAP || '250000')
  const dexGoldLiquidityAmount = ethers.utils.parseEther(process.env.GOLD_CHAIN_DEX_GOLD_LIQUIDITY || '250000')
  const deadline = Math.floor(Date.now() / 1000) + 60 * 60

  const chain = await provider.getNetwork()
  if (chain.chainId !== 714) {
    throw new Error(`Expected Gold Chain 714, got ${chain.chainId}`)
  }

  console.error('deploying multicall')
  const multicall = await deploy(multicallArtifact, deployer)

  console.error('deploying wrapped gold')
  const wgold = await deploy(wgoldArtifact, deployer, [addressBook.rawGold])

  console.error('deploying wrapped native gilt')
  const wgilt = await deploy(wgiltArtifact, deployer)

  console.error('deploying factory and router')
  const pancakeFactory = await deploy(factoryArtifact, deployer, [deployer.address])
  const pancakeRouter = await deploy(routerArtifact, deployer, [pancakeFactory.address, wgilt.address])

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
  const wgoldWrite = new ethers.Contract(wgold.address, wgoldAbi, deployer)
  const routerWrite = new ethers.Contract(pancakeRouter.address, routerAbi, deployer)
  const factoryRead = new ethers.Contract(pancakeFactory.address, factoryAbi, deployer)
  const masterChefWrite = new ethers.Contract(masterChef.address, masterChefAbi, deployer)

  console.error('minting initial DEX supply to deployer')
  await wait(dexTokenWrite.mint(deployer.address, dexMintAmount))

  console.error('funding deployer with raw GOLD and wrapping it')
  await wait(rawGoldWrite.mint(deployer.address, 1, goldWrapAmount))
  await wait(rawGoldForDeployer.setApprovalForAll(wgold.address, true))
  await wait(wgoldWrite.wrap(1, goldWrapAmount))

  console.error('approving router')
  await wait(dexTokenWrite.approve(pancakeRouter.address, dexMintAmount))
  await wait(wgoldWrite.approve(pancakeRouter.address, goldWrapAmount))

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

  console.error('adding GOLD/GILT liquidity')
  await wait(
    routerWrite.addLiquidityETH(wgold.address, goldWrapAmount, 0, 0, deployer.address, deadline, {
      value: giltLiquidityAmount,
    }),
  )

  console.error('adding DEX/GOLD liquidity')
  await wait(
    routerWrite.addLiquidity(
      dexToken.address,
      wgold.address,
      dexGoldLiquidityAmount,
      goldWrapAmount,
      0,
      0,
      deployer.address,
      deadline,
    ),
  )

  const dexGiltPair = await factoryRead.getPair(dexToken.address, wgilt.address)
  const goldGiltPair = await factoryRead.getPair(wgold.address, wgilt.address)
  const dexGoldPair = await factoryRead.getPair(dexToken.address, wgold.address)
  const lpAbi = ['function approve(address spender, uint256 amount) returns (bool)', 'function balanceOf(address account) view returns (uint256)']
  const dexGiltLp = new ethers.Contract(dexGiltPair, lpAbi, deployer)
  const goldGiltLp = new ethers.Contract(goldGiltPair, lpAbi, deployer)
  const dexGoldLp = new ethers.Contract(dexGoldPair, lpAbi, deployer)

  console.error('handing DEX minting to MasterChef')
  await wait(dexTokenWrite.transferOwnership(masterChef.address))
  await wait(syrupWrite.transferOwnership(masterChef.address))

  console.error('adding farm pools')
  await wait(masterChefWrite.add(1000, dexGiltPair, false))
  await wait(masterChefWrite.add(1000, goldGiltPair, false))
  await wait(masterChefWrite.add(1000, dexGoldPair, false))

  const dexGiltLpBalance = await dexGiltLp.balanceOf(deployer.address)
  const goldGiltLpBalance = await goldGiltLp.balanceOf(deployer.address)
  const dexGoldLpBalance = await dexGoldLp.balanceOf(deployer.address)
  await wait(dexGiltLp.approve(masterChef.address, dexGiltLpBalance))
  await wait(goldGiltLp.approve(masterChef.address, goldGiltLpBalance))
  await wait(dexGoldLp.approve(masterChef.address, dexGoldLpBalance))
  await wait(masterChefWrite.deposit(1, dexGiltLpBalance))
  await wait(masterChefWrite.deposit(2, goldGiltLpBalance))
  await wait(masterChefWrite.deposit(3, dexGoldLpBalance))

  const initCodeHash = ethers.utils.keccak256(pairArtifact.bytecode)

  const deployment = {
    chainId: chain.chainId,
    rpcUrl: provider.connection.url,
    deployer: deployer.address,
    rawGold: addressBook.rawGold,
    wgilt: wgilt.address,
    bridgedWeth: addressBook.bridgedWeth,
    usdt: addressBook.usdt,
    multicall3: multicall.address,
    wgold: wgold.address,
    factory: pancakeFactory.address,
    router: pancakeRouter.address,
    dex: dexToken.address,
    syrup: syrup.address,
    masterChef: masterChef.address,
    initCodeHash,
    pairs: {
      dexGilt: dexGiltPair,
      goldGilt: goldGiltPair,
      dexGold: dexGoldPair,
    },
    farms: {
      dexGiltPid: 1,
      goldGiltPid: 2,
      dexGoldPid: 3,
    },
    startBlock,
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
    `NEXT_PUBLIC_GOLD_CHAIN_GOLD_ADDRESS=${wgold.address}`,
    `NEXT_PUBLIC_GOLD_CHAIN_RAW_GOLD_ADDRESS=${addressBook.rawGold}`,
    `NEXT_PUBLIC_GOLD_CHAIN_DEX_ADDRESS=${dexToken.address}`,
    `NEXT_PUBLIC_GOLD_CHAIN_USDT_ADDRESS=${addressBook.usdt}`,
    `NEXT_PUBLIC_GOLD_CHAIN_MASTERCHEF_ADDRESS=${masterChef.address}`,
    `NEXT_PUBLIC_GOLD_CHAIN_DEX_GILT_LP_ADDRESS=${dexGiltPair}`,
    `NEXT_PUBLIC_GOLD_CHAIN_DEX_GILT_FARM_PID=1`,
    `NEXT_PUBLIC_GOLD_CHAIN_GOLD_GILT_LP_ADDRESS=${goldGiltPair}`,
    `NEXT_PUBLIC_GOLD_CHAIN_GOLD_GILT_FARM_PID=2`,
    `NEXT_PUBLIC_GOLD_CHAIN_DEX_GOLD_LP_ADDRESS=${dexGoldPair}`,
    `NEXT_PUBLIC_GOLD_CHAIN_DEX_GOLD_FARM_PID=3`,
    'NEXT_PUBLIC_GOLD_CHAIN_GILT_USDT_LP_ADDRESS=',
    'NEXT_PUBLIC_GOLD_CHAIN_GILT_USDT_FARM_PID=',
    'NEXT_PUBLIC_GOLD_CHAIN_GOLD_USDT_LP_ADDRESS=',
    'NEXT_PUBLIC_GOLD_CHAIN_GOLD_USDT_FARM_PID=',
    'NEXT_PUBLIC_GOLD_CHAIN_TOKEN_LIST=',
    'NEXT_PUBLIC_GOLD_CHAIN_V2_SUBGRAPH=',
    'NEXT_PUBLIC_GOLD_CHAIN_EXPLORER_CHAIN_NAME=gold-chain',
  ].join('\n')

  fs.writeFileSync(FRONTEND_ENV_FILE, `${env}\n`)

  console.error(JSON.stringify(deployment, null, 2))
}

main().catch((error) => {
  console.error(error)
  process.exit(1)
})
