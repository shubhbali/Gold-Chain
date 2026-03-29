import fs from 'fs';
import path from 'path';
import { execFileSync } from 'child_process';
import { ethers } from 'ethers';
import {
  ADDRESS_BOOK_PATH,
  DEFAULT_SEPOLIA_RPC,
  GOV_HUB_ADDRESS,
  GOVERNOR_ADDRESS,
  GOV_TOKEN_ADDRESS,
  NATIVE_GILT_BRIDGE_ADDRESS,
  REPO_ROOT,
  STATE_RECEIVER_ADDRESS,
  STAKE_HUB_ADDRESS,
  ZERO_ADDRESS,
  deployContract,
  hexAddressBytes,
  loadAddressBook,
  publicKeyBytes,
  rpcProviderFor,
  readArtifact,
  readJson,
  role,
  saveAddressBook,
  sleep,
  waitForMined,
} from './live-bridge-common.mjs';

const walletFile = path.join(REPO_ROOT, '.roughnet-wallets', 'evm-wallets.json');
const heimdallGenesisPath = path.join(REPO_ROOT, '.heimdall-localnet', 'node0', 'heimdalld', 'config', 'genesis.json');
const blsDatadir = path.join(REPO_ROOT, '.live-roughnet', 'validator1', 'bls');
const blsPassword = path.join(REPO_ROOT, '.live-roughnet', 'bls-pass.txt');
const gethBinary = path.join(REPO_ROOT, '.tmp', 'geth');
const blsPubkey =
  process.env.BLS_PUBKEY ||
  '0x82106fca090df4d75d8a0e40e71fe47619ce9a9d5425063e734e40dca8a1f536443ea556a68e715496c8753c1be83f02';

const rootArtifacts = {
  governance: readArtifact('bridge/pos-contracts/artifacts/contracts/common/governance/Governance.sol/Governance.json'),
  governanceProxy: readArtifact('bridge/pos-contracts/artifacts/contracts/common/governance/GovernanceProxy.sol/GovernanceProxy.json'),
  registry: readArtifact('bridge/pos-contracts/artifacts/contracts/common/Registry.sol/Registry.json'),
  eventsHub: readArtifact('bridge/pos-contracts/artifacts/contracts/staking/EventsHub.sol/EventsHub.json'),
  eventsHubProxy: readArtifact('bridge/pos-contracts/artifacts/contracts/staking/EventsHubProxy.sol/EventsHubProxy.json'),
  validatorShareFactory: readArtifact(
    'bridge/pos-contracts/artifacts/contracts/staking/validatorShare/ValidatorShareFactory.sol/ValidatorShareFactory.json',
  ),
  validatorShareTest: readArtifact('bridge/pos-contracts/artifacts/contracts/test/ValidatorShareTest.sol/ValidatorShareTest.json'),
  stakeToken: readArtifact('bridge/pos-contracts/artifacts/contracts/common/tokens/TestToken.sol/TestToken.json'),
  polToken: readArtifact('bridge/pos-contracts/artifacts/contracts/common/tokens/ERC20Permit.sol/ERC20Permit.json'),
  polygonMigration: readArtifact(
    'bridge/pos-contracts/artifacts/contracts/common/misc/PolygonMigration.sol/PolygonMigration.json',
  ),
  stakingInfo: readArtifact('bridge/pos-contracts/artifacts/contracts/staking/StakingInfo.sol/StakingInfo.json'),
  stakingNFT: readArtifact(
    'bridge/pos-contracts/artifacts/contracts/staking/stakeManager/StakingNFT.sol/StakingNFT.json',
  ),
  rootChain: readArtifact('bridge/pos-contracts/artifacts/contracts/root/RootChain.sol/RootChain.json'),
  rootChainProxy: readArtifact('bridge/pos-contracts/artifacts/contracts/root/RootChainProxy.sol/RootChainProxy.json'),
  stakeManagerTestable: readArtifact(
    'bridge/pos-contracts/artifacts/contracts/test/StakeManagerTestable.sol/StakeManagerTestable.json',
  ),
  stakeManagerProxy: readArtifact(
    'bridge/pos-contracts/artifacts/contracts/staking/stakeManager/StakeManagerProxy.sol/StakeManagerProxy.json',
  ),
  stakeManagerExtension: readArtifact(
    'bridge/pos-contracts/artifacts/contracts/staking/stakeManager/StakeManagerExtension.sol/StakeManagerExtension.json',
  ),
};

const portalArtifacts = {
  rootChainManager: readArtifact(
    'bridge/pos-portal/artifacts/contracts/root/RootChainManager/RootChainManager.sol/RootChainManager.json',
  ),
  rootChainManagerProxy: readArtifact(
    'bridge/pos-portal/artifacts/contracts/root/RootChainManager/RootChainManagerProxy.sol/RootChainManagerProxy.json',
  ),
  stateSender: readArtifact(
    'bridge/pos-portal/artifacts/contracts/root/StateSender/StateSender.sol/StateSender.json',
  ),
  erc20Predicate: readArtifact(
    'bridge/pos-portal/artifacts/contracts/root/TokenPredicates/ERC20Predicate.sol/ERC20Predicate.json',
  ),
  erc20PredicateProxy: readArtifact(
    'bridge/pos-portal/artifacts/contracts/root/TokenPredicates/ERC20PredicateProxy.sol/ERC20PredicateProxy.json',
  ),
  etherPredicate: readArtifact(
    'bridge/pos-portal/artifacts/contracts/root/TokenPredicates/EtherPredicate.sol/EtherPredicate.json',
  ),
  etherPredicateProxy: readArtifact(
    'bridge/pos-portal/artifacts/contracts/root/TokenPredicates/EtherPredicateProxy.sol/EtherPredicateProxy.json',
  ),
  wrappedGiltPredicate: readArtifact(
    'bridge/pos-portal/artifacts/contracts/root/TokenPredicates/WrappedGiltPredicate.sol/WrappedGiltPredicate.json',
  ),
  wrappedGiltPredicateProxy: readArtifact(
    'bridge/pos-portal/artifacts/contracts/root/TokenPredicates/WrappedGiltPredicateProxy.sol/WrappedGiltPredicateProxy.json',
  ),
  scaledErc1155Predicate: readArtifact(
    'bridge/pos-portal/artifacts/contracts/root/TokenPredicates/ScaledERC1155Predicate.sol/ScaledERC1155Predicate.json',
  ),
  scaledErc1155PredicateProxy: readArtifact(
    'bridge/pos-portal/artifacts/contracts/root/TokenPredicates/ScaledERC1155PredicateProxy.sol/ScaledERC1155PredicateProxy.json',
  ),
  wrappedGilt: readArtifact('bridge/pos-portal/artifacts/contracts/root/RootToken/WrappedGilt.sol/WrappedGilt.json'),
  dummyErc20: readArtifact('bridge/pos-portal/artifacts/contracts/root/RootToken/DummyERC20.sol/DummyERC20.json'),
  childChainManager: readArtifact(
    'bridge/pos-portal/artifacts/contracts/child/ChildChainManager/ChildChainManager.sol/ChildChainManager.json',
  ),
  childChainManagerProxy: readArtifact(
    'bridge/pos-portal/artifacts/contracts/child/ChildChainManager/ChildChainManagerProxy.sol/ChildChainManagerProxy.json',
  ),
  childErc20: readArtifact('bridge/pos-portal/artifacts/contracts/child/ChildToken/ChildERC20.sol/ChildERC20.json'),
  maticWeth: readArtifact('bridge/pos-portal/artifacts/contracts/child/ChildToken/MaticWETH.sol/MaticWETH.json'),
};

const chainArtifacts = {
  physicalGold1155: readArtifact('bsc-genesis-contract/out/PhysicalGold1155.sol/PhysicalGold1155.json'),
  legacyGoldReserveVault: readArtifact('bsc-genesis-contract/out/LegacyGoldReserveVault.sol/LegacyGoldReserveVault.json'),
};

const govHubAbi = ['function updateParam(string key, bytes value, address target)'];
const governorAbi = [
  'function castVote(uint256 proposalId, uint8 support) returns (uint256)',
  'function execute(address[] targets, uint256[] values, bytes[] calldatas, bytes32 descriptionHash) payable returns (uint256)',
  'function hashProposal(address[] targets, uint256[] values, bytes[] calldatas, bytes32 descriptionHash) view returns (uint256)',
  'function proposalDeadline(uint256 proposalId) view returns (uint256)',
  'function propose(address[] targets, uint256[] values, bytes[] calldatas, string description) returns (uint256)',
  'function queue(address[] targets, uint256[] values, bytes[] calldatas, bytes32 descriptionHash) returns (uint256)',
];
const govTokenAbi = ['function delegate(address delegatee)', 'function totalSupply() view returns (uint256)'];
const stakeHubAbi = ['function stakeTokenB() view returns (address)'];
const liveStakeHubAbi = [
  'function LOCK_AMOUNT() view returns (uint256)',
  'function createValidator(address consensusAddress, bytes voteAddress, bytes blsProof, (uint64 rate, uint64 maxRate, uint64 maxChangeRate) commission, (string moniker, string identity, string website, string details) description) payable',
  'function delegate(address operatorAddress, bool delegateVotePower) payable',
  'function getValidatorElectionInfo(uint256 offset, uint256 limit) view returns (address[] memory consensusAddresses, uint256[] memory votingPowers, bytes[] memory voteAddresses, uint256 totalLength)',
  'function stakeTokenB() view returns (address)',
  'function legacyStakeTokenB() view returns (address)',
  'function legacyTokenBReserveVault() view returns (address)',
  'function activateTokenBMigration(address newStakeTokenB, address reserveVault)',
];

function contractKey(name) {
  return ethers.keccak256(ethers.toUtf8Bytes(name));
}

async function waitTx(txPromise) {
  const tx = await txPromise;
  return waitForMined(tx);
}

async function deployProxyInitialized(adminSigner, implArtifact, proxyArtifact, initArgs) {
  const impl = await deployContract(adminSigner, implArtifact);
  const proxy = await deployContract(adminSigner, proxyArtifact, [ZERO_ADDRESS]);
  const proxied = new ethers.Contract(await proxy.getAddress(), implArtifact.abi, adminSigner);
  const tx = await proxy.updateAndCall(
    await impl.getAddress(),
    proxied.interface.encodeFunctionData('initialize', initArgs),
    { gasLimit: 3_000_000 },
  );
  await waitForMined(tx);
  return proxied;
}

function artifactBytecode(artifact) {
  const bytecode = artifact?.bytecode?.object ?? artifact?.bytecode;
  if (!bytecode) {
    throw new Error('artifact is missing bytecode');
  }
  return bytecode.startsWith('0x') ? bytecode : `0x${bytecode}`;
}

async function deployContractWithNonce(signer, artifact, nonceRef, args = []) {
  const factory = new ethers.ContractFactory(artifact.abi, artifactBytecode(artifact), signer);
  const contract = await factory.deploy(...args, { nonce: nonceRef.value++ });
  await waitForMined(contract.deploymentTransaction());
  return contract;
}

async function deployProxyInitializedWithNonce(adminSigner, implArtifact, proxyArtifact, initArgs, nonceRef) {
  const impl = await deployContractWithNonce(adminSigner, implArtifact, nonceRef);
  const proxy = await deployContractWithNonce(adminSigner, proxyArtifact, nonceRef, [ZERO_ADDRESS]);
  const proxied = new ethers.Contract(await proxy.getAddress(), implArtifact.abi, adminSigner);
  const tx = await proxy.updateAndCall(
    await impl.getAddress(),
    proxied.interface.encodeFunctionData('initialize', initArgs),
    { nonce: nonceRef.value++, gasLimit: 3_000_000 },
  );
  await waitForMined(tx);
  return proxied;
}

async function deployEventsHub(adminSigner, registry) {
  const impl = await deployContract(adminSigner, rootArtifacts.eventsHub);
  const proxy = await deployContract(adminSigner, rootArtifacts.eventsHubProxy, [ZERO_ADDRESS]);
  const proxied = new ethers.Contract(await proxy.getAddress(), rootArtifacts.eventsHub.abi, adminSigner);
  const tx = await proxy.updateAndCall(await impl.getAddress(), proxied.interface.encodeFunctionData('initialize', [await registry.getAddress()]));
  await waitForMined(tx);
  return proxied;
}

async function deployStakeManager(sepoliaSigner, sepoliaWallet, governance, registry, rootChain, heimdallChainId) {
  const eventsHub = await deployEventsHub(sepoliaSigner, registry);
  const validatorShareFactory = await deployContract(sepoliaSigner, rootArtifacts.validatorShareFactory);
  const validatorShareImpl = await deployContract(sepoliaSigner, rootArtifacts.validatorShareTest);
  const stakeToken = await deployContract(sepoliaSigner, rootArtifacts.stakeToken, ['Stake Token', 'STAKE']);
  const polToken = await deployContract(sepoliaSigner, rootArtifacts.polToken, ['POL', 'POL', '1.1.0']);
  const migration = await deployContract(sepoliaSigner, rootArtifacts.polygonMigration, [
    await stakeToken.getAddress(),
    await polToken.getAddress(),
  ]);
  const stakingInfo = await deployContract(sepoliaSigner, rootArtifacts.stakingInfo, [await registry.getAddress()]);
  const stakingNFT = await deployContract(sepoliaSigner, rootArtifacts.stakingNFT, ['Matic Validator', 'MV']);
  const extension = await deployContract(sepoliaSigner, rootArtifacts.stakeManagerExtension);
  const stakeManagerImpl = await deployContract(sepoliaSigner, rootArtifacts.stakeManagerTestable);
  const stakeManagerProxy = await deployContract(sepoliaSigner, rootArtifacts.stakeManagerProxy, [ZERO_ADDRESS]);
  const stakeManager = new ethers.Contract(await stakeManagerProxy.getAddress(), rootArtifacts.stakeManagerTestable.abi, sepoliaSigner);
  const sepoliaAddress = await sepoliaSigner.getAddress();

  const initTx = await stakeManagerProxy.updateAndCall(
    await stakeManagerImpl.getAddress(),
    stakeManager.interface.encodeFunctionData('initialize', [
      await registry.getAddress(),
      await rootChain.getAddress(),
      await stakeToken.getAddress(),
      await stakingNFT.getAddress(),
      await stakingInfo.getAddress(),
      await validatorShareFactory.getAddress(),
      await governance.getAddress(),
      sepoliaAddress,
      await extension.getAddress(),
      await polToken.getAddress(),
      await migration.getAddress(),
    ]),
  );
  await waitForMined(initTx);

  await waitTx(stakingNFT.transferOwnership(await stakeManager.getAddress()));

  const governanceContract = new ethers.Contract(await governance.getAddress(), rootArtifacts.governance.abi, sepoliaSigner);
  await waitTx(
    governanceContract.update(
      await registry.getAddress(),
      registry.interface.encodeFunctionData('updateContractMap', [contractKey('eventsHub'), await eventsHub.getAddress()]),
    ),
  );
  await waitTx(
    governanceContract.update(
      await registry.getAddress(),
      registry.interface.encodeFunctionData('updateContractMap', [contractKey('stakeManager'), await stakeManager.getAddress()]),
    ),
  );
  await waitTx(
    governanceContract.update(
      await registry.getAddress(),
      registry.interface.encodeFunctionData('updateContractMap', [contractKey('validatorShare'), await validatorShareImpl.getAddress()]),
    ),
  );
  await waitTx(
    governanceContract.update(
      await registry.getAddress(),
      registry.interface.encodeFunctionData('updateContractMap', [contractKey('pol'), await polToken.getAddress()]),
    ),
  );

  await waitTx(
    governanceContract.update(
      await stakeManager.getAddress(),
      stakeManager.interface.encodeFunctionData('updateCheckPointBlockInterval', [1]),
    ),
  );

  const heimdallFee = ethers.parseEther('1');
  const stakeAmount = ethers.parseEther('200');
  await waitTx(polToken.approve(await stakeManager.getAddress(), stakeAmount + heimdallFee));
  await waitTx(
    stakeManager.stakeForPOL(
      sepoliaAddress,
      stakeAmount,
      heimdallFee,
      false,
      publicKeyBytes(sepoliaWallet.privateKey),
    ),
  );

  return {
    heimdallChainId,
    eventsHub,
    migration,
    polToken,
    stakeManager,
    stakeToken,
    stakingInfo,
    stakingNFT,
    validatorShareFactory,
    validatorShareImpl,
  };
}

async function governUpdateParam(provider, key, valueBytes, target, description, governanceWallet, fallbackProposalWallet = governanceWallet) {
  const govHub = new ethers.Contract(GOV_HUB_ADDRESS, govHubAbi, governanceWallet);
  const governor = new ethers.Contract(GOVERNOR_ADDRESS, governorAbi, provider);
  const govToken = new ethers.Contract(GOV_TOKEN_ADDRESS, govTokenAbi, governanceWallet);
  const governanceAddress = await governanceWallet.getAddress();
  const fallbackAddress = await fallbackProposalWallet.getAddress();

  const resolveLiveProposal = async (account) => {
    const latestProposalId = await governor.latestProposalIds(account);
    if (latestProposalId === 0n) {
      return null;
    }

    const proposalState = Number(await governor.state(latestProposalId));
    return {
      latestProposalId,
      proposalState,
      isLive: proposalState === 0 || proposalState === 1,
    };
  };

  let proposalWallet = governanceWallet;
  let proposalAddress = governanceAddress;
  const governanceProposal = await resolveLiveProposal(governanceAddress);
  if (governanceProposal?.isLive) {
    const fallbackProposal = await resolveLiveProposal(fallbackAddress);
    if (fallbackProposal?.isLive) {
      throw new Error(
        `No free governance proposer: ${governanceAddress} has live proposal ${governanceProposal.latestProposalId} and ${fallbackAddress} has live proposal ${fallbackProposal.latestProposalId}`,
      );
    }

    await waitTx(govToken.delegate(fallbackAddress));
    proposalWallet = fallbackProposalWallet;
    proposalAddress = fallbackAddress;
  } else {
    await waitTx(govToken.delegate(governanceAddress));
  }

  const proposalGovernor = governor.connect(proposalWallet);

  const targets = [GOV_HUB_ADDRESS];
  const values = [0];
  const calldatas = [govHub.interface.encodeFunctionData('updateParam', [key, valueBytes, target])];
  const descriptionHash = ethers.id(description);

  await waitTx(proposalGovernor.propose(targets, values, calldatas, description));
  const proposalId = await governor.hashProposal(targets, values, calldatas, descriptionHash);
  const startBlock = await provider.getBlockNumber();

  while ((await provider.getBlockNumber()) < startBlock + 1) {
    await sleep(1500);
  }

  await waitTx(proposalGovernor.castVote(proposalId, 1));
  const deadline = Number(await governor.proposalDeadline(proposalId));
  while ((await provider.getBlockNumber()) <= deadline) {
    await sleep(1500);
  }

  await waitTx(proposalGovernor.queue(targets, values, calldatas, descriptionHash));
  await sleep(65000);
  await waitTx(proposalGovernor.execute(targets, values, calldatas, descriptionHash));
}

async function ensureLiveGovernanceReadiness(provider, validatorWallet, governanceWallet) {
  const stakeHub = new ethers.Contract(STAKE_HUB_ADDRESS, liveStakeHubAbi, provider);
  const govToken = new ethers.Contract(GOV_TOKEN_ADDRESS, govTokenAbi, provider);
  const proposeThresholdSupply = ethers.parseEther('10000000');
  const validatorAddress = await validatorWallet.getAddress();
  const governanceAddress = await governanceWallet.getAddress();

  const electionInfo = await stakeHub.getValidatorElectionInfo(0, 0);
  const validatorCount = Number(electionInfo[3]);
  if (validatorCount === 0) {
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
      website: 'https://goldchain.local',
      details: 'live bridge roughnet validator',
    };

    const createValidatorTx = await validatorWallet.sendTransaction({
      to: STAKE_HUB_ADDRESS,
      data: stakeHub.interface.encodeFunctionData('createValidator', [
        validatorAddress,
        blsPubkey,
        validatorProof,
        commission,
        description,
      ]),
      value: ethers.parseEther('2000') + lockAmount,
      gasLimit: 3_000_000,
    });
    await waitForMined(createValidatorTx);
  }

  const govSupply = await govToken.totalSupply();
  if (govSupply < proposeThresholdSupply) {
    const nativeStakeTx = await stakeHub.connect(governanceWallet).delegate(validatorAddress, false, {
      value: proposeThresholdSupply,
      gasLimit: 1_500_000,
    });
    await waitForMined(nativeStakeTx);
  }

  await waitTx(govToken.connect(governanceWallet).delegate(governanceAddress));
}

async function main() {
  const sepoliaRpc = process.env.SEPOLIA_RPC_URL || DEFAULT_SEPOLIA_RPC;
  const roughnetRpc = process.env.ROUGHNET_RPC_URL || 'http://127.0.0.1:8545';
  const reuseRoot = process.env.REUSE_ROOT === '1';
  const skipStakeGoldCutover = process.env.SKIP_STAKE_GOLD === '1';
  const roughnetWallets = readJson(walletFile);
  const rawPrivateKey =
    process.env.PRIVATE_KEY || fs.readFileSync(path.join(REPO_ROOT, '.live-roughnet', 'validator-ecdsa.key'), 'utf8').trim();
  const privateKey = rawPrivateKey.startsWith('0x') ? rawPrivateKey : `0x${rawPrivateKey}`;
  const defaultRoughnetDeployerKey = roughnetWallets[2]?.private_key || roughnetWallets[1]?.private_key || rawPrivateKey;
  const rawRoughnetPrivateKey = process.env.ROUGHNET_PRIVATE_KEY || defaultRoughnetDeployerKey;
  const roughnetPrivateKey = rawRoughnetPrivateKey.startsWith('0x')
    ? rawRoughnetPrivateKey
    : `0x${rawRoughnetPrivateKey}`;

  const sepoliaProvider = rpcProviderFor(sepoliaRpc);
  const roughnetProvider = rpcProviderFor(roughnetRpc);
  const validatorWallet = new ethers.Wallet(roughnetWallets[0].private_key, roughnetProvider);
  const governanceWallet = new ethers.Wallet(roughnetWallets[1].private_key, roughnetProvider);
  const sepoliaWallet = new ethers.Wallet(privateKey, sepoliaProvider);
  const sepoliaSigner = new ethers.NonceManager(sepoliaWallet);
  const sepoliaAddress = await sepoliaSigner.getAddress();
  const roughnetSigner = new ethers.Wallet(roughnetPrivateKey, roughnetProvider);
  const roughnetSignerAddress = roughnetSigner.address;
  const roughnetNonceRef = {
    value: await roughnetProvider.getTransactionCount(roughnetSignerAddress, 'pending'),
  };

  const sepBalance = await sepoliaProvider.getBalance(sepoliaAddress);
  console.log(`Sepolia deployer ${sepoliaAddress} balance: ${ethers.formatEther(sepBalance)} ETH`);

  const heimdallGenesis = readJson(heimdallGenesisPath);
  const heimdallChainId = heimdallGenesis.chain_id;

  const existingAddressBook = reuseRoot ? loadAddressBook() : null;
  if (reuseRoot && !existingAddressBook?.root?.rootChainManager) {
    throw new Error('REUSE_ROOT=1 requires an existing live bridge address book');
  }

  console.log('Deploying roughnet child contracts');
  const childChainManager = await deployProxyInitializedWithNonce(
    roughnetSigner,
    portalArtifacts.childChainManager,
    portalArtifacts.childChainManagerProxy,
    [roughnetSignerAddress],
    roughnetNonceRef,
  );
  const childGold = await deployContractWithNonce(roughnetSigner, chainArtifacts.physicalGold1155, roughnetNonceRef, [
    'ipfs://gold/{id}.json',
  ]);
  const legacyGoldReserveVault = await deployContractWithNonce(
    roughnetSigner,
    chainArtifacts.legacyGoldReserveVault,
    roughnetNonceRef,
  );
  await waitTx(childGold.setBridgeConfig(await childChainManager.getAddress(), 1000, 1, { nonce: roughnetNonceRef.value++ }));
  const childUsdc = await deployContractWithNonce(roughnetSigner, portalArtifacts.childErc20, roughnetNonceRef, [
    'USD Coin',
    'USDC',
    18,
    await childChainManager.getAddress(),
  ]);
  const childUsdt = await deployContractWithNonce(roughnetSigner, portalArtifacts.childErc20, roughnetNonceRef, [
    'Tether USD',
    'USDT',
    18,
    await childChainManager.getAddress(),
  ]);
  const childWeth = await deployContractWithNonce(roughnetSigner, portalArtifacts.maticWeth, roughnetNonceRef, [
    await childChainManager.getAddress(),
  ]);

  const stateSyncerRole = await childChainManager.STATE_SYNCER_ROLE();
  await waitTx(childChainManager.grantRole(stateSyncerRole, STATE_RECEIVER_ADDRESS, { nonce: roughnetNonceRef.value++ }));

  let governance;
  let registry;
  let rootChain;
  let staking;
  let stateSender;
  let rootChainManager;
  let erc20Predicate;
  let etherPredicate;
  let wrappedGiltPredicate;
  let scaledErc1155Predicate;
  let wrappedGilt;
  let rootPaxg;
  let rootXaut;
  let rootUsdc;
  let rootUsdt;

  if (reuseRoot) {
    console.log('Reusing existing Sepolia root checkpoint stack');
    governance = new ethers.Contract(existingAddressBook.root.governance, rootArtifacts.governance.abi, sepoliaSigner);
    registry = new ethers.Contract(existingAddressBook.root.registry, rootArtifacts.registry.abi, sepoliaSigner);
    rootChain = new ethers.Contract(existingAddressBook.root.rootChain, rootArtifacts.rootChain.abi, sepoliaSigner);
    staking = {
      stakeManager: new ethers.Contract(existingAddressBook.root.stakeManager, rootArtifacts.stakeManagerTestable.abi, sepoliaSigner),
      stakeToken: new ethers.Contract(existingAddressBook.root.stakeToken, rootArtifacts.stakeToken.abi, sepoliaSigner),
      polToken: new ethers.Contract(existingAddressBook.root.polToken, rootArtifacts.polToken.abi, sepoliaSigner),
      stakingInfo: new ethers.Contract(existingAddressBook.root.stakingInfo, rootArtifacts.stakingInfo.abi, sepoliaSigner),
    };
    stateSender = new ethers.Contract(existingAddressBook.root.stateSender, portalArtifacts.stateSender.abi, sepoliaSigner);
    rootChainManager = new ethers.Contract(
      existingAddressBook.root.rootChainManager,
      portalArtifacts.rootChainManager.abi,
      sepoliaSigner,
    );
    erc20Predicate = new ethers.Contract(existingAddressBook.root.erc20Predicate, portalArtifacts.erc20Predicate.abi, sepoliaSigner);
    etherPredicate = new ethers.Contract(existingAddressBook.root.etherPredicate, portalArtifacts.etherPredicate.abi, sepoliaSigner);
    wrappedGiltPredicate = new ethers.Contract(
      existingAddressBook.root.wrappedGiltPredicate,
      portalArtifacts.wrappedGiltPredicate.abi,
      sepoliaSigner,
    );
    scaledErc1155Predicate = new ethers.Contract(
      existingAddressBook.root.scaledErc1155Predicate,
      portalArtifacts.scaledErc1155Predicate.abi,
      sepoliaSigner,
    );
    wrappedGilt = new ethers.Contract(existingAddressBook.root.wrappedGilt, portalArtifacts.wrappedGilt.abi, sepoliaSigner);
    rootPaxg = new ethers.Contract(existingAddressBook.root.paxg, portalArtifacts.dummyErc20.abi, sepoliaSigner);
    rootXaut = new ethers.Contract(existingAddressBook.root.xaut, portalArtifacts.dummyErc20.abi, sepoliaSigner);
    rootUsdc = new ethers.Contract(existingAddressBook.root.usdc, portalArtifacts.dummyErc20.abi, sepoliaSigner);
    rootUsdt = new ethers.Contract(existingAddressBook.root.usdt, portalArtifacts.dummyErc20.abi, sepoliaSigner);

    const rootLastChildBlock = Number(await rootChain.getLastChildBlock());
    const roughnetHead = await roughnetProvider.getBlockNumber();
    if (roughnetHead <= rootLastChildBlock) {
      throw new Error(
        `REUSE_ROOT=1 is unsafe for this roughnet: root checkpoint stack already covers child block ${rootLastChildBlock}, but current roughnet head is only ${roughnetHead}`,
      );
    }
  } else {
    console.log('Deploying Sepolia root checkpoint stack');
    const governanceImpl = await deployContract(sepoliaSigner, rootArtifacts.governance);
    const governanceProxy = await deployContract(sepoliaSigner, rootArtifacts.governanceProxy, [
      await governanceImpl.getAddress(),
    ]);
    governance = new ethers.Contract(await governanceProxy.getAddress(), rootArtifacts.governance.abi, sepoliaSigner);
    registry = await deployContract(sepoliaSigner, rootArtifacts.registry, [await governance.getAddress()]);
    const rootChainImpl = await deployContract(sepoliaSigner, rootArtifacts.rootChain);
    const rootChainProxy = await deployContract(sepoliaSigner, rootArtifacts.rootChainProxy, [
      await rootChainImpl.getAddress(),
      await registry.getAddress(),
      heimdallChainId,
    ]);
    rootChain = new ethers.Contract(await rootChainProxy.getAddress(), rootArtifacts.rootChain.abi, sepoliaSigner);

    staking = await deployStakeManager(sepoliaSigner, sepoliaWallet, governance, registry, rootChain, heimdallChainId);

    console.log('Deploying Sepolia portal contracts');
    stateSender = await deployContract(sepoliaSigner, portalArtifacts.stateSender);
    rootChainManager = await deployProxyInitialized(
      sepoliaSigner,
      portalArtifacts.rootChainManager,
      portalArtifacts.rootChainManagerProxy,
      [sepoliaAddress],
    );
    erc20Predicate = await deployProxyInitialized(
      sepoliaSigner,
      portalArtifacts.erc20Predicate,
      portalArtifacts.erc20PredicateProxy,
      [sepoliaAddress],
    );
    etherPredicate = await deployProxyInitialized(
      sepoliaSigner,
      portalArtifacts.etherPredicate,
      portalArtifacts.etherPredicateProxy,
      [sepoliaAddress],
    );
    wrappedGiltPredicate = await deployProxyInitialized(
      sepoliaSigner,
      portalArtifacts.wrappedGiltPredicate,
      portalArtifacts.wrappedGiltPredicateProxy,
      [sepoliaAddress],
    );
    scaledErc1155Predicate = await deployProxyInitialized(
      sepoliaSigner,
      portalArtifacts.scaledErc1155Predicate,
      portalArtifacts.scaledErc1155PredicateProxy,
      [sepoliaAddress, 1000, 1],
    );

    wrappedGilt = await deployContract(sepoliaSigner, portalArtifacts.wrappedGilt);
    rootPaxg = await deployContract(sepoliaSigner, portalArtifacts.dummyErc20, ['Dummy PAXG', 'PAXG']);
    rootXaut = await deployContract(sepoliaSigner, portalArtifacts.dummyErc20, ['Dummy XAUT', 'XAUT']);
    rootUsdc = await deployContract(sepoliaSigner, portalArtifacts.dummyErc20, ['Dummy USDC', 'USDC']);
    rootUsdt = await deployContract(sepoliaSigner, portalArtifacts.dummyErc20, ['Dummy USDT', 'USDT']);

    await waitTx(rootChainManager.setStateSender(await stateSender.getAddress()));
    await waitTx(rootChainManager.setCheckpointManager(await rootChain.getAddress()));

    const managerRole = await erc20Predicate.MANAGER_ROLE();
    await waitTx(erc20Predicate.grantRole(managerRole, await rootChainManager.getAddress()));
    await waitTx(etherPredicate.grantRole(managerRole, await rootChainManager.getAddress()));
    await waitTx(wrappedGiltPredicate.grantRole(managerRole, await rootChainManager.getAddress()));
    await waitTx(scaledErc1155Predicate.grantRole(managerRole, await rootChainManager.getAddress()));

    const wrappedGiltPredicateRole = await wrappedGilt.PREDICATE_ROLE();
    await waitTx(wrappedGilt.grantRole(wrappedGiltPredicateRole, await wrappedGiltPredicate.getAddress()));

    await waitTx(rootChainManager.registerPredicate(await erc20Predicate.TOKEN_TYPE(), await erc20Predicate.getAddress()));
    await waitTx(rootChainManager.registerPredicate(await etherPredicate.TOKEN_TYPE(), await etherPredicate.getAddress()));
    await waitTx(
      rootChainManager.registerPredicate(await wrappedGiltPredicate.TOKEN_TYPE(), await wrappedGiltPredicate.getAddress()),
    );
    await waitTx(
      rootChainManager.registerPredicate(
        await scaledErc1155Predicate.TOKEN_TYPE(),
        await scaledErc1155Predicate.getAddress(),
      ),
    );
  }

  await waitTx(rootChainManager.setChildChainManagerAddress(await childChainManager.getAddress()));
  await waitTx(stateSender.register(await rootChainManager.getAddress(), await childChainManager.getAddress()));

  const addressBook = {
    meta: {
      generatedAt: new Date().toISOString(),
      heimdallChainId,
      sepoliaRpc,
      roughnetRpc,
      deployer: sepoliaAddress,
      nativeGiltBridge: NATIVE_GILT_BRIDGE_ADDRESS,
      stateReceiver: STATE_RECEIVER_ADDRESS,
    },
    root: {
      governance: await governance.getAddress(),
      registry: await registry.getAddress(),
      rootChain: await rootChain.getAddress(),
      stakeManager: await staking.stakeManager.getAddress(),
      stakeToken: await staking.stakeToken.getAddress(),
      polToken: await staking.polToken.getAddress(),
      stakingInfo: await staking.stakingInfo.getAddress(),
      stateSender: await stateSender.getAddress(),
      rootChainManager: await rootChainManager.getAddress(),
      erc20Predicate: await erc20Predicate.getAddress(),
      etherPredicate: await etherPredicate.getAddress(),
      wrappedGiltPredicate: await wrappedGiltPredicate.getAddress(),
      scaledErc1155Predicate: await scaledErc1155Predicate.getAddress(),
      wrappedGilt: await wrappedGilt.getAddress(),
      paxg: await rootPaxg.getAddress(),
      xaut: await rootXaut.getAddress(),
      usdc: await rootUsdc.getAddress(),
      usdt: await rootUsdt.getAddress(),
    },
    child: {
      childChainManager: await childChainManager.getAddress(),
      gold: await childGold.getAddress(),
      legacyGoldReserveVault: await legacyGoldReserveVault.getAddress(),
      goldPaxgId: '1',
      goldXautId: '2',
      usdc: await childUsdc.getAddress(),
      usdt: await childUsdt.getAddress(),
      weth: await childWeth.getAddress(),
    },
  };
  saveAddressBook(addressBook);

  console.log(
    skipStakeGoldCutover
      ? 'Wiring roughnet bridge runtime only; leaving StakeHub GOLD unchanged on this roughnet'
      : 'Wiring roughnet governance for GOLD and native GILT bridge',
  );
  await ensureLiveGovernanceReadiness(roughnetProvider, validatorWallet, governanceWallet);
  const liveStakeHub = new ethers.Contract(STAKE_HUB_ADDRESS, liveStakeHubAbi, roughnetProvider);
  if (!skipStakeGoldCutover) {
    const currentStakeTokenB = await liveStakeHub.stakeTokenB();
    const currentLegacyStakeTokenB = await liveStakeHub.legacyStakeTokenB();

    if (currentStakeTokenB.toLowerCase() !== (await childGold.getAddress()).toLowerCase()) {
      if (currentStakeTokenB === ZERO_ADDRESS && currentLegacyStakeTokenB === ZERO_ADDRESS) {
      await governUpdateParam(
        roughnetProvider,
        'stakeTokenB',
        hexAddressBytes(await childGold.getAddress()),
        STAKE_HUB_ADDRESS,
        'Set live bridge GOLD token',
        governanceWallet,
        roughnetSigner,
      );
      } else if (currentLegacyStakeTokenB === ZERO_ADDRESS) {
        const activateTx = await liveStakeHub
          .connect(validatorWallet)
          .activateTokenBMigration(await childGold.getAddress(), await legacyGoldReserveVault.getAddress(), {
            gasLimit: 2_000_000,
          });
        await waitForMined(activateTx);
      } else {
        throw new Error(
          `StakeHub is already mid/post migration: active ${currentStakeTokenB}, legacy ${currentLegacyStakeTokenB}, new ${(await childGold.getAddress())}`,
        );
      }
    }
  }
  await governUpdateParam(
    roughnetProvider,
    'childChainManager',
    hexAddressBytes(await childChainManager.getAddress()),
    NATIVE_GILT_BRIDGE_ADDRESS,
    'Set native GILT bridge child manager',
    governanceWallet,
    roughnetSigner,
  );

  if (!skipStakeGoldCutover) {
    const stakeHub = new ethers.Contract(STAKE_HUB_ADDRESS, stakeHubAbi, roughnetProvider);
    const liveGoldAddress = await stakeHub.stakeTokenB();
    if (liveGoldAddress.toLowerCase() !== (await childGold.getAddress()).toLowerCase()) {
      throw new Error(`StakeHub GOLD mismatch: ${liveGoldAddress} != ${await childGold.getAddress()}`);
    }
  }

  heimdallGenesis.app_state.bor.spans = heimdallGenesis.app_state.bor.spans.map((span) => ({
    ...span,
    bor_chain_id: '714',
  }));
  heimdallGenesis.app_state.chainmanager.params.chain_params = {
    ...heimdallGenesis.app_state.chainmanager.params.chain_params,
    bor_chain_id: '714',
    heimdall_chain_id: heimdallChainId,
    pol_token_address: await staking.polToken.getAddress(),
    staking_manager_address: await staking.stakeManager.getAddress(),
    slash_manager_address: ZERO_ADDRESS,
    root_chain_address: await rootChain.getAddress(),
    staking_info_address: await staking.stakingInfo.getAddress(),
    state_sender_address: await stateSender.getAddress(),
    state_receiver_address: STATE_RECEIVER_ADDRESS,
    validator_set_address: '0x0000000000000000000000000000000000001000',
  };
  heimdallGenesis.app_state.chainmanager.params.main_chain_tx_confirmations = '1';
  heimdallGenesis.app_state.chainmanager.params.bor_chain_tx_confirmations = '1';
  fs.writeFileSync(heimdallGenesisPath, `${JSON.stringify(heimdallGenesis, null, 2)}\n`);

  saveAddressBook(addressBook);
  console.log(`Saved address book to ${ADDRESS_BOOK_PATH}`);
  console.log(JSON.stringify(addressBook, null, 2));
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
