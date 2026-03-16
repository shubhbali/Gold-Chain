const { ethers } = require('ethers');

const swapAbi = [
  'function legacyGold() view returns (address)',
  'function newGold() view returns (address)',
  'function swap(uint256 amount)',
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
  const swapAddress = required('SWAP_CONTRACT_ADDRESS');
  const amountWei = required('AMOUNT_WEI');

  const swap = new ethers.Contract(swapAddress, swapAbi, wallet);
  const legacyGoldAddress = await swap.legacyGold();
  const newGoldAddress = await swap.newGold();

  const legacyGold = new ethers.Contract(legacyGoldAddress, erc20Abi, wallet);
  const newGold = new ethers.Contract(newGoldAddress, erc20Abi, wallet);

  const allowance = await legacyGold.allowance(wallet.address, swapAddress);
  if (allowance < amountWei) {
    const approveTx = await legacyGold.approve(swapAddress, amountWei);
    console.log(`approve tx: ${approveTx.hash}`);
    await approveTx.wait();
  }

  const beforeLegacy = await legacyGold.balanceOf(wallet.address);
  const beforeNew = await newGold.balanceOf(wallet.address);

  const swapTx = await swap.swap(amountWei);
  console.log(`swap tx: ${swapTx.hash}`);
  await swapTx.wait();

  const afterLegacy = await legacyGold.balanceOf(wallet.address);
  const afterNew = await newGold.balanceOf(wallet.address);

  console.log({
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
