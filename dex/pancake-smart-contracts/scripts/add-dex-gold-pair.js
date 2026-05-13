const fs = require('fs')
const path = require('path')
const { ethers } = require('ethers')

const ROOT = path.resolve(__dirname, '..')
const WALLET_FILE = path.resolve(ROOT, '../../.roughnet-wallets/evm-wallets.json')
const FRONTEND_ENV_FILE = path.resolve(ROOT, '../pancake-frontend/apps/web/.env.local')
const DEPLOYMENT_FILE = path.resolve(ROOT, '../deployments/goldchain-roughnet.json')

function readJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, 'utf8'))
}

function getWallets(provider) {
  const wallets = readJson(WALLET_FILE)
  return {
    deployer: new ethers.Wallet(process.env.GOLD_CHAIN_DEPLOYER_KEY || wallets[0].private_key, provider),
    goldOwner: new ethers.Wallet(process.env.GOLD_CHAIN_GOLD_OWNER_KEY || wallets[2].private_key, provider),
  }
}

function replaceEnvValue(contents, key, value) {
  const line = `${key}=${value}`
  const pattern = new RegExp(`^${key}=.*$`, 'm')
  if (pattern.test(contents)) {
    return contents.replace(pattern, line)
  }
  return `${contents.trimEnd()}\n${line}\n`
}

async function wait(txPromise) {
  const tx = await txPromise
  await tx.wait()
  return tx
}

async function main() {
  const deployment = readJson(DEPLOYMENT_FILE)
  const provider = new ethers.providers.JsonRpcProvider(process.env.GOLD_CHAIN_RPC_URL || deployment.rpcUrl)
  const { deployer, goldOwner } = getWallets(provider)

  const dexGoldPaxgLiquidityAmount = ethers.utils.parseEther(
    process.env.GOLD_CHAIN_DEX_GOLD_PAXG_LIQUIDITY || process.env.GOLD_CHAIN_DEX_GOLD_LIQUIDITY || '125000',
  )
  const dexGoldXautLiquidityAmount = ethers.utils.parseEther(
    process.env.GOLD_CHAIN_DEX_GOLD_XAUT_LIQUIDITY || process.env.GOLD_CHAIN_DEX_GOLD_LIQUIDITY || '125000',
  )
  const goldPaxgWrapAmount = ethers.utils.parseEther(
    process.env.GOLD_CHAIN_DEX_GOLD_PAXG_WRAP || process.env.GOLD_CHAIN_DEX_GOLD_WRAP || '125000',
  )
  const goldXautWrapAmount = ethers.utils.parseEther(
    process.env.GOLD_CHAIN_DEX_GOLD_XAUT_WRAP || process.env.GOLD_CHAIN_DEX_GOLD_WRAP || '125000',
  )
  const deadline = Math.floor(Date.now() / 1000) + 60 * 60
  const zeroAddress = ethers.constants.AddressZero

  const erc20Abi = [
    'function approve(address spender, uint256 amount) returns (bool)',
    'function balanceOf(address account) view returns (uint256)',
  ]
  const erc1155Abi = [
    'function mint(address account, uint256 tokenId, uint256 amount)',
    'function setApprovalForAll(address operator, bool approved)',
  ]
  const wgoldWrapperAbi = [
    'function wrap(uint256 tokenId, uint256 amount)',
    'function setApprovalForAll(address operator, bool approved)',
  ]
  const wgoldRouteAbi = [
    'function wrap(uint256 amount)',
    'function approve(address spender, uint256 amount) returns (bool)',
  ]
  const routerAbi = [
    'function addLiquidity(address tokenA, address tokenB, uint256 amountADesired, uint256 amountBDesired, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) returns (uint256 amountA, uint256 amountB, uint256 liquidity)',
  ]
  const factoryAbi = ['function getPair(address tokenA, address tokenB) view returns (address pair)']
  const masterChefAbi = [
    'function add(uint256 allocPoint, address lpToken, bool withUpdate)',
    'function deposit(uint256 pid, uint256 amount)',
    'function poolLength() view returns (uint256)',
    'function poolInfo(uint256) view returns (address lpToken, uint256 allocPoint, uint256 lastRewardBlock, uint256 accCakePerShare)',
  ]
  const lpAbi = [
    'function approve(address spender, uint256 amount) returns (bool)',
    'function balanceOf(address account) view returns (uint256)',
  ]

  const dexToken = new ethers.Contract(deployment.dex, erc20Abi, deployer)
  const rawGold = new ethers.Contract(deployment.rawGold, erc1155Abi, goldOwner)
  const rawGoldForDeployer = new ethers.Contract(deployment.rawGold, erc1155Abi, deployer)
  const wgoldWrapper = new ethers.Contract(deployment.wgoldWrapper, wgoldWrapperAbi, deployer)
  const goldPaxg = new ethers.Contract(deployment.goldPaxg, wgoldRouteAbi, deployer)
  const goldXaut = new ethers.Contract(deployment.goldXaut, wgoldRouteAbi, deployer)
  const router = new ethers.Contract(deployment.router, routerAbi, deployer)
  const factory = new ethers.Contract(deployment.factory, factoryAbi, provider)
  const masterChef = new ethers.Contract(deployment.masterChef, masterChefAbi, deployer)

  const ensureDexGoldPair = async ({
    routeTokenId,
    goldRouteAddress,
    goldRouteContract,
    wrapAmount,
    dexLiquidityAmount,
    pairKey,
    farmKey,
    envLpKey,
    envPidKey,
  }) => {
    let dexGoldPair = await factory.getPair(deployment.dex, goldRouteAddress)

    if (dexGoldPair === zeroAddress) {
      await wait(rawGold.mint(deployer.address, routeTokenId, wrapAmount))
      await wait(rawGoldForDeployer.setApprovalForAll(deployment.wgoldWrapper, true))
      await wait(wgoldWrapper.wrap(routeTokenId, wrapAmount))
      await wait(wgoldWrapper.setApprovalForAll(goldRouteAddress, true))
      await wait(goldRouteContract.wrap(wrapAmount))

      await wait(dexToken.approve(deployment.router, dexLiquidityAmount))
      await wait(goldRouteContract.approve(deployment.router, wrapAmount))
      await wait(
        router.addLiquidity(
          deployment.dex,
          goldRouteAddress,
          dexLiquidityAmount,
          wrapAmount,
          0,
          0,
          deployer.address,
          deadline,
        ),
      )

      dexGoldPair = await factory.getPair(deployment.dex, goldRouteAddress)
    }

    if (dexGoldPair === zeroAddress) {
      throw new Error(`DEX/${pairKey} pair was not created`)
    }

    const poolLength = (await masterChef.poolLength()).toNumber()
    let dexGoldPid = null
    for (let pid = 0; pid < poolLength; pid += 1) {
      const pool = await masterChef.poolInfo(pid)
      if (pool.lpToken.toLowerCase() === dexGoldPair.toLowerCase()) {
        dexGoldPid = pid
        break
      }
    }

    if (dexGoldPid === null) {
      await wait(masterChef.add(1000, dexGoldPair, false))
      dexGoldPid = (await masterChef.poolLength()).toNumber() - 1

      const lpToken = new ethers.Contract(dexGoldPair, lpAbi, deployer)
      const lpBalance = await lpToken.balanceOf(deployer.address)
      await wait(lpToken.approve(deployment.masterChef, lpBalance))
      await wait(masterChef.deposit(dexGoldPid, lpBalance))
    }

    deployment.pairs[pairKey] = dexGoldPair
    deployment.farms[farmKey] = dexGoldPid

    return {
      dexGoldPair,
      dexGoldPid,
      envLpKey,
      envPidKey,
    }
  }

  const pairUpdates = []
  pairUpdates.push(
    await ensureDexGoldPair({
      routeTokenId: 1,
      goldRouteAddress: deployment.goldPaxg,
      goldRouteContract: goldPaxg,
      wrapAmount: goldPaxgWrapAmount,
      dexLiquidityAmount: dexGoldPaxgLiquidityAmount,
      pairKey: 'dexGoldPaxg',
      farmKey: 'dexGoldPaxgPid',
      envLpKey: 'NEXT_PUBLIC_GOLD_CHAIN_DEX_GOLD_PAXG_LP_ADDRESS',
      envPidKey: 'NEXT_PUBLIC_GOLD_CHAIN_DEX_GOLD_PAXG_FARM_PID',
    }),
  )
  pairUpdates.push(
    await ensureDexGoldPair({
      routeTokenId: 2,
      goldRouteAddress: deployment.goldXaut,
      goldRouteContract: goldXaut,
      wrapAmount: goldXautWrapAmount,
      dexLiquidityAmount: dexGoldXautLiquidityAmount,
      pairKey: 'dexGoldXaut',
      farmKey: 'dexGoldXautPid',
      envLpKey: 'NEXT_PUBLIC_GOLD_CHAIN_DEX_GOLD_XAUT_LP_ADDRESS',
      envPidKey: 'NEXT_PUBLIC_GOLD_CHAIN_DEX_GOLD_XAUT_FARM_PID',
    }),
  )

  fs.writeFileSync(DEPLOYMENT_FILE, `${JSON.stringify(deployment, null, 2)}\n`)

  let env = fs.readFileSync(FRONTEND_ENV_FILE, 'utf8')
  for (const update of pairUpdates) {
    env = replaceEnvValue(env, update.envLpKey, update.dexGoldPair)
    env = replaceEnvValue(env, update.envPidKey, String(update.dexGoldPid))
  }
  fs.writeFileSync(FRONTEND_ENV_FILE, env)

  console.log(JSON.stringify({ pairUpdates }, null, 2))
}

main().catch((error) => {
  console.error(error)
  process.exit(1)
})
