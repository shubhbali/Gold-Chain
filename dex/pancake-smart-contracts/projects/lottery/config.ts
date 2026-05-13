const ZERO_ADDRESS = "0x0000000000000000000000000000000000000000";
const envAddr = (key: string, fallback = ZERO_ADDRESS) => process.env[key] || fallback;

export default {
  CakeToken: {
    mainnet: "0x0e09fabb73bd3ade0a17ecc321fd13a19e81ce82",
    testnet: "0xa35062141fa33bca92ce69fed37d0e8908868aae",
    goldchain: envAddr("NEXT_PUBLIC_GOLD_CHAIN_DEX_ADDRESS"),
  },
  LinkToken: {
    mainnet: "0x404460C6A5EdE2D891e8297795264fDe62ADBB75",
    testnet: "0x84b9B910527Ad5C03A9Ca831909E21e236EA7b06",
    goldchain: envAddr("GOLD_CHAIN_LINK_TOKEN"),
  },
  VRFCoordinator: {
    mainnet: "0x747973a5A2a4Ae1D3a8fDF5479f1514F65Db9C31",
    testnet: "0xa555fC018435bef5A13C6c6870a9d4C11DEC329C",
    goldchain: envAddr("GOLD_CHAIN_VRF_COORDINATOR"),
  },
  FeeInLink: {
    mainnet: "200000000000000000",
    testnet: "100000000000000000",
    goldchain: process.env.GOLD_CHAIN_LOTTERY_FEE_IN_LINK || "0",
  },
  KeyHash: {
    mainnet: "0xaa77729d3466ca35ae8d28b3bbac7cc36a5031efdc430821c02bc31a238af445",
    testnet: "0xcaf3c3727e033261d383b315559476f48034c13b18f8cafed4d871abe5049186",
    goldchain: process.env.GOLD_CHAIN_LOTTERY_KEY_HASH || "",
  },
  OperatorAddress: {
    mainnet: envAddr("MAINNET_LOTTERY_OPERATOR", ZERO_ADDRESS),
    testnet: envAddr("TESTNET_LOTTERY_OPERATOR", ZERO_ADDRESS),
    goldchain: envAddr("GOLD_CHAIN_LOTTERY_OPERATOR"),
  },
  TreasuryAddress: {
    mainnet: envAddr("MAINNET_LOTTERY_TREASURY", ZERO_ADDRESS),
    testnet: envAddr("TESTNET_LOTTERY_TREASURY", ZERO_ADDRESS),
    goldchain: envAddr("GOLD_CHAIN_LOTTERY_TREASURY"),
  },
  InjectorAddress: {
    mainnet: envAddr("MAINNET_LOTTERY_INJECTOR", ZERO_ADDRESS),
    testnet: envAddr("TESTNET_LOTTERY_INJECTOR", ZERO_ADDRESS),
    goldchain: envAddr("GOLD_CHAIN_LOTTERY_INJECTOR"),
  },
};
