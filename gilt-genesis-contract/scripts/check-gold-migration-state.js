const fs = require('fs');
const path = require('path');
const { ethers } = require('ethers');

const STAKE_HUB_ADDRESS = process.env.STAKE_HUB_ADDRESS || '0x0000000000000000000000000000000000002002';

function loadCanonicalAbi(fileName) {
  return JSON.parse(
    fs.readFileSync(path.resolve(__dirname, '../abi', fileName), 'utf8'),
  );
}

const stakeHubAbi = loadCanonicalAbi('stakehub.abi');

const erc1155Abi = [
  'function balanceOf(address account, uint256 id) view returns (uint256)',
];

const migrationControllerAbi = [
  'function lifecycleState() view returns (uint8)',
  'function migrationPaused() view returns (bool)',
  'function reserveVault() view returns (address)',
  'function legacyCapturedById(uint256 tokenId) view returns (uint256)',
  'function finalMintedById(uint256 tokenId) view returns (uint256)',
];

function optionalBalanceContract(address, provider) {
  if (!address || address === ethers.ZeroAddress) {
    return null;
  }
  return new ethers.Contract(address, erc1155Abi, provider);
}

function parseTokenIds() {
  const value = process.env.TOKEN_IDS || '1,2';
  return value
    .split(',')
    .map((id) => id.trim())
    .filter(Boolean)
    .map((id) => BigInt(id));
}

async function main() {
  const provider = new ethers.JsonRpcProvider(process.env.RPC_URL || 'http://127.0.0.1:8545');
  const validator = process.env.VALIDATOR_ADDRESS;
  const delegator = process.env.DELEGATOR_ADDRESS;
  const reserveVault = process.env.RESERVE_VAULT_ADDRESS;
  const tokenIds = parseTokenIds();

  if (!validator || !delegator) {
    throw new Error('missing VALIDATOR_ADDRESS or DELEGATOR_ADDRESS');
  }

  const stakeHub = new ethers.Contract(STAKE_HUB_ADDRESS, stakeHubAbi, provider);
  const activeGold = await stakeHub.stakeTokenB();
  const legacyGold = await stakeHub.legacyStakeTokenB();
  const migrationControllerAddress = await stakeHub.tokenBMigrationController();

  const activeToken = optionalBalanceContract(activeGold, provider);
  const legacyToken = optionalBalanceContract(legacyGold, provider);
  const migrationController = migrationControllerAddress === ethers.ZeroAddress
    ? null
    : new ethers.Contract(migrationControllerAddress, migrationControllerAbi, provider);

  const result = {
    activeGold,
    legacyGold,
    migrationController: migrationControllerAddress,
    cutoverVersion: (await stakeHub.tokenBCutoverVersion()).toString(),
    validatorDelegated: (await stakeHub.totalDelegatedTokenB(validator)).toString(),
    validatorLegacyDelegated: (await stakeHub.totalLegacyDelegatedTokenB(validator)).toString(),
    delegatorDelegated: (await stakeHub.getDelegatedTokenB(validator, delegator)).toString(),
    delegatorLegacyDelegated: (await stakeHub.getLegacyDelegatedTokenB(validator, delegator)).toString(),
    tokenIds: tokenIds.map((tokenId) => tokenId.toString()),
  };

  if (migrationController) {
    result.migrationLifecycleState = Number(await migrationController.lifecycleState());
    result.migrationPaused = await migrationController.migrationPaused();
    result.migrationReserveVault = await migrationController.reserveVault();
  }

  if (activeToken || legacyToken || migrationController) {
    result.tokenBalances = {};
    for (const tokenId of tokenIds) {
      const key = tokenId.toString();
      result.tokenBalances[key] = {};
      if (activeToken) {
        result.tokenBalances[key].stakeHubActiveGoldBalance =
          (await activeToken.balanceOf(STAKE_HUB_ADDRESS, tokenId)).toString();
        result.tokenBalances[key].delegatorActiveGoldBalance =
          (await activeToken.balanceOf(delegator, tokenId)).toString();
      }
      if (legacyToken) {
        result.tokenBalances[key].stakeHubLegacyGoldBalance =
          (await legacyToken.balanceOf(STAKE_HUB_ADDRESS, tokenId)).toString();
        result.tokenBalances[key].delegatorLegacyGoldBalance =
          (await legacyToken.balanceOf(delegator, tokenId)).toString();
        if (reserveVault) {
          result.tokenBalances[key].reserveLegacyGoldBalance =
            (await legacyToken.balanceOf(reserveVault, tokenId)).toString();
        }
      }
      if (migrationController) {
        result.tokenBalances[key].capturedLegacyById =
          (await migrationController.legacyCapturedById(tokenId)).toString();
        result.tokenBalances[key].mintedFinalById =
          (await migrationController.finalMintedById(tokenId)).toString();
      }
    }
  }

  console.log(JSON.stringify(result, null, 2));
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
