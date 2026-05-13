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

const readGoldChainNumeric = (key: string, label: string, fallback: string) => {
  const value = process.env[key];
  if (value !== undefined && value !== "") {
    return value;
  }
  if (strictGoldChain) {
    throw new Error(`Missing ${label} (${key})`);
  }
  return fallback;
};

export default {
  StakedToken: {
    // CAKE
    mainnet: "0x0e09fabb73bd3ade0a17ecc321fd13a19e81ce82",
    testnet: "0xa35062141fa33bca92ce69fed37d0e8908868aae",
    goldchain: readGoldChainAddress(
      ["GOLD_CHAIN_STAKED_TOKEN", "NEXT_PUBLIC_GOLD_CHAIN_DEX_ADDRESS"],
      "Gold Chain staked token address"
    ),
  },
  RewardToken: {
    mainnet: "0x0000000000000000000000000000000000000000",
    testnet: "0x0000000000000000000000000000000000000000",
    goldchain: readGoldChainAddress(
      ["GOLD_CHAIN_REWARD_TOKEN", "NEXT_PUBLIC_GOLD_CHAIN_DEX_ADDRESS"],
      "Gold Chain reward token address"
    ),
  },
  RewardPerBlock: {
    mainnet: "0.000",
    testnet: "0.000",
    goldchain: readGoldChainNumeric("GOLD_CHAIN_REWARD_PER_BLOCK", "Gold Chain reward per block", "0.000"),
  },
  StartBlock: {
    mainnet: "0",
    testnet: "0",
    goldchain: readGoldChainNumeric("GOLD_CHAIN_START_BLOCK", "Gold Chain start block", "0"),
  },
  EndBlock: {
    mainnet: "0",
    testnet: "0",
    goldchain: readGoldChainNumeric("GOLD_CHAIN_END_BLOCK", "Gold Chain end block", "0"),
  },
  PoolLimitPerUser: {
    mainnet: "0",
    testnet: "0",
    goldchain: readGoldChainNumeric("GOLD_CHAIN_POOL_LIMIT_PER_USER", "Gold Chain pool limit per user", "0"),
  },
  Admin: {
    mainnet: "0x0000000000000000000000000000000000000000",
    testnet: "0x0000000000000000000000000000000000000000",
    goldchain: readGoldChainAddress(["GOLD_CHAIN_ADMIN"], "Gold Chain admin address"),
  },
};
