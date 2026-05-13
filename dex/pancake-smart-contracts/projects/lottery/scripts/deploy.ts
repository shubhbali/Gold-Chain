import { ethers, network } from "hardhat";
import config from "../config";

const currentNetwork = network.name;
const ZERO_ADDRESS = "0x0000000000000000000000000000000000000000";

function ensureAddress(label: string, value: string) {
  if (!value || value === ZERO_ADDRESS) {
    throw new Error(`Missing ${label} for network ${currentNetwork}`);
  }
}

const main = async (withVRFOnTestnet: boolean = true) => {
  const PancakeSwapLottery = await ethers.getContractFactory("PancakeSwapLottery");
  const isSupported = currentNetwork === "testnet" || currentNetwork === "mainnet" || currentNetwork === "goldchain";
  if (!isSupported) {
    throw new Error(`Unsupported network for lottery deployment: ${currentNetwork}`);
  }
  const withVRF = currentNetwork === "goldchain" ? process.env.GOLD_CHAIN_LOTTERY_USE_VRF === "true" : withVRFOnTestnet;
  ensureAddress("CakeToken", config.CakeToken[currentNetwork]);

  if (currentNetwork == "testnet" || currentNetwork == "goldchain") {
    let randomNumberGenerator;

    if (withVRF) {
      ensureAddress("VRFCoordinator", config.VRFCoordinator[currentNetwork]);
      ensureAddress("LinkToken", config.LinkToken[currentNetwork]);
      if (!config.KeyHash[currentNetwork]) {
        throw new Error(`Missing KeyHash for network ${currentNetwork}`);
      }
      console.log("RandomNumberGenerator with VRF is deployed..");
      const RandomNumberGenerator = await ethers.getContractFactory("RandomNumberGenerator");

      randomNumberGenerator = await RandomNumberGenerator.deploy(
        config.VRFCoordinator[currentNetwork],
        config.LinkToken[currentNetwork]
      );
      await randomNumberGenerator.deployed();
      console.log("RandomNumberGenerator deployed to:", randomNumberGenerator.address);

      // Set fee
      await randomNumberGenerator.setFee(config.FeeInLink[currentNetwork]);

      // Set key hash
      await randomNumberGenerator.setKeyHash(config.KeyHash[currentNetwork]);
    } else {
      console.log("RandomNumberGenerator without VRF is deployed..");

      const RandomNumberGenerator = await ethers.getContractFactory("MockRandomNumberGenerator");
      randomNumberGenerator = await RandomNumberGenerator.deploy();
      await randomNumberGenerator.deployed();

      console.log("RandomNumberGenerator deployed to:", randomNumberGenerator.address);
    }

    const pancakeSwapLottery = await PancakeSwapLottery.deploy(
      config.CakeToken[currentNetwork],
      randomNumberGenerator.address
    );

    await pancakeSwapLottery.deployed();
    console.log("PancakeSwapLottery deployed to:", pancakeSwapLottery.address);

    // Set lottery address
    await randomNumberGenerator.setLotteryAddress(pancakeSwapLottery.address);
    ensureAddress("OperatorAddress", config.OperatorAddress[currentNetwork]);
    ensureAddress("TreasuryAddress", config.TreasuryAddress[currentNetwork]);
    ensureAddress("InjectorAddress", config.InjectorAddress[currentNetwork]);
    await pancakeSwapLottery.setOperatorAndTreasuryAndInjectorAddresses(
      config.OperatorAddress[currentNetwork],
      config.TreasuryAddress[currentNetwork],
      config.InjectorAddress[currentNetwork]
    );
  } else if (currentNetwork == "mainnet") {
    ensureAddress("VRFCoordinator", config.VRFCoordinator[currentNetwork]);
    ensureAddress("LinkToken", config.LinkToken[currentNetwork]);
    if (!config.KeyHash[currentNetwork]) {
      throw new Error(`Missing KeyHash for network ${currentNetwork}`);
    }
    const RandomNumberGenerator = await ethers.getContractFactory("RandomNumberGenerator");
    const randomNumberGenerator = await RandomNumberGenerator.deploy(
      config.VRFCoordinator[currentNetwork],
      config.LinkToken[currentNetwork]
    );

    await randomNumberGenerator.deployed();
    console.log("RandomNumberGenerator deployed to:", randomNumberGenerator.address);

    // Set fee
    await randomNumberGenerator.setFee(config.FeeInLink[currentNetwork]);

    // Set key hash
    await randomNumberGenerator.setKeyHash(config.KeyHash[currentNetwork]);

    const pancakeSwapLottery = await PancakeSwapLottery.deploy(
      config.CakeToken[currentNetwork],
      randomNumberGenerator.address
    );

    await pancakeSwapLottery.deployed();
    console.log("PancakeSwapLottery deployed to:", pancakeSwapLottery.address);

    // Set lottery address
    await randomNumberGenerator.setLotteryAddress(pancakeSwapLottery.address);

    // Set operator & treasury adresses
    ensureAddress("OperatorAddress", config.OperatorAddress[currentNetwork]);
    ensureAddress("TreasuryAddress", config.TreasuryAddress[currentNetwork]);
    ensureAddress("InjectorAddress", config.InjectorAddress[currentNetwork]);
    await pancakeSwapLottery.setOperatorAndTreasuryAndInjectorAddresses(
      config.OperatorAddress[currentNetwork],
      config.TreasuryAddress[currentNetwork],
      config.InjectorAddress[currentNetwork]
    );
  }
};

main(true)
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
