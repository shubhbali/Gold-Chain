import { ethers, network } from "hardhat";

const currentNetwork = network.name;
const ZERO_ADDRESS = "0x0000000000000000000000000000000000000000";

const veCakeByNetwork: Record<string, string> = {
  mainnet: process.env.BSC_MAINNET_VECAKE_ADDRESS || "0x5692DB8177a81A6c6afc8084C2976C9933EC1bAB",
  testnet: process.env.BSC_TESTNET_VECAKE_ADDRESS || "0x4879fcB447E7F4c7843A6D15dF5526061304dcFb",
  goldchain: process.env.GOLD_CHAIN_VECAKE_ADDRESS || ZERO_ADDRESS,
};

const main = async () => {
  console.log("Deploying to network:", currentNetwork);
  if (!(currentNetwork in veCakeByNetwork)) {
    throw new Error(`Unsupported network for voter deployment: ${currentNetwork}`);
  }
  const veCakeAddress = veCakeByNetwork[currentNetwork];
  if (!veCakeAddress || veCakeAddress === ZERO_ADDRESS) {
    throw new Error(`Missing veCake address for network ${currentNetwork}`);
  }

  let ContractObj = await ethers.getContractFactory("GaugeVoting");
  let obj = await ContractObj.deploy(
    veCakeAddress // veCake
  );
  await obj.deployed();
  console.log("GaugeVoting deployed to:", obj.address);

  ContractObj = await ethers.getContractFactory("GaugeVotingAdminUtil");
  obj = await ContractObj.deploy();
  await obj.deployed();
  console.log("GaugeVotingAdminUtil deployed to:", obj.address);

  ContractObj = await ethers.getContractFactory("GaugeVotingCalc");
  obj = await ContractObj.deploy();
  await obj.deployed();
  console.log("GaugeVotingCalc deployed to:", obj.address);
};

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
