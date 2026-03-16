const { ethers } = require('ethers');

const STAKE_HUB_ADDRESS = process.env.STAKE_HUB_ADDRESS || '0x0000000000000000000000000000000000002002';

const stakeHubAbi = [
  'function stakeTokenB() view returns (address)',
  'function legacyStakeTokenB() view returns (address)',
  'function tokenBCutoverVersion() view returns (uint256)',
  'function tokenBMigrationReserve() view returns (uint256)',
  'function activateTokenBMigration(address newStakeTokenB, address reserveVault)',
  'function depositTokenBMigrationReserve(uint256 amount)',
];

const erc20Abi = [
  'function approve(address spender, uint256 amount) returns (bool)',
  'function allowance(address owner, address spender) view returns (uint256)',
  'function balanceOf(address account) view returns (uint256)',
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

  const stakeHub = new ethers.Contract(STAKE_HUB_ADDRESS, stakeHubAbi, wallet);
  const newGold = new ethers.Contract(newGoldAddress, erc20Abi, wallet);

  const beforeActive = await stakeHub.stakeTokenB();
  const beforeLegacy = await stakeHub.legacyStakeTokenB();
  const beforeVersion = await stakeHub.tokenBCutoverVersion();

  console.log('before');
  console.log({
    activeGold: beforeActive,
    legacyGold: beforeLegacy,
    cutoverVersion: beforeVersion.toString(),
  });

  if (beforeLegacy === ethers.ZeroAddress) {
    const tx = await stakeHub.activateTokenBMigration(newGoldAddress, reserveVaultAddress);
    console.log(`activate tx: ${tx.hash}`);
    await tx.wait();
  } else {
    console.log('migration already active, skipping activate step');
  }

  if (reserveWei !== '0') {
    const allowance = await newGold.allowance(wallet.address, STAKE_HUB_ADDRESS);
    if (allowance < reserveWei) {
      const approveTx = await newGold.approve(STAKE_HUB_ADDRESS, reserveWei);
      console.log(`approve tx: ${approveTx.hash}`);
      await approveTx.wait();
    }

    const depositTx = await stakeHub.depositTokenBMigrationReserve(reserveWei);
    console.log(`deposit tx: ${depositTx.hash}`);
    await depositTx.wait();
  }

  const afterActive = await stakeHub.stakeTokenB();
  const afterLegacy = await stakeHub.legacyStakeTokenB();
  const afterVersion = await stakeHub.tokenBCutoverVersion();
  const reserve = await stakeHub.tokenBMigrationReserve();

  console.log('after');
  console.log({
    activeGold: afterActive,
    legacyGold: afterLegacy,
    cutoverVersion: afterVersion.toString(),
    migrationReserve: reserve.toString(),
  });
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
