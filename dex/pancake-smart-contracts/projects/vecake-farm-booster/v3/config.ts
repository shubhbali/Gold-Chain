const ZERO_ADDRESS = "0x0000000000000000000000000000000000000000";
const envAddr = (key: string, fallback = ZERO_ADDRESS) => process.env[key] || fallback;

export default {
  Farm_Booster: {
    mainnet: "0x625F45234D6335859a8b940960067E89476300c6",
    testnet: "0xF93efC15142d05381b017ca64b80074ccF4d1aCB",
    goldchain: envAddr("GOLD_CHAIN_FARM_BOOSTER_ADDRESS"),
  },
  MasterChefV3: {
    mainnet: "0x556B9306565093C855AEA9AE92A594704c2Cd59e",
    testnet: "0x4c650FB471fe4e0f476fD3437C3411B1122c4e3B",
    goldchain: envAddr("NEXT_PUBLIC_GOLD_CHAIN_MASTERCHEF_V3_ADDRESS"),
  },
  VECake: {
    mainnet: "0x5692DB8177a81A6c6afc8084C2976C9933EC1bAB",
    testnet: "0x4879fcB447E7F4c7843A6D15dF5526061304dcFb",
    goldchain: envAddr("NEXT_PUBLIC_GOLD_CHAIN_VECAKE_ADDRESS"),
  },
  CA: {
    mainnet: 50000,
    testnet: 50000,
    goldchain: Number(process.env.GOLD_CHAIN_FARM_BOOSTER_CA || "50000"),
  },
  CB: {
    mainnet: 100000,
    testnet: 100000,
    goldchain: Number(process.env.GOLD_CHAIN_FARM_BOOSTER_CB || "100000"),
  },
};
