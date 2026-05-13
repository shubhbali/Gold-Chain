import { parseEther } from "ethers/lib/utils";
import { ethers, network, run } from "hardhat";
import config from "../config";

const ZERO_ADDRESS = "0x0000000000000000000000000000000000000000";

const main = async () => {
  // Get network data from Hardhat config (see hardhat.config.ts).
  const networkName = network.name;

  // Check if the network is supported.
  if (networkName === "testnet" || networkName === "mainnet" || networkName === "goldchain") {
    console.log(`Deploying to ${networkName} network...`);

    // Check if the addresses in the config are set.
    if (!config.VECake[networkName] || config.VECake[networkName] === ZERO_ADDRESS) {
      throw new Error(`Missing VECake address for network ${networkName}`);
    }

    // Compile contracts.
    await run("compile");
    console.log("Compiled contracts...");

    // Deploy contracts.
    const RevenueSharingPoolFactoryContract = await ethers.getContractFactory("RevenueSharingPoolFactory");
    const contract = await RevenueSharingPoolFactoryContract.deploy(config.VECake[networkName]);

    // Wait for the contract to be deployed before exiting the script.
    await contract.deployed();
    console.log(`Deployed to ${contract.address}`);
  } else {
    console.log(`Deploying to ${networkName} network is not supported...`);
  }
};

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
