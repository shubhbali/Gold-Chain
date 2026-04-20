const { ethers } = require('ethers');

const STAKE_HUB_ADDRESS = process.env.STAKE_HUB_ADDRESS || '0x0000000000000000000000000000000000002002';

const stakeHubAbi = [
  'function stakeTokenB() view returns (address)',
  'function legacyStakeTokenB() view returns (address)',
  'function tokenBCutoverVersion() view returns (uint256)',
  'function tokenBMigrationReserve() view returns (uint256)',
  'function totalDelegatedTokenB(address operatorAddress) view returns (uint256)',
  'function totalLegacyDelegatedTokenB(address operatorAddress) view returns (uint256)',
  'function getDelegatedTokenB(address operatorAddress, address delegator) view returns (uint256)',
  'function getLegacyDelegatedTokenB(address operatorAddress, address delegator) view returns (uint256)',
];

const erc20Abi = [
  'function balanceOf(address account) view returns (uint256)',
];

function optionalBalanceContract(address, provider) {
  if (!address || address === ethers.ZeroAddress) {
    return null;
  }
  return new ethers.Contract(address, erc20Abi, provider);
}

async function main() {
  const provider = new ethers.JsonRpcProvider(process.env.RPC_URL || 'http://127.0.0.1:8545');
  const validator = process.env.VALIDATOR_ADDRESS;
  const delegator = process.env.DELEGATOR_ADDRESS;
  const reserveVault = process.env.RESERVE_VAULT_ADDRESS;

  if (!validator || !delegator) {
    throw new Error('missing VALIDATOR_ADDRESS or DELEGATOR_ADDRESS');
  }

  const stakeHub = new ethers.Contract(STAKE_HUB_ADDRESS, stakeHubAbi, provider);
  const activeGold = await stakeHub.stakeTokenB();
  const legacyGold = await stakeHub.legacyStakeTokenB();

  const activeToken = optionalBalanceContract(activeGold, provider);
  const legacyToken = optionalBalanceContract(legacyGold, provider);

  const result = {
    activeGold,
    legacyGold,
    cutoverVersion: (await stakeHub.tokenBCutoverVersion()).toString(),
    migrationReserve: (await stakeHub.tokenBMigrationReserve()).toString(),
    validatorDelegated: (await stakeHub.totalDelegatedTokenB(validator)).toString(),
    validatorLegacyDelegated: (await stakeHub.totalLegacyDelegatedTokenB(validator)).toString(),
    delegatorDelegated: (await stakeHub.getDelegatedTokenB(validator, delegator)).toString(),
    delegatorLegacyDelegated: (await stakeHub.getLegacyDelegatedTokenB(validator, delegator)).toString(),
  };

  if (activeToken) {
    result.stakeHubActiveGoldBalance = (await activeToken.balanceOf(STAKE_HUB_ADDRESS)).toString();
    result.delegatorActiveGoldBalance = (await activeToken.balanceOf(delegator)).toString();
  }

  if (legacyToken) {
    result.stakeHubLegacyGoldBalance = (await legacyToken.balanceOf(STAKE_HUB_ADDRESS)).toString();
    result.delegatorLegacyGoldBalance = (await legacyToken.balanceOf(delegator)).toString();
    if (reserveVault) {
      result.reserveLegacyGoldBalance = (await legacyToken.balanceOf(reserveVault)).toString();
    }
  }

  console.log(JSON.stringify(result, null, 2));
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
