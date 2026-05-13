import type { HardhatUserConfig, NetworkUserConfig } from "hardhat/types";
import "@nomiclabs-2.2.2/hardhat-ethers";
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
};

const bscMainnet: NetworkUserConfig = {
  url: "https://gilt-dataseed.binance.org/",
  chainId: 56,
  accounts: optionalAccount("KEY_MAINNET"),
};

const goldChain: NetworkUserConfig = {
  url: process.env.GOLD_CHAIN_RPC_URL || process.env.NEXT_PUBLIC_GOLD_CHAIN_RPC || "http://127.0.0.1:8545",
  chainId: 714,
  accounts: optionalAccount("KEY_GOLDCHAIN"),
};

const config = {
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
        version: "0.8.10",
        settings: {
          optimizer: {
            enabled: true,
            runs: 99999,
          },
        },
      },
      {
        version: "0.8.0",
        settings: {
          optimizer: {
            enabled: true,
            runs: 99999,
          },
        },
      },
      {
        version: "0.6.12",
        settings: {
          optimizer: {
            enabled: true,
            runs: 99999,
          },
        },
      },
    ],
  },
  paths: {
    sources: "./contracts/",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts",
  },
  // abiExporter: {
  //   path: "./data/abi",
  //   clear: true,
  //   flat: false,
  // },
};

export default config;
