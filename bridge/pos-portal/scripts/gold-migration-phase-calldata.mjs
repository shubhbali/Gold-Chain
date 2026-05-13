import { ethers } from "ethers";

const ROOT_CHAIN_MANAGER_ADDRESS = process.env.ROOT_CHAIN_MANAGER_ADDRESS;
const ROOT_OLD_GOLD_TOKEN = process.env.ROOT_OLD_GOLD_TOKEN;
const MIGRATION_CONTROLLER_ADDRESS = process.env.MIGRATION_CONTROLLER_ADDRESS || "";
const PHASE = (process.env.PHASE || "").toUpperCase();
const EXIT_CUTOFF_BLOCK = process.env.EXIT_CUTOFF_BLOCK || "";
const MIGRATE_BRIDGE_FUNDS_DATA = process.env.MIGRATE_BRIDGE_FUNDS_DATA || "0x";

if (!ROOT_CHAIN_MANAGER_ADDRESS) {
  throw new Error("missing ROOT_CHAIN_MANAGER_ADDRESS");
}
if (!ROOT_OLD_GOLD_TOKEN) {
  throw new Error("missing ROOT_OLD_GOLD_TOKEN");
}
if (!PHASE) {
  throw new Error("missing PHASE (ACTIVE | EXIT_ONLY | FINALIZED)");
}
if ((PHASE === "EXIT_ONLY" || PHASE === "FINALIZED") && !MIGRATION_CONTROLLER_ADDRESS) {
  throw new Error("missing MIGRATION_CONTROLLER_ADDRESS for EXIT_ONLY or FINALIZED");
}
if ((PHASE === "EXIT_ONLY" || PHASE === "FINALIZED") && !EXIT_CUTOFF_BLOCK) {
  throw new Error("missing EXIT_CUTOFF_BLOCK for EXIT_ONLY or FINALIZED");
}

const rootIface = new ethers.Interface([
  "function updateTokenMigrationStatus(address rootToken,bool isDepositDisable,bool isExitDisabled,uint256 lastExitBlockNumber)",
  "function migrateBridgeFunds(address rootToken, bytes data)",
  "function setTokenMigrationManager(address rootToken, bool approved)",
]);
const controllerIface = new ethers.Interface([
  "function setExitOnly(uint256 cutoffBlock)",
  "function finalizeMigration()",
]);

function buildPhaseCalls() {
  if (PHASE === "ACTIVE") {
    return [
      {
        title: "Approve token for migration manager",
        target: ROOT_CHAIN_MANAGER_ADDRESS,
        calldata: rootIface.encodeFunctionData("setTokenMigrationManager", [ROOT_OLD_GOLD_TOKEN, true]),
      },
      {
        title: "Set old GOLD path ACTIVE (deposits+exits enabled)",
        target: ROOT_CHAIN_MANAGER_ADDRESS,
        calldata: rootIface.encodeFunctionData("updateTokenMigrationStatus", [ROOT_OLD_GOLD_TOKEN, false, false, 0]),
      },
    ];
  }
  if (PHASE === "EXIT_ONLY") {
    return [
      {
        title: "Set migration controller lifecycle to EXIT_ONLY",
        target: MIGRATION_CONTROLLER_ADDRESS,
        calldata: controllerIface.encodeFunctionData("setExitOnly", [EXIT_CUTOFF_BLOCK]),
      },
      {
        title: "Approve token for migration manager",
        target: ROOT_CHAIN_MANAGER_ADDRESS,
        calldata: rootIface.encodeFunctionData("setTokenMigrationManager", [ROOT_OLD_GOLD_TOKEN, true]),
      },
      {
        title: "Set old GOLD path EXIT_ONLY (deposits disabled, exits enabled until cutoff)",
        target: ROOT_CHAIN_MANAGER_ADDRESS,
        calldata: rootIface.encodeFunctionData("updateTokenMigrationStatus", [
          ROOT_OLD_GOLD_TOKEN,
          true,
          false,
          EXIT_CUTOFF_BLOCK,
        ]),
      },
    ];
  }
  if (PHASE === "FINALIZED") {
    return [
      {
        title: "Finalize migration controller lifecycle",
        target: MIGRATION_CONTROLLER_ADDRESS,
        calldata: controllerIface.encodeFunctionData("finalizeMigration", []),
      },
      {
        title: "Approve token for migration manager",
        target: ROOT_CHAIN_MANAGER_ADDRESS,
        calldata: rootIface.encodeFunctionData("setTokenMigrationManager", [ROOT_OLD_GOLD_TOKEN, true]),
      },
      {
        title: "Set old GOLD path FINALIZED (deposits+exits disabled after cutoff block)",
        target: ROOT_CHAIN_MANAGER_ADDRESS,
        calldata: rootIface.encodeFunctionData("updateTokenMigrationStatus", [
          ROOT_OLD_GOLD_TOKEN,
          true,
          true,
          EXIT_CUTOFF_BLOCK,
        ]),
      },
      {
        title: "Migrate residual bridge funds after finalization",
        target: ROOT_CHAIN_MANAGER_ADDRESS,
        calldata: rootIface.encodeFunctionData("migrateBridgeFunds", [ROOT_OLD_GOLD_TOKEN, MIGRATE_BRIDGE_FUNDS_DATA]),
      },
    ];
  }
  throw new Error(`unsupported PHASE: ${PHASE}`);
}

console.log(
  JSON.stringify(
    {
      note: "Submit calls in order through governance so controller and root bridge phase transitions cannot drift.",
      phase: PHASE,
      rootChainManager: ROOT_CHAIN_MANAGER_ADDRESS,
      migrationController: MIGRATION_CONTROLLER_ADDRESS || null,
      oldGoldRootToken: ROOT_OLD_GOLD_TOKEN,
      exitCutoffBlock: EXIT_CUTOFF_BLOCK || null,
      calls: buildPhaseCalls(),
    },
    null,
    2
  )
);
