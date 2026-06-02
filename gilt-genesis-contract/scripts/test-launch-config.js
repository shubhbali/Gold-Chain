#!/usr/bin/env node

const assert = require("assert");
const { execFileSync } = require("child_process");
const fs = require("fs");
const os = require("os");
const path = require("path");
const web3 = require("web3");

const { SYSTEM_PREDEPLOYS, assertArtifactFresh } = require("./lib/launch-artifacts");
const {
  OLD_BSC_BRIDGE_MACHINERY,
  assertNoActiveCoreOldBscBridgeMachinery,
  assertNoLegacySourceMutatingLaunchInvocation,
} = require("./lib/launch-gates");
const { launchSummary, renderMarkdownReport } = require("./lib/launch-report");
const {
  GENESIS_ROOT,
  loadLaunchConfig,
  parseProfileArg,
  sha256Hex,
  validateLaunchConfig,
  validatorExtraData,
} = require("./lib/launch-config");
const {
  GILT_VALIDATOR_SET_SLOTS,
  STAKE_HUB_ADDRESS,
  VALIDATOR_SET_ADDRESS,
  buildGiltValidatorSetStorage,
  buildLaunchGenesisState,
  hex32,
} = require("./lib/launch-storage");
const {
  STAKE_HUB_SLOTS,
  STAKE_HUB_STORAGE_LAYOUT_MANIFEST,
  verifyStakeHubStorageLayout,
} = require("./lib/stakehub-storage-layout");

function clone(value) {
  return JSON.parse(JSON.stringify(value));
}

function mustThrow(fn, expectedMessage) {
  assert.throws(fn, (error) => error.message.includes(expectedMessage));
}

function mustFail(config, expectedMessage) {
  mustThrow(() => validateLaunchConfig(config), expectedMessage);
}

function mustExecFail(command, args, expectedMessage) {
  try {
    execFileSync(command, args, { cwd: GENESIS_ROOT, stdio: "pipe" });
  } catch (error) {
    const output = `${error.stdout || ""}${error.stderr || ""}${error.message || ""}`;
    assert(output.includes(expectedMessage), output);
    return;
  }
  assert.fail(`expected ${command} ${args.join(" ")} to fail`);
}

function withTempDir(fn) {
  const tempDir = fs.mkdtempSync(path.join(os.tmpdir(), "gold-launch-"));
  try {
    return fn(tempDir);
  } finally {
    fs.rmSync(tempDir, { recursive: true, force: true });
  }
}

const TOKEN_HUB_ADDRESS = "0x0000000000000000000000000000000000001004";
const LEGACY_BSC_GENESIS_PREDEPLOYS = [
  { contract: "TendermintLightClient", address: "0x0000000000000000000000000000000000001003" },
  { contract: "TokenHub", address: TOKEN_HUB_ADDRESS },
  { contract: "RelayerIncentivize", address: "0x0000000000000000000000000000000000001005" },
  { contract: "RelayerHub", address: "0x0000000000000000000000000000000000001006" },
  { contract: "TokenManager", address: "0x0000000000000000000000000000000000001008" },
  { contract: "CrossChain", address: "0x0000000000000000000000000000000000002000" },
  { contract: "Staking", address: "0x0000000000000000000000000000000000002001" },
];
const CONCRETE_GENESIS_ARTIFACTS = [
  "genesis.json",
  "genesis-testnet.json",
  "genesis-dev.json",
  "genesis-roughnet.json",
  "genesis-live.json",
];
const FAKE_VALIDATOR_SET_CODE = "0x04";
const FAKE_STAKE_HUB_CODE = "0x01";
const FAKE_GOLD_CODE = "0x02";
const FAKE_RESERVED_PREDEPLOY_CODE = "0x03";
const FAKE_VALIDATOR_STORAGE_HASH = sha256Hex("validator-storage-layout");
const FAKE_STAKE_STORAGE_HASH = sha256Hex("stakehub-storage-layout");
const FAKE_GOLD_STORAGE_HASH = sha256Hex("gold-storage-layout");

function writeGenesis(tempDir, config, overrides = {}) {
  const genesisPath = path.join(tempDir, overrides.name || "genesis.json");
  const validatorSetStorage = overrides.validatorSetStorage || buildGiltValidatorSetStorage(config);
  const genesis = {
    config: {
      chainId: overrides.chainId ?? config.chainId,
    },
    extraData: overrides.extraData || `0x${validatorExtraData(config).toString("hex")}`,
    alloc: {
      [VALIDATOR_SET_ADDRESS]: {
        balance: "0x0",
        code: FAKE_VALIDATOR_SET_CODE,
        storage: validatorSetStorage,
      },
      [STAKE_HUB_ADDRESS]: {
        balance: "0x0",
        code: FAKE_STAKE_HUB_CODE,
        storage: {
          [hex32(STAKE_HUB_SLOTS.stakeTokenB)]: hex32(BigInt(config.gold.address)),
        },
      },
      [TOKEN_HUB_ADDRESS]: {
        balance: overrides.tokenHubBalance || "0x0",
        code: overrides.tokenHubCode || FAKE_RESERVED_PREDEPLOY_CODE,
      },
      [config.gold.address]: {
        balance: "0x0",
        code: FAKE_GOLD_CODE,
        storage: {
          [hex32(8)]: hex32(1n << 176n),
        },
      },
    },
  };
  fs.writeFileSync(genesisPath, `${JSON.stringify(genesis, null, 2)}\n`);
  return genesisPath;
}

function fakeSystemArtifacts(artifactMtimeMs = 0) {
  const predeploys = [
    {
      name: "validatorContract",
      contract: "GiltValidatorSet",
      address: VALIDATOR_SET_ADDRESS,
      classification: "ACTIVE_CORE",
      path: "out/GiltValidatorSet.sol/GiltValidatorSet.json",
      artifactPath: "out/GiltValidatorSet.sol/GiltValidatorSet.json",
      artifactMtimeMs,
      sha256: sha256Hex(FAKE_VALIDATOR_SET_CODE),
      runtimeBytecodeBytes: 1,
      storageLayoutHash: FAKE_VALIDATOR_STORAGE_HASH,
      storageLayoutCheck: [{ label: "validatorBootstrapHash", slot: 28 }],
    },
    {
      name: "stakeHub",
      contract: "StakeHub",
      address: STAKE_HUB_ADDRESS,
      classification: "ACTIVE_CORE",
      path: "out/StakeHub.sol/StakeHub.json",
      artifactPath: "out/StakeHub.sol/StakeHub.json",
      artifactMtimeMs,
      sha256: sha256Hex(FAKE_STAKE_HUB_CODE),
      runtimeBytecodeBytes: 1,
      storageLayoutHash: FAKE_STAKE_STORAGE_HASH,
      storageLayoutCheck: [{ label: "stakeTokenB", slot: STAKE_HUB_SLOTS.stakeTokenB }],
    },
    {
      name: "tokenHub",
      contract: "TokenHub",
      address: TOKEN_HUB_ADDRESS,
      classification: "RESERVED_INERT",
      path: "out/ReservedPredeploy.sol/ReservedPredeploy.json",
      artifactPath: "out/ReservedPredeploy.sol/ReservedPredeploy.json",
      artifactMtimeMs,
      sha256: sha256Hex(FAKE_RESERVED_PREDEPLOY_CODE),
      runtimeBytecodeBytes: 1,
    },
    {
      name: "physicalGold1155",
      contract: "PhysicalGold1155",
      address: null,
      classification: "ACTIVE_CORE",
      path: "out/PhysicalGold1155.sol/PhysicalGold1155.json",
      artifactPath: "out/PhysicalGold1155.sol/PhysicalGold1155.json",
      artifactMtimeMs,
      sha256: sha256Hex("0xdead"),
      runtimeBytecodeBytes: 2,
      storageLayoutHash: FAKE_GOLD_STORAGE_HASH,
      storageLayoutCheck: [{ label: "bridgeDepositor", slot: 7 }],
      patchedLaunchImmutables: true,
    },
  ];

  return {
    hashes: Object.fromEntries(
      predeploys.map((predeploy) => [
        predeploy.name,
        {
          path: predeploy.path,
          sha256: predeploy.sha256,
          classification: predeploy.classification,
          address: predeploy.address,
          runtimeBytecodeBytes: predeploy.runtimeBytecodeBytes,
          storageLayoutHash: predeploy.storageLayoutHash || null,
          patchedLaunchImmutables: Boolean(predeploy.patchedLaunchImmutables),
        },
      ]),
    ),
    artifacts: predeploys,
    predeploys,
  };
}

function genesisAllocEntry(genesis, address) {
  return genesis.alloc[address] || genesis.alloc[address.toLowerCase()] || genesis.alloc[address.replace(/^0x/i, "")];
}

function runtimeByteLength(bytecode) {
  return String(bytecode || "").replace(/^0x/i, "").length / 2;
}

function assertConcreteGenesisOldBscPredeploysInert() {
  const canonicalGenesis = JSON.parse(fs.readFileSync(path.join(GENESIS_ROOT, "genesis.json"), "utf8"));
  const canonicalTokenHub = genesisAllocEntry(canonicalGenesis, TOKEN_HUB_ADDRESS);
  assert(canonicalTokenHub?.code, "canonical genesis TokenHub reserved predeploy code is missing");
  assert(runtimeByteLength(canonicalTokenHub.code) <= 512, "canonical TokenHub reserved predeploy code must stay small");

  for (const artifact of CONCRETE_GENESIS_ARTIFACTS) {
    const genesis = JSON.parse(fs.readFileSync(path.join(GENESIS_ROOT, artifact), "utf8"));
    for (const { contract, address } of LEGACY_BSC_GENESIS_PREDEPLOYS) {
      const entry = genesisAllocEntry(genesis, address);
      assert(entry, `${artifact} is missing reserved ${contract} predeploy at ${address}`);
      assert.strictEqual(entry.balance, "0x0", `${artifact} reserved ${contract} predeploy must be zero-balance`);
      assert.strictEqual(
        String(entry.code || "").toLowerCase(),
        String(canonicalTokenHub.code).toLowerCase(),
        `${artifact} reserved ${contract} predeploy must use canonical inert bytecode`,
      );
      assert(!entry.storage, `${artifact} reserved ${contract} predeploy must not carry active storage`);
    }
  }
}

function assertLaunchAcceptance(config, profile) {
  assert.strictEqual(config.profile, profile);
  assert.strictEqual(config.gilt.inflation.enabled, true);
  assert.strictEqual(config.gilt.inflation.starts, "block_1");
  assert.strictEqual(config.gilt.inflation.rewardSource, "GILT_INFLATION_AND_FEES");
  assert.ok(config.gilt.inflation.initialRateBps > 0);
  assert.ok(config.gilt.inflation.minimumRateBps > 0);
  assert.ok(BigInt(config.gilt.inflation.baseSupplyWei) > 0n);
  assert.strictEqual(config.staking.goldStakingEnabled, true);
  assert.strictEqual(config.staking.goldRewardSource, "GILT_PLUS_FEES");
  assert.ok(config.staking.goldRewardSplitBps > 0);
  assert.strictEqual(config.staking.ratioEnabledAtLaunch, false);
  assert.ok(config.staking.unbondPeriodSeconds > 0);
  assert.ok(config.staking.maxElectedValidators > 0);
  assert.ok(config.staking.slashReserveVault);
  assert.ok(BigInt(config.staking.pendingSystemRewardAutoRetryCapWei) > 0n);
  assert.ok(config.gold.address);
  assert.ok(config.gold.admin);
  assert.ok(config.gold.bridgeDepositor);
  assert.ok(BigInt(config.gold.bridgeScaleNumerator) > 0n);
  assert.ok(BigInt(config.gold.bridgeScaleDenominator) > 0n);
  assert.strictEqual(config.gold.type, "ERC1155");
  assert.strictEqual(config.gold.stakingEnabledFromDayOne, true);
  assert.strictEqual(config.gold.emitsGoldRewards, false);
  assert.strictEqual(config.gold.routePrecisionFinalizedAtLaunch, true);
  assert.strictEqual(config.gold.bridgeDepositsClosedAtLaunch, false);
  assert.strictEqual(config.gold.migrationMintingEnabledAtLaunch, false);
  assert.strictEqual(config.gold.migrationMintingFinalizedAtLaunch, false);
  assert.strictEqual(config.gold.tokenIds.paxgBacked, 1);
  assert.strictEqual(config.gold.tokenIds.xautBacked, 2);
  assert.strictEqual(config.gold.routes.paxg.tokenId, 1);
  assert.strictEqual(config.gold.routes.xaut.tokenId, 2);
  assert.strictEqual(config.migration.launchState, "OFF");
  assert.strictEqual(config.migration.governanceActivatesLater, true);
}

const profiles = ["testnet", "mainnet"];
const loadedConfigs = new Map();

for (const profile of profiles) {
  const { config, configPath } = loadLaunchConfig({ profile });
  validateLaunchConfig(config);
  assertLaunchAcceptance(config, profile);
  loadedConfigs.set(profile, { config, configPath });
}

const { config, configPath } = loadedConfigs.get("testnet");
mustThrow(() => parseProfileArg(["--profile"]), "--profile requires a value");

assertNoActiveCoreOldBscBridgeMachinery(SYSTEM_PREDEPLOYS, "system predeploy registry");
for (const contract of OLD_BSC_BRIDGE_MACHINERY) {
  const predeploy = SYSTEM_PREDEPLOYS.find((entry) => entry.contract === contract);
  assert(predeploy, `${contract} must remain visible in final launch surfaces`);
  assert.strictEqual(predeploy.classification, "RESERVED_INERT", `${contract} must be RESERVED_INERT`);
}
assertConcreteGenesisOldBscPredeploysInert();

{
  const broken = clone(SYSTEM_PREDEPLOYS);
  broken.find((entry) => entry.contract === "TokenHub").classification = "ACTIVE_CORE";
  mustThrow(
    () => assertNoActiveCoreOldBscBridgeMachinery(broken, "test launch surface"),
    "old BSC bridge machinery TokenHub must not be ACTIVE_CORE",
  );
}

mustThrow(
  () => assertNoLegacySourceMutatingLaunchInvocation("node", ["scripts/generate-genesis.js"], GENESIS_ROOT),
  "old source-mutating launch scripts are disabled",
);
mustThrow(
  () => assertNoLegacySourceMutatingLaunchInvocation("python", ["scripts/generate.py"], GENESIS_ROOT),
  "old source-mutating launch scripts are disabled",
);
mustExecFail(process.execPath, ["scripts/generate-genesis.js"], "old source-mutating launch scripts are disabled");

{
  const broken = clone(config);
  broken.profile = "dev";
  mustFail(broken, "profile must be testnet or mainnet");
}

{
  const broken = clone(config);
  broken.genesisTemplate = "../genesis-template.json";
  mustFail(broken, "genesisTemplate must stay inside gilt-genesis-contract");
}

{
  const broken = clone(config);
  broken.genesisTemplate = "./missing-launch-template.json";
  mustFail(broken, "genesisTemplate does not exist");
}

{
  const broken = clone(config);
  broken.genesisOutput = "../genesis.json";
  mustFail(broken, "genesisOutput must stay inside gilt-genesis-contract");
}

{
  const broken = clone(config);
  broken.reportOutput = "../launch-report.md";
  mustFail(broken, "reportOutput must stay inside gilt-genesis-contract");
}

{
  const broken = clone(config);
  broken.gilt.allocations = [];
  mustFail(broken, "at least one initial GILT allocation");
}

{
  const broken = clone(config);
  broken.validators.push(clone(broken.validators[0]));
  mustFail(broken, "duplicate validator consensus address");
}

{
  const broken = clone(config);
  delete broken.validators[0].blsPublicKey;
  mustFail(broken, "blsPublicKey vote address is required");
}

{
  const broken = clone(config);
  broken.validators[0].blsPublicKey = `0x${"00".repeat(48)}`;
  mustFail(broken, "blsPublicKey vote address must not be zero");
}

{
  const broken = clone(config);
  broken.validators[0].consensusAddress = "0x0000000000000000000000000000000000000000";
  mustFail(broken, "consensusAddress must not be zero");
}

{
  const broken = clone(config);
  broken.validators[0].votingPower = "0x10000000000000000";
  mustFail(broken, "votingPower must fit uint64");
}

{
  const broken = clone(config);
  broken.validators = Array.from({ length: config.staking.maxElectedValidators + 1 }, (_, index) => {
    const validator = clone(config.validators[0]);
    validator.consensusAddress = `0x${(index + 1).toString(16).padStart(40, "0")}`;
    validator.blsPublicKey = `0x${(index + 1).toString(16).padStart(96, "0")}`;
    return validator;
  });
  mustFail(broken, "validator count must not exceed maxElectedValidators");
}

{
  const broken = clone(config);
  broken.migration.launchState = "ACTIVE";
  mustFail(broken, "migration must be off");
}

{
  const broken = clone(config);
  broken.staking.goldStakingEnabled = false;
  mustFail(broken, "GOLD staking must be enabled");
}

{
  const broken = clone(config);
  broken.gilt.inflation.enabled = false;
  mustFail(broken, "GILT inflation must be enabled");
}

{
  const broken = clone(config);
  broken.gilt.inflation.starts = "after_launch";
  mustFail(broken, "GILT inflation must start from block_1");
}

{
  const broken = clone(config);
  broken.gilt.inflation.rewardSource = "FEES_ONLY";
  mustFail(broken, "GILT reward source must be GILT_INFLATION_AND_FEES");
}

{
  const broken = clone(config);
  broken.gold.tokenIds.paxgBacked = 7;
  mustFail(broken, "PAXG-backed GOLD token ID must be 1");
}

{
  const broken = clone(config);
  broken.gold.tokenIds.xautBacked = 7;
  mustFail(broken, "XAUT-backed GOLD token ID must be 2");
}

{
  const broken = clone(config);
  broken.staking.goldRewardSplitBps = 0;
  mustFail(broken, "GOLD reward split must be non-zero");
}

{
  const broken = clone(config);
  broken.gold.emitsGoldRewards = true;
  mustFail(broken, "GOLD must not emit/mint GOLD rewards");
}

{
  const broken = clone(config);
  broken.gold.routePrecisionFinalizedAtLaunch = false;
  mustFail(broken, "GOLD route precision must be finalized at launch");
}

{
  const broken = clone(config);
  broken.gold.bridgeDepositsClosedAtLaunch = true;
  mustFail(broken, "GOLD bridge deposits must be open at launch");
}

{
  const broken = clone(config);
  broken.gold.migrationMintingEnabledAtLaunch = true;
  mustFail(broken, "GOLD migration minting must be disabled at launch");
}

{
  const broken = clone(config);
  broken.gold.routes.xaut.rootDecimals = 18;
  mustFail(broken, "XAUT GOLD route root decimals must be 6");
}

{
  const broken = clone(config);
  broken.migration.governanceActivatesLater = false;
  mustFail(broken, "migration must be governance-activated later");
}

withTempDir((tempDir) => {
  const genesisPath = writeGenesis(tempDir, config);
  const summary = launchSummary(config, configPath, genesisPath, fakeSystemArtifacts());
  const report = renderMarkdownReport(summary);

  assert(!report.includes("Initial locked GILT on TokenHub"));
  assert(report.includes(`GILT reward source: ${config.gilt.inflation.rewardSource}`));
  assert(report.includes(`GILT inflation base supply wei: ${config.gilt.inflation.baseSupplyWei}`));
  assert(report.includes("- GILT staking: ON"));
  assert(report.includes(`Max elected validators: ${config.staking.maxElectedValidators}`));
  assert(report.includes(`GOLD contract address: ${config.gold.address}`));
  assert(report.includes(`GOLD bridge depositor: ${config.gold.bridgeDepositor}`));
  assert(report.includes(`PAXG-backed GOLD token ID: ${config.gold.tokenIds.paxgBacked}`));
  assert(report.includes(`XAUT-backed GOLD token ID: ${config.gold.tokenIds.xautBacked}`));
  assert(report.includes("- GOLD route lock: LOCKED (PAXG/XAUT precision finalized)"));
  assert(report.includes(config.validators[0].blsPublicKey));
  assert(report.includes(`| StakeHub | ${STAKE_HUB_ADDRESS} | ACTIVE_CORE |`));
  assert(report.includes(`| TokenHub | ${TOKEN_HUB_ADDRESS} | RESERVED_INERT |`));
  assert(report.includes(`stakeHub: ${sha256Hex(FAKE_STAKE_HUB_CODE)} (out/StakeHub.sol/StakeHub.json, ACTIVE_CORE, 1 bytes)`));
  assert(report.includes(`StakeHub: ${FAKE_STAKE_STORAGE_HASH} (1 launch fields, ACTIVE_CORE)`));
  assert(report.includes(`PhysicalGold1155: ${FAKE_GOLD_STORAGE_HASH} (1 launch fields, ACTIVE_CORE)`));
});

withTempDir((tempDir) => {
  const systemArtifacts = fakeSystemArtifacts();
  systemArtifacts.hashes.tokenHub.classification = "ACTIVE_CORE";
  mustThrow(
    () => launchSummary(config, configPath, writeGenesis(tempDir, config), systemArtifacts),
    "old BSC bridge machinery tokenHub must not be ACTIVE_CORE",
  );
});

withTempDir((tempDir) => {
  const systemArtifacts = fakeSystemArtifacts();
  systemArtifacts.predeploys.find((entry) => entry.contract === "TokenHub").classification = "ACTIVE_CORE";
  mustThrow(
    () => launchSummary(config, configPath, writeGenesis(tempDir, config), systemArtifacts),
    "old BSC bridge machinery TokenHub must not be ACTIVE_CORE",
  );
});

{
  const systemArtifacts = fakeSystemArtifacts();
  systemArtifacts.predeploys.find((entry) => entry.contract === "TokenHub").classification = "ACTIVE_CORE";
  mustThrow(
    () =>
      renderMarkdownReport({
        profile: "testnet",
        artifactHashes: fakeSystemArtifacts().hashes,
        predeploys: systemArtifacts.predeploys,
      }),
    "old BSC bridge machinery TokenHub must not be ACTIVE_CORE",
  );
}

withTempDir((tempDir) => {
  mustThrow(
    () => launchSummary(config, configPath, writeGenesis(tempDir, config, { tokenHubBalance: "0x1" }), fakeSystemArtifacts()),
    "reserved inert predeploy TokenHub",
  );
  mustThrow(
    () => launchSummary(config, configPath, writeGenesis(tempDir, config, { tokenHubCode: "0x04" }), fakeSystemArtifacts()),
    "launch genesis predeploy TokenHub",
  );
});

withTempDir((tempDir) => {
  const staleStorage = buildGiltValidatorSetStorage(config);
  staleStorage[hex32(GILT_VALIDATOR_SET_SLOTS.validatorBootstrapHash)] = hex32(1);
  mustThrow(
    () =>
      launchSummary(
        config,
        configPath,
        writeGenesis(tempDir, config, { name: "stale-validator-hash.json", validatorSetStorage: staleStorage }),
        fakeSystemArtifacts(),
      ),
    "validator bootstrap hash does not match launch config",
  );
});

withTempDir((tempDir) => {
  const staleStorage = buildGiltValidatorSetStorage(config);
  const firstValidatorBase = BigInt(web3.utils.keccak256(hex32(GILT_VALIDATOR_SET_SLOTS.currentValidatorSet)));
  staleStorage[hex32(firstValidatorBase + 2n)] = hex32(BigInt(config.validators[0].feeAddress) + (101n << 160n));
  mustThrow(
    () =>
      launchSummary(
        config,
        configPath,
        writeGenesis(tempDir, config, { name: "stale-validator-power.json", validatorSetStorage: staleStorage }),
        fakeSystemArtifacts(),
      ),
    "validator bootstrap storage does not match launch config",
  );
});

withTempDir((tempDir) => {
  mustThrow(
    () => launchSummary(config, configPath, path.join(tempDir, "missing-genesis.json"), fakeSystemArtifacts()),
    "missing launch genesis artifact",
  );

  const genesisPath = writeGenesis(tempDir, config);
  const oldTime = new Date("2000-01-01T00:00:00Z");
  fs.utimesSync(genesisPath, oldTime, oldTime);
  mustThrow(() => launchSummary(config, configPath, genesisPath, fakeSystemArtifacts()), "stale launch genesis artifact");
  mustThrow(() => launchSummary(config, configPath, genesisPath, {}), "missing system contract artifact hashes");
});

{
  const fakeBytecode = `0x${"00".repeat(96)}`;
  const state = buildLaunchGenesisState(config, {
    deployedBytecode: fakeBytecode,
    immutableReferences: {
      numerator: [{ start: 4, length: 32 }],
      denominator: [{ start: 40, length: 32 }],
    },
  });

  assert.strictEqual(state.goldAddress, config.gold.address);
  assert.strictEqual(state.stakeHubStorage[hex32(STAKE_HUB_SLOTS.stakeTokenB)], hex32(BigInt(config.gold.address)));
  assert.strictEqual(state.stakeHubStorage[hex32(STAKE_HUB_SLOTS.tokenBRewardSplitBps)], hex32(config.staking.goldRewardSplitBps));
  assert.strictEqual(state.stakeHubStorage[hex32(STAKE_HUB_SLOTS.inflationEnabled)], hex32(1));
  assert.strictEqual(state.physicalGoldStorage[hex32(7)], hex32(BigInt(config.gold.bridgeDepositor)));
  assert.strictEqual(state.physicalGoldStorage[hex32(8)], hex32(1n << 176n));
  assert.ok(state.physicalGoldBytecode.includes(hex32(config.gold.bridgeScaleNumerator).slice(2)));
  assert.ok(state.physicalGoldBytecode.includes(hex32(config.gold.bridgeScaleDenominator).slice(2)));
}

withTempDir((tempDir) => {
  const sourcePath = path.join(tempDir, "contracts", "Fresh.sol");
  const artifactPath = path.join(tempDir, "out", "Fresh.sol", "Fresh.json");
  fs.mkdirSync(path.dirname(sourcePath), { recursive: true });
  fs.mkdirSync(path.dirname(artifactPath), { recursive: true });
  fs.writeFileSync(sourcePath, "contract Fresh {}\n");
  fs.writeFileSync(artifactPath, "{}\n");

  const artifact = {
    metadata: {
      sources: {
        "contracts/Fresh.sol": {},
      },
    },
  };
  const oldTime = new Date("2020-01-01T00:00:00Z");
  const newTime = new Date("2020-01-02T00:00:00Z");

  fs.utimesSync(sourcePath, oldTime, oldTime);
  fs.utimesSync(artifactPath, newTime, newTime);
  assertArtifactFresh("Fresh", artifactPath, artifact, { root: tempDir });

  fs.utimesSync(sourcePath, newTime, newTime);
  fs.utimesSync(artifactPath, oldTime, oldTime);
  mustThrow(
    () => assertArtifactFresh("Fresh", artifactPath, artifact, { root: tempDir }),
    "stale system contract artifact",
  );
});

{
  const storageLayout = {
    storage: Object.entries(STAKE_HUB_STORAGE_LAYOUT_MANIFEST).map(([label, slot]) => ({
      label,
      slot: String(slot),
    })),
  };
  const checked = verifyStakeHubStorageLayout(storageLayout);
  assert.strictEqual(checked.length, Object.keys(STAKE_HUB_STORAGE_LAYOUT_MANIFEST).length);

  const broken = clone(storageLayout);
  broken.storage.find((entry) => entry.label === "stakeTokenB").slot = "81";
  mustThrow(() => verifyStakeHubStorageLayout(broken), "StakeHub storage slot mismatch for stakeTokenB");
  mustThrow(() => verifyStakeHubStorageLayout({}), "missing storageLayout.storage");
}

console.log("launch config validation matrix tests passed");
