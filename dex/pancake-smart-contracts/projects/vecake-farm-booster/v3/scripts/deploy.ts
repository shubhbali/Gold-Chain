import { ethers, run, network } from "hardhat";
import config from "../config";

const ZERO_ADDRESS = "0x0000000000000000000000000000000000000000";

async function main() {
  // Get network data from Hardhat config (see hardhat.config.ts).
  const networkName = network.name;
  // Check if the network is supported.
  if (networkName === "testnet" || networkName === "mainnet" || networkName === "goldchain") {
    console.log(`Deploying to ${networkName} network...`);
    const veCakeAddress = config.VECake[networkName];
    const masterChefV3 = config.MasterChefV3[networkName];
    if (
      !veCakeAddress ||
      !masterChefV3 ||
      veCakeAddress === ZERO_ADDRESS ||
      masterChefV3 === ZERO_ADDRESS
    ) {
      throw new Error(`Missing vecake-farm-booster addresses for network ${networkName}`);
    }

    // Compile contracts.
    await run("compile");
    console.log("Compiled contracts...");

    const FarmBooster = await ethers.getContractFactory("FarmBooster");
    const farmBooster = await FarmBooster.deploy(
      veCakeAddress,
      masterChefV3,
      config.CA[networkName],
      config.CB[networkName]
    );
    await farmBooster.deployed();

    console.log("farmBooster deployed to:", farmBooster.address);
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
