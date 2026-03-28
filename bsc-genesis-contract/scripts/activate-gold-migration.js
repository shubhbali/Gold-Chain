const { ethers } = require('ethers');

const STAKE_HUB_ADDRESS = process.env.STAKE_HUB_ADDRESS || '0x0000000000000000000000000000000000002002';

const stakeHubAbi = [
  'function stakeTokenB() view returns (address)',
  'function legacyStakeTokenB() view returns (address)',
  'function tokenBCutoverVersion() view returns (uint256)',
  'function tokenBMigrationReserveById(uint256 tokenId) view returns (uint256)',
  'function tokenBMigrationProposalId() view returns (uint256)',
  'function pendingTokenBMigrationStakeTokenB() view returns (address)',
  'function pendingTokenBMigrationReserveVault() view returns (address)',
  'function pendingTokenBMigrationApprovalCount() view returns (uint256)',
  'function pendingTokenBMigrationRequiredApprovals() view returns (uint256)',
  'function hasApprovedTokenBMigration(uint256 proposalId, address operatorAddress) view returns (bool)',
  'function activateTokenBMigration(address newStakeTokenB, address reserveVault)',
  'function depositTokenBMigrationReserve1155(uint256 tokenId, uint256 amount)',
];

const erc1155Abi = [
  'function setApprovalForAll(address operator, bool approved)',
  'function isApprovedForAll(address owner, address operator) view returns (bool)',
  'function balanceOf(address account, uint256 id) view returns (uint256)',
];

function required(name) {
  const value = process.env[name];
  if (!value) {
    throw new Error(`missing ${name}`);
  }
  return value;
}

async function main() {
  const provider = new ethers.JsonRpcProvider(required('RPC_URL'));
  const wallet = new ethers.Wallet(required('PRIVATE_KEY'), provider);

  const newGoldAddress = required('NEW_GOLD_ADDRESS');
  const reserveVaultAddress = required('RESERVE_VAULT_ADDRESS');
  const reserveWei = process.env.MIGRATION_RESERVE_WEI || '0';
  const tokenId = BigInt(required('TOKEN_ID'));

  const stakeHub = new ethers.Contract(STAKE_HUB_ADDRESS, stakeHubAbi, wallet);
  const newGold = new ethers.Contract(newGoldAddress, erc1155Abi, wallet);

  const beforeActive = await stakeHub.stakeTokenB();
  const beforeLegacy = await stakeHub.legacyStakeTokenB();
  const beforeVersion = await stakeHub.tokenBCutoverVersion();
  const beforeProposalId = await stakeHub.tokenBMigrationProposalId();

  console.log('before');
  console.log({
    activeGold: beforeActive,
    legacyGold: beforeLegacy,
    cutoverVersion: beforeVersion.toString(),
    proposalId: beforeProposalId.toString(),
  });

  if (beforeLegacy === ethers.ZeroAddress) {
    const tx = await stakeHub.activateTokenBMigration(newGoldAddress, reserveVaultAddress);
    console.log(`activate tx: ${tx.hash}`);
    await tx.wait();
  } else {
    console.log('migration already active, skipping activate step');
  }

  if (reserveWei !== '0') {
    const approved = await newGold.isApprovedForAll(wallet.address, STAKE_HUB_ADDRESS);
    if (!approved) {
      const approveTx = await newGold.setApprovalForAll(STAKE_HUB_ADDRESS, true);
      console.log(`approve tx: ${approveTx.hash}`);
      await approveTx.wait();
    }

    const depositTx = await stakeHub.depositTokenBMigrationReserve1155(tokenId, reserveWei);
    console.log(`deposit tx: ${depositTx.hash}`);
    await depositTx.wait();
  }

  const afterActive = await stakeHub.stakeTokenB();
  const afterLegacy = await stakeHub.legacyStakeTokenB();
  const afterVersion = await stakeHub.tokenBCutoverVersion();
  const afterProposalId = await stakeHub.tokenBMigrationProposalId();
  const reserve = await stakeHub.tokenBMigrationReserveById(tokenId);

  console.log('after');
  console.log({
    activeGold: afterActive,
    legacyGold: afterLegacy,
    cutoverVersion: afterVersion.toString(),
    proposalId: afterProposalId.toString(),
    pendingStakeTokenB: await stakeHub.pendingTokenBMigrationStakeTokenB(),
    pendingReserveVault: await stakeHub.pendingTokenBMigrationReserveVault(),
    pendingApprovalCount: (await stakeHub.pendingTokenBMigrationApprovalCount()).toString(),
    pendingRequiredApprovals: (await stakeHub.pendingTokenBMigrationRequiredApprovals()).toString(),
    walletApprovedCurrentProposal: await stakeHub.hasApprovedTokenBMigration(afterProposalId, wallet.address),
    tokenId: tokenId.toString(),
    migrationReserve: reserve.toString(),
  });
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
