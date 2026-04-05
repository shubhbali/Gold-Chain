export default {
  PancakeRouter: {
    mainnet: "0x10ed43c718714eb63d5aa57b78b54704e256024e",
    testnet: "0xD99D1c33F9fC3444f8101754aBC46c52416550D1",
    goldchain: process.env.GOLD_CHAIN_ROUTER_ADDRESS || process.env.NEXT_PUBLIC_GOLD_CHAIN_ROUTER_ADDRESS || "0x0000000000000000000000000000000000000000",
  },
  MaxZapReverseRatio: {
    mainnet: "50", // 0.5%
    testnet: "50", // 0.5%
    goldchain: process.env.GOLD_CHAIN_MAX_ZAP_REVERSE_RATIO || "50",
  },
  WBNB: {
    mainnet: "0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c",
    testnet: "0x094616F0BdFB0b526bD735Bf66Eca0Ad254ca81F",
    goldchain: process.env.GOLD_CHAIN_WGILT_ADDRESS || process.env.NEXT_PUBLIC_GOLD_CHAIN_WGILT_ADDRESS || "0x856bFaE9e22D2DF43978F5d8B3fAf6b254972A70",
  },
};
