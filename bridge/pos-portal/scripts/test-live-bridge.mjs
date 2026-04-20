import fs from 'fs';
import path from 'path';
import { ethers } from 'ethers';
import {
  DEFAULT_GILTCONSENSUS_URL,
  DEFAULT_SEPOLIA_RPC,
  NATIVE_GILT_BRIDGE_ADDRESS,
  REPO_ROOT,
  ROOT_ETHER_ADDRESS,
  STATE_RECEIVER_ADDRESS,
  addressEq,
  createCheckpointBuilder,
  childRpcFor,
  contractAt,
  loadAddressBook,
  readBridgeProgress,
  rpcProviderFor,
  readArtifact,
  readJson,
  saveAddressBook,
  sleep,
  waitForChildStateId,
  waitForCondition,
  waitForGiltConsensusRecord,
  waitForMined,
  waitForRpc,
} from './live-bridge-common.mjs';

function firstExistingPath(paths) {
  for (const candidate of paths) {
    if (candidate && fs.existsSync(candidate)) {
      return candidate;
    }
  }
  return null;
}

const liveChainDir = process.env.LIVE_CHAIN_DIR
  ? path.resolve(REPO_ROOT, process.env.LIVE_CHAIN_DIR)
  : firstExistingPath([
      path.join(REPO_ROOT, '.live-chain'),
      path.join(REPO_ROOT, '.live-roughnet'),
    ]) || path.join(REPO_ROOT, '.live-roughnet');

const walletFile = process.env.TESTNET_WALLETS_FILE || firstExistingPath([
  path.join(REPO_ROOT, '.testnet-wallets', 'evm-wallets.json'),
  path.join(REPO_ROOT, '.roughnet-wallets', 'evm-wallets.json'),
]);

if (!walletFile) {
  throw new Error('wallet file not found (.testnet-wallets/evm-wallets.json or .roughnet-wallets/evm-wallets.json)');
}

const portalArtifacts = {
  rootChainManager: readArtifact(
    'bridge/pos-portal/artifacts/contracts/root/RootChainManager/RootChainManager.sol/RootChainManager.json',
  ),
  childChainManager: readArtifact(
    'bridge/pos-portal/artifacts/contracts/child/ChildChainManager/ChildChainManager.sol/ChildChainManager.json',
  ),
  erc20Predicate: readArtifact(
    'bridge/pos-portal/artifacts/contracts/root/TokenPredicates/ERC20Predicate.sol/ERC20Predicate.json',
  ),
  etherPredicate: readArtifact(
    'bridge/pos-portal/artifacts/contracts/root/TokenPredicates/EtherPredicate.sol/EtherPredicate.json',
  ),
  wrappedGiltPredicate: readArtifact(
    'bridge/pos-portal/artifacts/contracts/root/TokenPredicates/WrappedGiltPredicate.sol/WrappedGiltPredicate.json',
  ),
  scaledErc1155Predicate: readArtifact(
    'bridge/pos-portal/artifacts/contracts/root/TokenPredicates/ScaledERC1155Predicate.sol/ScaledERC1155Predicate.json',
  ),
  wrappedGilt: readArtifact('bridge/pos-portal/artifacts/contracts/root/RootToken/WrappedGilt.sol/WrappedGilt.json'),
  dummyErc20: readArtifact('bridge/pos-portal/artifacts/contracts/root/RootToken/DummyERC20.sol/DummyERC20.json'),
  childErc20: readArtifact('bridge/pos-portal/artifacts/contracts/child/ChildToken/ChildERC20.sol/ChildERC20.json'),
  giltWeth: readArtifact('bridge/pos-portal/artifacts/contracts/child/ChildToken/GiltWETH.sol/GiltWETH.json'),
};

const chainArtifacts = {
  physicalGold1155: readArtifact('gilt-genesis-contract/out/PhysicalGold1155.sol/PhysicalGold1155.json'),
  nativeGiltBridge: readArtifact('gilt-genesis-contract/out/NativeGiltBridge.sol/NativeGiltBridge.json'),
};

const stateSenderAbi = ['function counter() view returns (uint256)'];
const stateReceiverAbi = ['function lastStateId() view returns (uint256)'];

const MIN_SEPOLIA_TEST_ETH = ethers.parseEther('0.01');
const SEP_FUND_AMOUNT = ethers.parseEther('0.01');
const ROOT_DEPOSIT_GAS_LIMIT = 1_000_000n;
const ROOT_EXIT_GAS_LIMIT = 4_000_000n;
const BRIDGE_WAIT_TIMEOUT_MS = Number(process.env.BRIDGE_WAIT_TIMEOUT_MS || 2_700_000);

async function waitTx(txPromise) {
  const tx = await txPromise;
  return waitForMined(tx);
}

function assertEq(actual, expected, label) {
  if (actual !== expected) {
    throw new Error(`${label}: expected ${expected} got ${actual}`);
  }
}

function feePaid(receipt) {
  const gasPrice = receipt.gasPrice ?? receipt.effectiveGasPrice ?? 0n;
  return receipt.gasUsed * gasPrice;
}

async function waitTokenBalance(token, owner, expected, label) {
  await waitForCondition(
    async () => {
      const balance = await token.balanceOf(owner);
      return balance >= expected ? balance : null;
    },
    label,
    300000,
    3000,
  );
}

async function waitTokenAllowance(token, owner, spender, expected, label) {
  await waitForCondition(
    async () => {
      const allowance = await token.allowance(owner, spender);
      return allowance >= expected ? allowance : null;
    },
    label,
    300000,
    3000,
  );
}

async function waitForBridgeCatchup(rootStateSender, childStateReceiver, giltconsensusUrl) {
  const targetId = await rootStateSender.counter();
  console.log(`Waiting for GiltConsensus to persist state sync ${targetId.toString()}`);
  await waitForGiltConsensusRecord(giltconsensusUrl, targetId, BRIDGE_WAIT_TIMEOUT_MS, 5000);
  console.log(`Waiting for child chain to apply state sync ${targetId.toString()}`);
  await waitForChildStateId(childStateReceiver, targetId, BRIDGE_WAIT_TIMEOUT_MS, 5000);
  return readBridgeProgress(rootStateSender, childStateReceiver, giltconsensusUrl);
}

function findLogIndex(receipt, emitter, topic0 = null) {
  const emitterLc = emitter.toLowerCase();
  return receipt.logs.findIndex((log) => {
    if (log.address.toLowerCase() !== emitterLc) {
      return false;
    }
    if (!topic0) {
      return true;
    }
    return log.topics[0].toLowerCase() === topic0.toLowerCase();
  });
}

async function ensureSepoliaEth(deployer, user) {
  const balance = await deployer.provider.getBalance(user.address);
  if (balance >= MIN_SEPOLIA_TEST_ETH) {
    return;
  }
  const tx = await deployer.sendTransaction({
    to: user.address,
    value: SEP_FUND_AMOUNT,
  });
  await waitForMined(tx);
}

async function assertRouteMapping(rootChainManager, childChainManager, rootToken, childToken, label) {
  const [rootMapped, childMapped] = await Promise.all([
    rootChainManager.rootToChildToken(rootToken),
    childChainManager.rootToChildToken(rootToken),
  ]);
  if (!addressEq(rootMapped, childToken)) {
    throw new Error(`${label} root mapping mismatch: ${rootMapped} != ${childToken}`);
  }
  if (!addressEq(childMapped, childToken)) {
    throw new Error(`${label} child mapping mismatch: ${childMapped} != ${childToken}`);
  }
}

async function submitGoldDeposit(context, route) {
  const {
    sepoliaUser,
    roughnetUser,
    rootChainManager,
    scaledErc1155Predicate,
    childGold,
    rootPaxg,
    rootXaut,
    checkpointExitData,
  } = context;

  const rootToken = route === 'PAXG' ? rootPaxg : rootXaut;
  const tokenId = route === 'PAXG' ? 1n : 2n;
  const rootAmount = 2n;
  const childAmount = 2000n;

  await waitTx(rootToken.connect(sepoliaUser).mint(rootAmount));
  await waitTokenBalance(rootToken, sepoliaUser.address, rootAmount, `${route} root mint visibility`);
  const rootBefore = await rootToken.balanceOf(sepoliaUser.address);
  const childBefore = await childGold.balanceOf(roughnetUser.address, tokenId);

  const predicateAddress = await scaledErc1155Predicate.getAddress();
  await waitTx(rootToken.connect(sepoliaUser).approve(predicateAddress, rootAmount));
  await waitTokenAllowance(rootToken, sepoliaUser.address, predicateAddress, rootAmount, `${route} allowance visibility`);
  const depositTx = await rootChainManager.connect(sepoliaUser).depositFor(
    roughnetUser.address,
    await rootToken.getAddress(),
    abi.encode(['uint256', 'uint256'], [tokenId, rootAmount]),
    { gasLimit: ROOT_DEPOSIT_GAS_LIMIT },
  );
  await waitForMined(depositTx);

  return {
    route,
    rootToken,
    tokenId,
    rootBefore,
    childBefore,
    rootAmount,
    childAmount,
  };
}

async function awaitGoldDeposit(context, state) {
  const { childGold, roughnetUser } = context;
  const { route, tokenId, childBefore, childAmount } = state;
  await waitForCondition(
    async () => {
      const balance = await childGold.balanceOf(roughnetUser.address, tokenId);
      return balance === childBefore + childAmount ? balance : null;
    },
    `${route} child GOLD mint`,
    BRIDGE_WAIT_TIMEOUT_MS,
    5000,
  );

}

async function exitGoldDeposit(context, state) {
  const { sepoliaUser, roughnetUser, rootChainManager, childGold, checkpointExitData } = context;
  const { route, rootToken, tokenId, rootBefore, childAmount } = state;
  const withdrawTx = await childGold.connect(roughnetUser).withdrawSingle(tokenId, childAmount);
  const withdrawReceipt = await waitForMined(withdrawTx);
  const logIndex = findLogIndex(withdrawReceipt, await childGold.getAddress());
  const exitData = await checkpointExitData(withdrawReceipt.hash, logIndex);

  await waitTx(rootChainManager.connect(sepoliaUser).exit(exitData, { gasLimit: ROOT_EXIT_GAS_LIMIT }));
  const rootAfter = await rootToken.balanceOf(sepoliaUser.address);
  assertEq(rootAfter.toString(), rootBefore.toString(), `${route} root balance restored`);
}

async function submitErc20Deposit(context, label, rootToken, childToken) {
  const { sepoliaUser, roughnetUser, rootChainManager, erc20Predicate, checkpointExitData } = context;
  const amount = ethers.parseEther('5');

  await waitTx(rootToken.connect(sepoliaUser).mint(amount));
  await waitTokenBalance(rootToken, sepoliaUser.address, amount, `${label} root mint visibility`);
  const rootBefore = await rootToken.balanceOf(sepoliaUser.address);
  const childBefore = await childToken.balanceOf(roughnetUser.address);

  const predicateAddress = await erc20Predicate.getAddress();
  await waitTx(rootToken.connect(sepoliaUser).approve(predicateAddress, amount));
  await waitTokenAllowance(rootToken, sepoliaUser.address, predicateAddress, amount, `${label} allowance visibility`);
  const depositTx = await rootChainManager.connect(sepoliaUser).depositFor(
    roughnetUser.address,
    await rootToken.getAddress(),
    abi.encode(['uint256'], [amount]),
    { gasLimit: ROOT_DEPOSIT_GAS_LIMIT },
  );
  await waitForMined(depositTx);

  return {
    label,
    rootToken,
    childToken,
    amount,
    rootBefore,
    childBefore,
  };
}

async function awaitErc20Deposit(context, state) {
  const { roughnetUser } = context;
  const { label, childToken, amount, childBefore } = state;
  await waitForCondition(
    async () => {
      const balance = await childToken.balanceOf(roughnetUser.address);
      return balance === childBefore + amount ? balance : null;
    },
    `${label} child mint`,
    BRIDGE_WAIT_TIMEOUT_MS,
    5000,
  );

}

async function exitErc20Deposit(context, state) {
  const { sepoliaUser, roughnetUser, rootChainManager, checkpointExitData } = context;
  const { label, rootToken, childToken, amount, rootBefore } = state;
  const withdrawTx = await childToken.connect(roughnetUser).withdraw(amount);
  const withdrawReceipt = await waitForMined(withdrawTx);
  const logIndex = findLogIndex(withdrawReceipt, await childToken.getAddress());
  const exitData = await checkpointExitData(withdrawReceipt.hash, logIndex);

  await waitTx(rootChainManager.connect(sepoliaUser).exit(exitData, { gasLimit: ROOT_EXIT_GAS_LIMIT }));
  const rootAfter = await rootToken.balanceOf(sepoliaUser.address);
  assertEq(rootAfter.toString(), rootBefore.toString(), `${label} root balance restored`);
}

async function submitWrappedGiltDeposit(context) {
  const {
    deployer,
    sepoliaUser,
    roughnetProvider,
    rootChainManager,
    wrappedGiltPredicate,
    wrappedGilt,
  } = context;

  const amount = ethers.parseEther('7');
  await waitTx(wrappedGilt.connect(deployer).mint(sepoliaUser.address, amount));
  await waitTokenBalance(wrappedGilt, sepoliaUser.address, amount, 'wrapped GILT mint visibility');

  const rootBefore = await wrappedGilt.balanceOf(sepoliaUser.address);
  const childBefore = await roughnetProvider.getBalance(sepoliaUser.address);

  const predicateAddress = await wrappedGiltPredicate.getAddress();
  await waitTx(wrappedGilt.connect(sepoliaUser).approve(predicateAddress, amount));
  await waitTokenAllowance(wrappedGilt, sepoliaUser.address, predicateAddress, amount, 'wrapped GILT allowance visibility');
  const depositTx = await rootChainManager.connect(sepoliaUser).depositFor(
    sepoliaUser.address,
    await wrappedGilt.getAddress(),
    abi.encode(['uint256'], [amount]),
    { gasLimit: ROOT_DEPOSIT_GAS_LIMIT },
  );
  await waitForMined(depositTx);

  return {
    amount,
    rootBefore,
    childBefore,
  };
}

async function awaitWrappedGiltDeposit(context, state) {
  const { sepoliaUser, roughnetProvider, wrappedGilt } = context;
  const { amount, rootBefore, childBefore } = state;
  await waitForCondition(
    async () => {
      const balance = await roughnetProvider.getBalance(sepoliaUser.address);
      return balance === childBefore + amount ? balance : null;
    },
    'native GILT credit',
    BRIDGE_WAIT_TIMEOUT_MS,
    5000,
  );

  const rootAfter = await wrappedGilt.balanceOf(sepoliaUser.address);
  assertEq(rootAfter.toString(), (rootBefore - amount).toString(), 'wrapped GILT burned on deposit');
}

async function exitWrappedGiltDeposit(context, state) {
  const {
    sepoliaUser,
    roughnetUser,
    roughnetProvider,
    rootChainManager,
    wrappedGilt,
    nativeGiltBridge,
    checkpointExitData,
  } = context;
  const { amount } = state;

  const childBefore = await roughnetProvider.getBalance(roughnetUser.address);
  const rootBefore = await wrappedGilt.balanceOf(sepoliaUser.address);

  const withdrawTx = await nativeGiltBridge.connect(roughnetUser).withdraw(amount);
  const withdrawReceipt = await waitForMined(withdrawTx);
  const childAfter = await roughnetProvider.getBalance(roughnetUser.address);
  const gas = feePaid(withdrawReceipt);
  assertEq((childAfter + gas).toString(), (childBefore - amount).toString(), 'native GILT burned on withdraw');

  const logIndex = findLogIndex(withdrawReceipt, NATIVE_GILT_BRIDGE_ADDRESS);
  const exitData = await checkpointExitData(withdrawReceipt.hash, logIndex);
  await waitTx(rootChainManager.connect(sepoliaUser).exit(exitData, { gasLimit: ROOT_EXIT_GAS_LIMIT }));

  const rootAfter = await wrappedGilt.balanceOf(sepoliaUser.address);
  assertEq(rootAfter.toString(), (rootBefore + amount).toString(), 'wrapped GILT minted on exit');
}

async function submitNativeEthDeposit(context) {
  const { sepoliaUser, rootChainManager, childWeth, roughnetUser, roughnetProvider, checkpointExitData } = context;

  const amount = ethers.parseEther('0.002');
  const ethBefore = await sepoliaUser.provider.getBalance(sepoliaUser.address);
  const childBefore = await childWeth.balanceOf(roughnetUser.address);

  const depositTx = await rootChainManager.connect(sepoliaUser).depositEtherFor(roughnetUser.address, {
    value: amount,
    gasLimit: ROOT_DEPOSIT_GAS_LIMIT,
  });
  const depositReceipt = await waitForMined(depositTx);
  const depositFee = feePaid(depositReceipt);

  return {
    amount,
    ethBefore,
    depositFee,
    childBefore,
  };
}

async function awaitNativeEthDeposit(context, state) {
  const { childWeth, roughnetUser } = context;
  const { amount, childBefore } = state;
  await waitForCondition(
    async () => {
      const balance = await childWeth.balanceOf(roughnetUser.address);
      return balance === childBefore + amount ? balance : null;
    },
    'child WETH mint from raw ETH',
    BRIDGE_WAIT_TIMEOUT_MS,
    5000,
  );

}

async function exitNativeEthDeposit(context, state) {
  const { sepoliaUser, rootChainManager, childWeth, roughnetUser, checkpointExitData } = context;
  const { amount, ethBefore, depositFee } = state;
  const withdrawTx = await childWeth.connect(roughnetUser).withdraw(amount);
  const withdrawReceipt = await waitForMined(withdrawTx);
  const logIndex = findLogIndex(withdrawReceipt, await childWeth.getAddress());
  const exitData = await checkpointExitData(withdrawReceipt.hash, logIndex);

  const exitTx = await rootChainManager.connect(sepoliaUser).exit(exitData, { gasLimit: ROOT_EXIT_GAS_LIMIT });
  const exitReceipt = await waitForMined(exitTx);
  const exitFee = feePaid(exitReceipt);

  const ethAfter = await sepoliaUser.provider.getBalance(sepoliaUser.address);
  assertEq((ethAfter + depositFee + exitFee).toString(), ethBefore.toString(), 'raw ETH returned after exit');
}

async function main() {
  const sepoliaRpc = process.env.SEPOLIA_RPC_URL || DEFAULT_SEPOLIA_RPC;
  const roughnetRpc = process.env.CHILD_RPC_URL || process.env.ROUGHNET_RPC_URL || 'http://127.0.0.1:8545';
  const giltconsensusUrl = process.env.GILTCONSENSUS_URL || DEFAULT_GILTCONSENSUS_URL;
  const validatorKeyPath = path.join(liveChainDir, 'validator-ecdsa.key');
  const rawPrivateKey =
    process.env.PRIVATE_KEY || fs.readFileSync(validatorKeyPath, 'utf8').trim();
  const deployerKey = rawPrivateKey.startsWith('0x') ? rawPrivateKey : `0x${rawPrivateKey}`;

  const addressBook = loadAddressBook();
  const roughnetWallets = readJson(walletFile);

  const sepoliaProvider = rpcProviderFor(sepoliaRpc);
  const roughnetProvider = rpcProviderFor(roughnetRpc);
  const deployer = new ethers.Wallet(deployerKey, sepoliaProvider);
  const sepoliaUser = new ethers.Wallet(roughnetWallets[1].private_key, sepoliaProvider);
  const roughnetUser = new ethers.Wallet(roughnetWallets[1].private_key, roughnetProvider);

  const rootChainManager = contractAt(addressBook.root.rootChainManager, portalArtifacts.rootChainManager, deployer);
  const childChainManager = contractAt(addressBook.child.childChainManager, portalArtifacts.childChainManager, roughnetProvider);
  const rootChain = contractAt(addressBook.root.rootChain, rootArtifacts(), deployer);
  const erc20Predicate = contractAt(addressBook.root.erc20Predicate, portalArtifacts.erc20Predicate, deployer);
  const etherPredicate = contractAt(addressBook.root.etherPredicate, portalArtifacts.etherPredicate, deployer);
  const wrappedGiltPredicate = contractAt(addressBook.root.wrappedGiltPredicate, portalArtifacts.wrappedGiltPredicate, deployer);
  const scaledErc1155Predicate = contractAt(
    addressBook.root.scaledErc1155Predicate,
    portalArtifacts.scaledErc1155Predicate,
    deployer,
  );
  const wrappedGilt = contractAt(addressBook.root.wrappedGilt, portalArtifacts.wrappedGilt, deployer);
  const rootPaxg = contractAt(addressBook.root.paxg, portalArtifacts.dummyErc20, deployer);
  const rootXaut = contractAt(addressBook.root.xaut, portalArtifacts.dummyErc20, deployer);
  const rootUsdc = contractAt(addressBook.root.usdc, portalArtifacts.dummyErc20, deployer);
  const rootUsdt = contractAt(addressBook.root.usdt, portalArtifacts.dummyErc20, deployer);
  const childGold = contractAt(addressBook.child.gold, chainArtifacts.physicalGold1155, roughnetProvider);
  const childUsdc = contractAt(addressBook.child.usdc, portalArtifacts.childErc20, roughnetProvider);
  const childUsdt = contractAt(addressBook.child.usdt, portalArtifacts.childErc20, roughnetProvider);
  const childWeth = contractAt(addressBook.child.weth, portalArtifacts.giltWeth, roughnetProvider);
  const nativeGiltBridge = contractAt(NATIVE_GILT_BRIDGE_ADDRESS, chainArtifacts.nativeGiltBridge, roughnetUser);
  const rootStateSender = new ethers.Contract(addressBook.root.stateSender, stateSenderAbi, sepoliaProvider);
  const childStateReceiver = new ethers.Contract(STATE_RECEIVER_ADDRESS, stateReceiverAbi, roughnetProvider);

  const childWeb3 = childRpcFor(roughnetProvider);
  const checkpointExitData = createCheckpointBuilder({
    rootChain,
    proposerPrivateKey: deployer.privateKey,
    proposerAddress: deployer.address,
    childWeb3,
    roughnetProvider,
    addressBook,
  });

  await waitForRpc(sepoliaProvider, 'Sepolia');
  await waitForRpc(roughnetProvider, 'child chain');
  await ensureSepoliaEth(deployer, sepoliaUser);

  const rootPaxgAddress = await rootPaxg.getAddress();
  const rootXautAddress = await rootXaut.getAddress();
  const rootUsdcAddress = await rootUsdc.getAddress();
  const rootUsdtAddress = await rootUsdt.getAddress();
  const wrappedGiltAddress = await wrappedGilt.getAddress();
  const childGoldAddress = await childGold.getAddress();
  const childUsdcAddress = await childUsdc.getAddress();
  const childUsdtAddress = await childUsdt.getAddress();
  const childWethAddress = await childWeth.getAddress();

  console.log('Waiting for bridge catch-up before starting a fresh live run');
  const preRunProgress = await waitForBridgeCatchup(rootStateSender, childStateReceiver, giltconsensusUrl);
  console.log(
    `Bridge ready at root=${preRunProgress.rootStateId.toString()} giltconsensus=${preRunProgress.giltconsensusRecordCount.toString()} child=${preRunProgress.childStateId.toString()}`,
  );

  console.log('Verifying root and child mappings without mutating live bridge state');
  await Promise.all([
    assertRouteMapping(rootChainManager, childChainManager, rootPaxgAddress, childGoldAddress, 'PAXG'),
    assertRouteMapping(rootChainManager, childChainManager, rootXautAddress, childGoldAddress, 'XAUT'),
    assertRouteMapping(rootChainManager, childChainManager, rootUsdcAddress, childUsdcAddress, 'USDC'),
    assertRouteMapping(rootChainManager, childChainManager, rootUsdtAddress, childUsdtAddress, 'USDT'),
    assertRouteMapping(rootChainManager, childChainManager, ROOT_ETHER_ADDRESS, childWethAddress, 'raw ETH'),
    assertRouteMapping(rootChainManager, childChainManager, wrappedGiltAddress, NATIVE_GILT_BRIDGE_ADDRESS, 'GILT'),
  ]);

  const context = {
    deployer,
    sepoliaUser,
    roughnetUser,
    sepoliaProvider,
    roughnetProvider,
    rootChainManager,
    erc20Predicate,
    etherPredicate,
    wrappedGiltPredicate,
    scaledErc1155Predicate,
    wrappedGilt,
    rootPaxg,
    rootXaut,
    rootUsdc,
    rootUsdt,
    childGold,
    childUsdc,
    childUsdt,
    childWeth,
    nativeGiltBridge,
    checkpointExitData,
  };

  console.log('Submitting Sepolia -> child-chain deposits for all routes');
  const pendingPaxg = await submitGoldDeposit(context, 'PAXG');
  const pendingXaut = await submitGoldDeposit(context, 'XAUT');
  const pendingUsdc = await submitErc20Deposit(context, 'USDC', rootUsdc, childUsdc);
  const pendingUsdt = await submitErc20Deposit(context, 'USDT', rootUsdt, childUsdt);
  const pendingGilt = await submitWrappedGiltDeposit(context);
  const pendingEth = await submitNativeEthDeposit(context);

  console.log('Waiting for child-chain arrivals on all routes');
  await awaitGoldDeposit(context, pendingPaxg);
  await awaitGoldDeposit(context, pendingXaut);
  await awaitErc20Deposit(context, pendingUsdc);
  await awaitErc20Deposit(context, pendingUsdt);
  await awaitWrappedGiltDeposit(context, pendingGilt);
  await awaitNativeEthDeposit(context, pendingEth);

  console.log('Exiting child-chain -> Sepolia for PAXG');
  await exitGoldDeposit(context, pendingPaxg);

  console.log('Exiting child-chain -> Sepolia for XAUT');
  await exitGoldDeposit(context, pendingXaut);

  console.log('Exiting child-chain -> Sepolia for USDC');
  await exitErc20Deposit(context, pendingUsdc);

  console.log('Exiting child-chain -> Sepolia for USDT');
  await exitErc20Deposit(context, pendingUsdt);

  console.log('Exiting child-chain -> Sepolia for GILT');
  await exitWrappedGiltDeposit(context, pendingGilt);

  console.log('Exiting child-chain -> Sepolia for raw ETH');
  await exitNativeEthDeposit(context, pendingEth);

  addressBook.testRun = {
    completedAt: new Date().toISOString(),
    testedBy: sepoliaUser.address,
    routes: {
      paxgGold: 'passed',
      xautGold: 'passed',
      usdc: 'passed',
      usdt: 'passed',
      gilt: 'passed',
      rawEth: 'passed',
    },
  };
  saveAddressBook(addressBook);

  console.log('All live bridge routes passed');
}

function rootArtifacts() {
  return readArtifact('bridge/pos-contracts/artifacts/contracts/root/RootChain.sol/RootChain.json');
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
