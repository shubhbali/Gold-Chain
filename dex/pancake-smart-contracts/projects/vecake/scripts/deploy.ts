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
    const cakePool = config.CakePool[networkName];
    const cakeToken = config.CakeToken[networkName];
    const proxyForCakePoolFactory = config.ProxyForCakePoolFactory[networkName];

    // Check if the addresses in the config are set.
    if (
      !cakePool ||
      !cakeToken ||
      !proxyForCakePoolFactory ||
      cakePool === ZERO_ADDRESS ||
      cakeToken === ZERO_ADDRESS ||
      proxyForCakePoolFactory === ZERO_ADDRESS
    ) {
      throw new Error(`Missing vecake addresses for network ${networkName}`);
    }

    // Compile contracts.
    await run("compile");
    console.log("Compiled contracts...");

    // Deploy contracts.
    const VECakeContract = await ethers.getContractFactory("VECake");
    const contract = await VECakeContract.deploy(
      cakePool,
      cakeToken,
      proxyForCakePoolFactory
    );

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
