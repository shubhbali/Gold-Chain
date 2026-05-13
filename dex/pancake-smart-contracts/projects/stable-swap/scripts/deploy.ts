import { ethers, run, network } from "hardhat";
import config from "../config";

const ZERO_ADDRESS = "0x0000000000000000000000000000000000000000";

async function main() {
  // Get network data from Hardhat config (see hardhat.config.ts).
  const networkName = network.name;
  // Check if the network is supported.
  if (networkName === "testnet" || networkName === "mainnet" || networkName === "goldchain") {
    console.log(`Deploying to ${networkName} network...`);
    const lpFactory = config.LPFactory[networkName];
    const twoPoolDeployer = config.SwapTwoPoolDeployer[networkName];
    const threePoolDeployer = config.SwapThreePoolDeployer[networkName];
    if (
      !lpFactory ||
      !twoPoolDeployer ||
      !threePoolDeployer ||
      lpFactory === ZERO_ADDRESS ||
      twoPoolDeployer === ZERO_ADDRESS ||
      threePoolDeployer === ZERO_ADDRESS
    ) {
      throw new Error(`Missing stable-swap dependency addresses for network ${networkName}`);
    }

    // Compile contracts.
    await run("compile");
    console.log("Compiled contracts...");

    const PancakeStableSwapFactory = await ethers.getContractFactory("PancakeStableSwapFactory");
    const pancakeStableSwapFactory = await PancakeStableSwapFactory.deploy(
      lpFactory,
      twoPoolDeployer,
      threePoolDeployer
    );
    await pancakeStableSwapFactory.deployed();

    console.log("pancakeStableSwapFactory deployed to:", pancakeStableSwapFactory.address);
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
