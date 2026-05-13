const { ethers } = require('ethers');

const swapAbi = [
  'function legacyGold() view returns (address)',
  'function newGold() view returns (address)',
  'function migrationController() view returns (address)',
  'function swap(uint256 tokenId, uint256 amount)',
];

const erc1155Abi = [
  'function setApprovalForAll(address operator, bool approved)',
  'function isApprovedForAll(address account, address operator) view returns (bool)',
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
  const swapAddress = required('SWAP_CONTRACT_ADDRESS');
  const tokenId = BigInt(required('TOKEN_ID'));
  const amountWei = required('AMOUNT_WEI');

  const swap = new ethers.Contract(swapAddress, swapAbi, wallet);
  const legacyGoldAddress = await swap.legacyGold();
  const newGoldAddress = await swap.newGold();
  const migrationControllerAddress = await swap.migrationController();

  const legacyGold = new ethers.Contract(legacyGoldAddress, erc1155Abi, wallet);
  const newGold = new ethers.Contract(newGoldAddress, erc1155Abi, wallet);

  const approved = await legacyGold.isApprovedForAll(wallet.address, migrationControllerAddress);
  if (!approved) {
    const approveTx = await legacyGold.setApprovalForAll(migrationControllerAddress, true);
    console.log(`approve tx: ${approveTx.hash}`);
    await approveTx.wait();
  }

  const beforeLegacy = await legacyGold.balanceOf(wallet.address, tokenId);
  const beforeNew = await newGold.balanceOf(wallet.address, tokenId);

  const swapTx = await swap.swap(tokenId, amountWei);
  console.log(`swap tx: ${swapTx.hash}`);
  await swapTx.wait();

  const afterLegacy = await legacyGold.balanceOf(wallet.address, tokenId);
  const afterNew = await newGold.balanceOf(wallet.address, tokenId);

  console.log({
    tokenId: tokenId.toString(),
    migrationController: migrationControllerAddress,
    legacyBefore: beforeLegacy.toString(),
    legacyAfter: afterLegacy.toString(),
    newBefore: beforeNew.toString(),
    newAfter: afterNew.toString(),
  });
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
