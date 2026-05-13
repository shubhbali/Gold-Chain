import type { HardhatUserConfig, NetworkUserConfig } from "hardhat/types";
import "@nomiclabs/hardhat-ethers";
import "@nomiclabs/hardhat-web3";
import "@nomiclabs/hardhat-truffle5";
import "hardhat-abi-exporter";
import "hardhat-contract-sizer";
import "solidity-coverage";
import "dotenv/config";

const optionalAccount = (key: string): string[] => {
  const value = process.env[key];
  return value ? [value] : [];
};

const bscTestnet: NetworkUserConfig = {
  url: "https://data-seed-prebsc-1-s1.binance.org:8545/",
  chainId: 97,
  accounts: optionalAccount("KEY_TESTNET"),
  allowUnlimitedContractSize: true,
};

const bscMainnet: NetworkUserConfig = {
  url: "https://gilt-dataseed.binance.org/",
  chainId: 56,
  accounts: optionalAccount("KEY_MAINNET"),
  allowUnlimitedContractSize: true,
};

const goldChain: NetworkUserConfig = {
  url: process.env.GOLD_CHAIN_RPC_URL || process.env.NEXT_PUBLIC_GOLD_CHAIN_RPC || "http://127.0.0.1:8545",
  chainId: 714,
  accounts: optionalAccount("KEY_GOLDCHAIN"),
  allowUnlimitedContractSize: true,
};

const config: HardhatUserConfig = {
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {},
    testnet: bscTestnet,
    mainnet: bscMainnet,
    goldchain: goldChain,
  },

  solidity: {
    compilers: [
      {
        version: "0.6.12",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
      {
        version: "0.8.17",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ],
  },

  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts",
  },
};

export default config;
