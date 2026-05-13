const fs = require('fs');
const path = require('path');
const { execFileSync } = require('child_process');
const { ethers } = require('ethers');

const STAKE_HUB = '0x0000000000000000000000000000000000002002';
const GOV_HUB = '0x0000000000000000000000000000000000001007';
const GOVERNOR = '0x0000000000000000000000000000000000002004';
const GOV_TOKEN = '0x0000000000000000000000000000000000002005';
const TIMELOCK = '0x0000000000000000000000000000000000002006';

const provider = new ethers.JsonRpcProvider(process.env.RPC_URL || 'http://127.0.0.1:8545');
const walletFile = process.env.WALLETS_FILE || path.resolve(__dirname, '../../.roughnet-wallets/evm-wallets.json');
const walletsData = JSON.parse(fs.readFileSync(walletFile, 'utf8'));

const blockProducerWallet = new ethers.Wallet(walletsData[0].private_key, provider);
const governanceWallet = new ethers.Wallet(walletsData[1].private_key, provider);
const tokenOwnerWallet = new ethers.Wallet(walletsData[2].private_key, provider);
const delegatorWallet = new ethers.Wallet(walletsData[3].private_key, provider);
const legacyUnbondWallet = new ethers.Wallet(walletsData[4].private_key, provider);
const validatorWallet = blockProducerWallet;

const validatorAddress = validatorWallet.address;
const blsPubkey =
  process.env.BLS_PUBKEY ||
  '0x82106fca090df4d75d8a0e40e71fe47619ce9a9d5425063e734e40dca8a1f536443ea556a68e715496c8753c1be83f02';
const blsDatadir = process.env.BLS_DATADIR || path.resolve(__dirname, '../../.live-roughnet/validator1/bls');
const blsPassword = process.env.BLS_PASSWORD_FILE || path.resolve(__dirname, '../../.live-roughnet/bls-pass.txt');
const gethBinary = process.env.GETH_BINARY || path.resolve(__dirname, '../../.tmp/geth');

function loadCanonicalAbi(fileName) {
  return JSON.parse(
    fs.readFileSync(path.resolve(__dirname, '../abi', fileName), 'utf8'),
  );
}

const stakeHubAbi = loadCanonicalAbi('stakehub.abi');
const govHubAbi = loadCanonicalAbi('govhub.abi');
const governorAbi = loadCanonicalAbi('giltgovernor.abi');
const govTokenAbi = loadCanonicalAbi('govtoken.abi');

const erc1155Abi = [
  'function PAXG_TOKEN_ID() view returns (uint256)',
  'function XAUT_TOKEN_ID() view returns (uint256)',
  'function setBridgeDepositor(address newBridgeDepositor)',
  'function deposit(address account, bytes depositData)',
  'function setMigrationController(address newMigrationController)',
  'function setApprovalForAll(address operator, bool approved)',
  'function balanceOf(address account, uint256 id) view returns (uint256)',
];

const physicalGoldArtifact = require('../out/PhysicalGold1155.sol/PhysicalGold1155.json');
const migrationControllerArtifact = require('../out/GoldMigrationController.sol/GoldMigrationController.json');
const reserveVaultArtifact = require('../out/LegacyGoldReserveVault.sol/LegacyGoldReserveVault.json');

const stakeHub = new ethers.Contract(STAKE_HUB, stakeHubAbi, provider);
const govHub = new ethers.Contract(GOV_HUB, govHubAbi, provider);
const governor = new ethers.Contract(GOVERNOR, governorAbi, provider);
const govToken = new ethers.Contract(GOV_TOKEN, govTokenAbi, provider);

function normalizeBytecode(bytecode) {
  return bytecode.startsWith('0x') ? bytecode : `0x${bytecode}`;
}

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function waitForTransactionReceipt(txHash, timeoutMs = 120000) {
  const startedAt = Date.now();
  while (Date.now() - startedAt < timeoutMs) {
    const receipt = await provider.getTransactionReceipt(txHash);
    if (receipt) {
      return receipt;
    }
    await sleep(1500);
  }
  throw new Error(`Timed out waiting for tx ${txHash}`);
}

async function waitForBlock(targetBlock) {
  while ((await provider.getBlockNumber()) < targetBlock) {
    await sleep(1500);
  }
}

async function waitForSeconds(seconds) {
  await sleep(seconds * 1000);
}

async function governCalls(targets, values, calldatas, description) {
  const descriptionHash = ethers.id(description);

  const proposeTx = await governor.connect(governanceWallet).propose(targets, values, calldatas, description);
  await proposeTx.wait();

  const proposalId = await governor.hashProposal(targets, values, calldatas, descriptionHash);
  const startBlock = await provider.getBlockNumber();
  await waitForBlock(startBlock + 1);

  const voteTx = await governor.connect(governanceWallet).castVote(proposalId, 1);
  await voteTx.wait();

  const deadline = await governor.proposalDeadline(proposalId);
  await waitForBlock(Number(deadline) + 1);

  const queueTx = await governor.connect(governanceWallet).queue(targets, values, calldatas, descriptionHash);
  await queueTx.wait();

  await waitForSeconds(65);

  const executeTx = await governor.connect(governanceWallet).execute(targets, values, calldatas, descriptionHash);
  await executeTx.wait();

  return proposalId;
}

async function governStakeHubUpdate(key, value, description) {
  return governCalls(
    [GOV_HUB],
    [0],
    [govHub.interface.encodeFunctionData('updateParam', [key, value, STAKE_HUB])],
    description,
  );
}

async function main() {
  const goldFactory = new ethers.ContractFactory(
    physicalGoldArtifact.abi,
    normalizeBytecode(physicalGoldArtifact.bytecode.object),
    tokenOwnerWallet,
  );
  const reserveFactory = new ethers.ContractFactory(
    reserveVaultArtifact.abi,
    normalizeBytecode(reserveVaultArtifact.bytecode.object),
    tokenOwnerWallet,
  );
  const migrationControllerFactory = new ethers.ContractFactory(
    migrationControllerArtifact.abi,
    normalizeBytecode(migrationControllerArtifact.bytecode.object),
    tokenOwnerWallet,
  );

  console.error('deploying gold contracts');
  const oldGold = await goldFactory.deploy('ipfs://legacy/{id}.json', 1000, 1, TIMELOCK);
  await oldGold.waitForDeployment();
  const newGold = await goldFactory.deploy('ipfs://gold/{id}.json', 1000, 1, TIMELOCK);
  await newGold.waitForDeployment();
  const reserveVault = await reserveFactory.deploy();
  await reserveVault.waitForDeployment();
  const migrationController = await migrationControllerFactory.deploy();
  await migrationController.waitForDeployment();

  const oldGoldToken = new ethers.Contract(await oldGold.getAddress(), erc1155Abi, tokenOwnerWallet);
  const newGoldToken = new ethers.Contract(await newGold.getAddress(), erc1155Abi, tokenOwnerWallet);
  const migrationControllerContract = new ethers.Contract(
    await migrationController.getAddress(),
    migrationControllerArtifact.abi,
    tokenOwnerWallet,
  );
  const paxgTokenId = await oldGoldToken.PAXG_TOKEN_ID();
  const xautTokenId = await oldGoldToken.XAUT_TOKEN_ID();

  console.error('creating live stakehub validator');
  const lockAmount = await stakeHub.LOCK_AMOUNT();
  const validatorProofOutput = execFileSync(
    gethBinary,
    [
      'bls',
      'account',
      'generate-proof',
      '--chain-id',
      '714',
      '--blspassword',
      blsPassword,
      '--datadir',
      blsDatadir,
      validatorAddress,
      blsPubkey,
    ],
    { encoding: 'utf8' },
  );
  const validatorProof = validatorProofOutput.trim().split('Proof: ')[1].trim();
  const commission = { rate: 10, maxRate: 100, maxChangeRate: 5 };
  const description = {
    moniker: 'Rough1',
    identity: validatorAddress,
    website: 'https://roughnet.gold',
    details: 'live roughnet gold validator',
  };

  const createValidatorData = stakeHub.interface.encodeFunctionData('createValidator', [
    validatorAddress,
    blsPubkey,
    validatorProof,
    commission,
    description,
  ]);
  const createValidatorTx = await validatorWallet.sendTransaction({
    to: STAKE_HUB,
    data: createValidatorData,
    value: ethers.parseEther('2000') + lockAmount,
    gasLimit: 3_000_000,
    nonce: await provider.getTransactionCount(validatorAddress, 'pending'),
    gasPrice: await provider.getFeeData().then((f) => f.gasPrice ?? ethers.parseUnits('1', 'gwei')),
  });
  const createValidatorReceipt = await waitForTransactionReceipt(createValidatorTx.hash);
  if (createValidatorReceipt.status !== 1 && createValidatorReceipt.status !== 1n) {
    throw new Error(`createValidator failed: ${createValidatorTx.hash}`);
  }

  console.error('staking gilt for governance');
  const stakeAmount = ethers.parseEther('10000000');
  const nativeStakeTx = await stakeHub.connect(governanceWallet).delegate(validatorAddress, false, {
    value: stakeAmount,
    gasLimit: 1_500_000,
  });
  await nativeStakeTx.wait();

  console.error('self-delegating governance votes');
  const selfDelegateTx = await govToken.connect(governanceWallet).delegate(governanceWallet.address);
  await selfDelegateTx.wait();

  console.error('governance: set legacy gold');
  await governStakeHubUpdate('stakeTokenB', ethers.getBytes(await oldGold.getAddress()), 'Set legacy GOLD');

  console.error('governance: set bootstrap bridge depositor for legacy gold');
  await governCalls(
    [await oldGold.getAddress()],
    [0],
    [oldGoldToken.interface.encodeFunctionData('setBridgeDepositor', [tokenOwnerWallet.address])],
    'Set legacy GOLD bridge depositor for bootstrap deposits',
  );

  const oldGoldScaleNumerator = 1000n;
  const legacyDeposit = (account, tokenId, childAmount) =>
    oldGoldToken.deposit(
      account,
      ethers.AbiCoder.defaultAbiCoder().encode(['uint256', 'uint256'], [tokenId, childAmount / oldGoldScaleNumerator]),
    );

  console.error('seeding legacy gold via bridge deposit path');
  await (await legacyDeposit(delegatorWallet.address, paxgTokenId, ethers.parseEther('100'))).wait();
  await (await legacyDeposit(legacyUnbondWallet.address, paxgTokenId, ethers.parseEther('150'))).wait();
  await (await legacyDeposit(legacyUnbondWallet.address, xautTokenId, ethers.parseEther('50'))).wait();

  const oldGoldAsDelegator = new ethers.Contract(await oldGold.getAddress(), erc1155Abi, delegatorWallet);
  const oldGoldAsLegacyUnbond = new ethers.Contract(await oldGold.getAddress(), erc1155Abi, legacyUnbondWallet);

  console.error('staking old gold');
  await (await oldGoldAsDelegator.setApprovalForAll(STAKE_HUB, true)).wait();
  await (
    await stakeHub.connect(delegatorWallet).delegateTokenB1155(validatorAddress, paxgTokenId, ethers.parseEther('100'))
  ).wait();

  console.error('creating legacy unbond position');
  await (await oldGoldAsLegacyUnbond.setApprovalForAll(STAKE_HUB, true)).wait();
  await (
    await stakeHub
      .connect(legacyUnbondWallet)
      .delegateTokenB1155(validatorAddress, paxgTokenId, ethers.parseEther('150'))
  ).wait();
  await (
    await stakeHub
      .connect(legacyUnbondWallet)
      .delegateTokenB1155(validatorAddress, xautTokenId, ethers.parseEther('50'))
  ).wait();
  await (
    await stakeHub
      .connect(legacyUnbondWallet)
      .undelegateTokenB1155(validatorAddress, xautTokenId, ethers.parseEther('50'))
  ).wait();

  const beforeElection = await stakeHub.getValidatorElectionInfo(0, 0);
  const powerBeforeRatio = beforeElection[1][0];

  console.error('governance: enable ratio');
  await governStakeHubUpdate('ratioEnabled', '0x01', 'Enable live gold ratio enforcement');

  const afterElection = await stakeHub.getValidatorElectionInfo(0, 0);
  const powerAfterRatio = afterElection[1][0];

  const migrationControllerAddress = await migrationController.getAddress();
  console.error('governance: set migration controller');
  await governStakeHubUpdate(
    'tokenBMigrationController',
    ethers.getBytes(migrationControllerAddress),
    'Set stake token-B migration controller',
  );

  console.error('governance: bind migration controller as new gold migration minter');
  await governCalls(
    [await newGold.getAddress()],
    [0],
    [newGoldToken.interface.encodeFunctionData('setMigrationController', [migrationControllerAddress])],
    'Bind migration controller as new GOLD migration controller',
  );

  console.error('governance: prepare and activate migration controller');
  await governCalls(
    [migrationControllerAddress, migrationControllerAddress],
    [0, 0],
    [
      migrationControllerContract.interface.encodeFunctionData('activatePrepare', [
        await oldGold.getAddress(),
        await newGold.getAddress(),
        await reserveVault.getAddress(),
        STAKE_HUB,
      ]),
      migrationControllerContract.interface.encodeFunctionData('activateMigration', []),
    ],
    'Prepare and activate GOLD migration controller',
  );

  console.error('governance: activate stake token-B cutover');
  const activateCutoverValue = ethers.AbiCoder.defaultAbiCoder().encode(
    ['address', 'address'],
    [await newGold.getAddress(), await reserveVault.getAddress()],
  );
  await governStakeHubUpdate('activateTokenBMigration', activateCutoverValue, 'Activate stake token-B migration');

  console.error('post-cutover undelegate and live claims');
  await (
    await stakeHub.connect(delegatorWallet).undelegateTokenB1155(validatorAddress, paxgTokenId, ethers.parseEther('40'))
  ).wait();

  const unbondPeriod = Number(await stakeHub.unbondPeriod());
  await waitForSeconds(unbondPeriod + 5);

  const newGoldAsDelegator = new ethers.Contract(await newGold.getAddress(), erc1155Abi, delegatorWallet);
  const oldGoldAsLegacyClaimer = new ethers.Contract(await oldGold.getAddress(), erc1155Abi, legacyUnbondWallet);

  const newGoldBeforeClaim = await newGoldAsDelegator.balanceOf(delegatorWallet.address, paxgTokenId);
  await (await stakeHub.connect(delegatorWallet).claimTokenB(validatorAddress, 0)).wait();
  const newGoldAfterClaim = await newGoldAsDelegator.balanceOf(delegatorWallet.address, paxgTokenId);

  const oldGoldBeforeClaim = await oldGoldAsLegacyClaimer.balanceOf(legacyUnbondWallet.address, xautTokenId);
  await (await stakeHub.connect(legacyUnbondWallet).claimTokenB(validatorAddress, 0)).wait();
  const oldGoldAfterClaim = await oldGoldAsLegacyClaimer.balanceOf(legacyUnbondWallet.address, xautTokenId);

  const reserveOldPaxg = await oldGoldToken.balanceOf(await reserveVault.getAddress(), paxgTokenId);
  const reserveOldXaut = await oldGoldToken.balanceOf(await reserveVault.getAddress(), xautTokenId);

  console.log(
    JSON.stringify(
      {
        oldGold: await oldGold.getAddress(),
        newGold: await newGold.getAddress(),
        reserveVault: await reserveVault.getAddress(),
        blockProducer: blockProducerWallet.address,
        validatorOperator: validatorAddress,
        govVotes: (await govToken.getVotes(governanceWallet.address)).toString(),
        govSupply: (await govToken.totalSupply()).toString(),
        stakeTokenB: await stakeHub.stakeTokenB(),
        legacyStakeTokenB: await stakeHub.legacyStakeTokenB(),
        tokenBCutoverVersion: (await stakeHub.tokenBCutoverVersion()).toString(),
        tokenBMigrationController: await stakeHub.tokenBMigrationController(),
        ratioEnabled: await stakeHub.ratioEnabled(),
        powerBeforeRatio: powerBeforeRatio.toString(),
        powerAfterRatio: powerAfterRatio.toString(),
        migrationLifecycleState: Number(await migrationControllerContract.lifecycleState()),
        migrationPaused: await migrationControllerContract.migrationPaused(),
        migrationCapturedPaxg: (await migrationControllerContract.legacyCapturedById(paxgTokenId)).toString(),
        migrationCapturedXaut: (await migrationControllerContract.legacyCapturedById(xautTokenId)).toString(),
        migrationMintedPaxg: (await migrationControllerContract.finalMintedById(paxgTokenId)).toString(),
        migrationMintedXaut: (await migrationControllerContract.finalMintedById(xautTokenId)).toString(),
        delegatorRemainingStake: (await stakeHub.getDelegatedTokenB(validatorAddress, delegatorWallet.address)).toString(),
        delegatorRemainingPaxgStake: (
          await stakeHub.getDelegatedTokenBById(validatorAddress, delegatorWallet.address, paxgTokenId)
        ).toString(),
        delegatorLegacyStake: (await stakeHub.getLegacyDelegatedTokenB(validatorAddress, delegatorWallet.address)).toString(),
        legacyUnbondWalletLegacyXautStake: (
          await stakeHub.getLegacyDelegatedTokenBById(validatorAddress, legacyUnbondWallet.address, xautTokenId)
        ).toString(),
        newGoldClaimed: (newGoldAfterClaim - newGoldBeforeClaim).toString(),
        legacyOldGoldClaimed: (oldGoldAfterClaim - oldGoldBeforeClaim).toString(),
        reserveOldPaxg: reserveOldPaxg.toString(),
        reserveOldXaut: reserveOldXaut.toString(),
      },
      null,
      2,
    ),
  );
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
