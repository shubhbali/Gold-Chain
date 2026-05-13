const fs = require('fs');
const path = require('path');
const { ethers } = require('ethers');

const STAKE_HUB_ADDRESS = process.env.STAKE_HUB_ADDRESS || '0x0000000000000000000000000000000000002002';
const GOV_HUB_ADDRESS = process.env.GOV_HUB_ADDRESS || '0x0000000000000000000000000000000000001007';

function required(name) {
  const value = process.env[name];
  if (!value) {
    throw new Error(`missing ${name}`);
  }
  return value;
}

async function main() {
  const legacyGoldAddress = required('LEGACY_GOLD_ADDRESS');
  const finalGoldAddress = required('FINAL_GOLD_ADDRESS');
  const reserveVaultAddress = required('RESERVE_VAULT_ADDRESS');
  const migrationControllerAddress = required('MIGRATION_CONTROLLER_ADDRESS');
  const swapRouterAddress = process.env.SWAP_CONTRACT_ADDRESS || '';

  const abiCoder = ethers.AbiCoder.defaultAbiCoder();

  const govHubAbi = JSON.parse(
    fs.readFileSync(path.resolve(__dirname, '../abi/govhub.abi'), 'utf8'),
  );
  const govHubIface = new ethers.Interface(govHubAbi);
  const controllerIface = new ethers.Interface([
    'function activatePrepare(address legacyGold_, address finalGold_, address reserveVault_, address stakeMigrationCaller_)',
    'function setWalletMigrationRouter(address newRouter)',
    'function activateMigration()',
    'function setExitOnly(uint256 cutoffBlock)',
    'function finalizeMigration()',
  ]);
  const finalGoldIface = new ethers.Interface([
    'function setMigrationController(address newMigrationController)',
  ]);

  function stakeHubUpdateCalldata(key, value) {
    return govHubIface.encodeFunctionData('updateParam', [key, value, STAKE_HUB_ADDRESS]);
  }

  const setControllerValue = ethers.solidityPacked(['address'], [migrationControllerAddress]);
  const cutoverValue = abiCoder.encode(['address', 'address'], [finalGoldAddress, reserveVaultAddress]);
  const prepareCalldata = controllerIface.encodeFunctionData('activatePrepare', [
    legacyGoldAddress,
    finalGoldAddress,
    reserveVaultAddress,
    STAKE_HUB_ADDRESS,
  ]);
  const activateCalldata = controllerIface.encodeFunctionData('activateMigration', []);

  console.log(JSON.stringify({
    note: 'Submit these calls through governance executor (Governor/Timelock calling GovHub/Controller).',
    govHubAddress: GOV_HUB_ADDRESS,
    stakeHubAddress: STAKE_HUB_ADDRESS,
    migrationControllerAddress,
    calls: [
      {
        title: 'Set StakeHub migration controller',
        target: GOV_HUB_ADDRESS,
        calldata: stakeHubUpdateCalldata('tokenBMigrationController', setControllerValue),
      },
      {
        title: 'Bind migration controller on new GOLD',
        target: finalGoldAddress,
        calldata: finalGoldIface.encodeFunctionData('setMigrationController', [migrationControllerAddress]),
      },
      {
        title: 'Prepare migration controller',
        target: migrationControllerAddress,
        calldata: prepareCalldata,
      },
      ...(swapRouterAddress
        ? [{
            title: 'Set wallet migration router (optional)',
            target: migrationControllerAddress,
            calldata: controllerIface.encodeFunctionData('setWalletMigrationRouter', [swapRouterAddress]),
          }]
        : []),
      {
        title: 'Activate migration controller',
        target: migrationControllerAddress,
        calldata: activateCalldata,
      },
      {
        title: 'Activate StakeHub token-B cutover',
        target: GOV_HUB_ADDRESS,
        calldata: stakeHubUpdateCalldata('activateTokenBMigration', cutoverValue),
      },
    ],
  }, null, 2));
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
