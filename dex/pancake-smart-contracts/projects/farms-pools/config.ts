export default {
  StakedToken: {
    // CAKE
    mainnet: "0x0e09fabb73bd3ade0a17ecc321fd13a19e81ce82",
    testnet: "0xa35062141fa33bca92ce69fed37d0e8908868aae",
    goldchain: process.env.GOLD_CHAIN_STAKED_TOKEN || process.env.NEXT_PUBLIC_GOLD_CHAIN_DEX_ADDRESS || "0x0000000000000000000000000000000000000000",
  },
  RewardToken: {
    mainnet: "0x0000000000000000000000000000000000000000",
    testnet: "0x0000000000000000000000000000000000000000",
    goldchain: process.env.GOLD_CHAIN_REWARD_TOKEN || process.env.NEXT_PUBLIC_GOLD_CHAIN_DEX_ADDRESS || "0x0000000000000000000000000000000000000000",
  },
  RewardPerBlock: {
    mainnet: "0.000",
    testnet: "0.000",
    goldchain: process.env.GOLD_CHAIN_REWARD_PER_BLOCK || "0.000",
  },
  StartBlock: {
    mainnet: "0",
    testnet: "0",
    goldchain: process.env.GOLD_CHAIN_START_BLOCK || "0",
  },
  EndBlock: {
    mainnet: "0",
    testnet: "0",
    goldchain: process.env.GOLD_CHAIN_END_BLOCK || "0",
  },
  PoolLimitPerUser: {
    mainnet: "0",
    testnet: "0",
    goldchain: process.env.GOLD_CHAIN_POOL_LIMIT_PER_USER || "0",
  },
  Admin: {
    mainnet: "0x0000000000000000000000000000000000000000",
    testnet: "0x0000000000000000000000000000000000000000",
    goldchain: process.env.GOLD_CHAIN_ADMIN || "0x0000000000000000000000000000000000000000",
  },
};
