const ZERO_ADDRESS = "0x0000000000000000000000000000000000000000";
const ADDRESS_REGEX = /^0x[a-fA-F0-9]{40}$/;
const networkHint = (process.env.HARDHAT_NETWORK || process.env.GOLD_CHAIN_DEPLOY_NETWORK || "").toLowerCase();
const strictGoldChain = process.env.GOLD_CHAIN_STRICT_CONFIG === "true" || networkHint === "goldchain";

const readGoldChainAddress = (keys: string[], label: string, fallback = ZERO_ADDRESS) => {
  for (const key of keys) {
    const value = process.env[key];
    if (value && ADDRESS_REGEX.test(value)) {
      return value;
    }
  }
  if (strictGoldChain) {
    throw new Error(`Missing ${label} (${keys.join(" or ")})`);
  }
  return fallback;
};

export default {
  PancakeRouter: {
    mainnet: "0x10ed43c718714eb63d5aa57b78b54704e256024e",
    testnet: "0xD99D1c33F9fC3444f8101754aBC46c52416550D1",
    goldchain: readGoldChainAddress(
      ["GOLD_CHAIN_ROUTER_ADDRESS", "NEXT_PUBLIC_GOLD_CHAIN_ROUTER_ADDRESS"],
      "Gold Chain router address"
    ),
  },
  MaxZapReverseRatio: {
    mainnet: "50", // 0.5%
    testnet: "50", // 0.5%
    goldchain: process.env.GOLD_CHAIN_MAX_ZAP_REVERSE_RATIO || "50",
  },
  WBNB: {
    mainnet: "0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c",
    testnet: "0x094616F0BdFB0b526bD735Bf66Eca0Ad254ca81F",
    goldchain: readGoldChainAddress(
      ["GOLD_CHAIN_WGILT_ADDRESS", "NEXT_PUBLIC_GOLD_CHAIN_WGILT_ADDRESS"],
      "Gold Chain WGILT address"
    ),
  },
};
