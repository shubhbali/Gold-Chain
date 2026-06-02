const fs = require("fs");
const path = require("path");

const { PREDEPLOY_CLASSIFICATIONS, runtimeBytecodeBytes } = require("./launch-artifacts");
const { assertNoActiveCoreOldBscBridgeMachinery } = require("./launch-gates");
const { GENESIS_ROOT, sha256Hex, stableJson, validatorExtraData, validatorSetBytes } = require("./launch-config");
const {
  GILT_VALIDATOR_SET_SLOTS,
  STAKE_HUB_ADDRESS,
  VALIDATOR_SET_ADDRESS,
  buildGiltValidatorSetStorage,
  hex32,
  normalizeStorageForHash,
} = require("./launch-storage");
const { STAKE_HUB_SLOTS } = require("./stakehub-storage-layout");

function relativeToRoot(filePath) {
  return path.relative(GENESIS_ROOT, filePath).replace(/\\/g, "/");
}

function validatorsForReport(config) {
  return config.validators.map((validator) => ({
    consensusAddress: validator.consensusAddress,
    feeAddress: validator.feeAddress,
    giltFeeAddress: validator.giltFeeAddress,
    votingPower: validator.votingPower,
    blsPublicKey: validator.blsPublicKey,
  }));
}

function normalizeArtifactInput(systemArtifacts = {}) {
  if (systemArtifacts.hashes || systemArtifacts.artifacts) {
    return {
      hashes: systemArtifacts.hashes || {},
      artifacts: systemArtifacts.artifacts || [],
      predeploys: systemArtifacts.predeploys || [],
    };
  }
  return {
    hashes: systemArtifacts,
    artifacts: [],
    predeploys: [],
  };
}

function assertZeroBalance(balance, label) {
  if (!balance || String(balance).toLowerCase() === "0x0") {
    return;
  }
  if (BigInt(balance) === 0n) {
    return;
  }
  throw new Error(`${label} must have zero genesis balance`);
}

function assertPredeployClassifications(predeploys) {
  if (!Array.isArray(predeploys) || predeploys.length === 0) {
    throw new Error("missing launch predeploy classification data");
  }

  assertNoActiveCoreOldBscBridgeMachinery(predeploys, "launch predeploy table");

  const seen = new Set();
  for (const predeploy of predeploys) {
    if (!predeploy.name || !predeploy.contract) {
      throw new Error("launch predeploy classification is missing name or contract");
    }
    if (!Object.values(PREDEPLOY_CLASSIFICATIONS).includes(predeploy.classification)) {
      throw new Error(`launch predeploy ${predeploy.name} has invalid classification: ${predeploy.classification}`);
    }
    const address = String(predeploy.address || "").toLowerCase();
    if (!/^0x[0-9a-f]{40}$/.test(address)) {
      throw new Error(`launch predeploy ${predeploy.name} has invalid address: ${predeploy.address || "not set"}`);
    }
    if (seen.has(address)) {
      throw new Error(`duplicate launch predeploy address: ${predeploy.address}`);
    }
    seen.add(address);
  }
}

function assertGenesisPredeploys(alloc, predeploys) {
  const findAlloc = (address) => alloc[address] || alloc[String(address).toLowerCase()] || alloc[String(address).replace(/^0x/i, "")];
  const genesisPredeploys = [];

  for (const predeploy of predeploys) {
    const allocEntry = findAlloc(predeploy.address);
    if (!allocEntry?.code) {
      throw new Error(`launch genesis is missing predeploy code for ${predeploy.contract} at ${predeploy.address}`);
    }

    const codeHash = sha256Hex(allocEntry.code);
    const codeBytes = runtimeBytecodeBytes(allocEntry.code);
    if (codeBytes <= 0) {
      throw new Error(`launch genesis predeploy ${predeploy.contract} at ${predeploy.address} has empty runtime bytecode`);
    }
    const expectedHash = predeploy.patchedLaunchImmutables ? null : predeploy.sha256;
    if (expectedHash && codeHash !== expectedHash) {
      throw new Error(
        `launch genesis predeploy ${predeploy.contract} at ${predeploy.address} has bytecode hash ${codeHash}, expected ${expectedHash}`,
      );
    }
    if (predeploy.classification === PREDEPLOY_CLASSIFICATIONS.RESERVED_INERT) {
      assertZeroBalance(allocEntry.balance, `reserved inert predeploy ${predeploy.contract} at ${predeploy.address}`);
    }

    genesisPredeploys.push({
      ...predeploy,
      sha256: codeHash,
      runtimeBytecodeBytes: codeBytes,
    });
  }

  return genesisPredeploys;
}

function assertValidatorBootstrapStorage(config, validatorAlloc, genesisPath) {
  if (!validatorAlloc?.code || !validatorAlloc?.storage) {
    throw new Error(
      `stale launch genesis artifact: ${relativeToRoot(genesisPath)} does not include GiltValidatorSet bootstrap storage at ${VALIDATOR_SET_ADDRESS}`,
    );
  }

  const expectedStorage = buildGiltValidatorSetStorage(config);
  const expectedHash = expectedStorage[hex32(GILT_VALIDATOR_SET_SLOTS.validatorBootstrapHash)];
  const actualHash = validatorAlloc.storage[hex32(GILT_VALIDATOR_SET_SLOTS.validatorBootstrapHash)];
  if (String(actualHash || "").toLowerCase() !== expectedHash.toLowerCase()) {
    throw new Error(
      `stale launch genesis artifact: ${relativeToRoot(genesisPath)} validator bootstrap hash does not match launch config`,
    );
  }

  const actual = normalizeStorageForHash(validatorAlloc.storage);
  const expected = normalizeStorageForHash(expectedStorage);
  if (stableJson(actual) !== stableJson(expected)) {
    throw new Error(
      `stale launch genesis artifact: ${relativeToRoot(genesisPath)} validator bootstrap storage does not match launch config`,
    );
  }

  return { validatorBootstrapHash: String(expectedHash).replace(/^0x/i, "") };
}

function assertGenesisFresh(config, configPath, genesisPath, artifacts, predeploys) {
  if (!genesisPath || !fs.existsSync(genesisPath)) {
    throw new Error(`missing launch genesis artifact: ${genesisPath || "not set"}`);
  }

  const genesisText = fs.readFileSync(genesisPath, "utf8");
  const genesis = JSON.parse(genesisText);
  const expectedExtraData = `0x${validatorExtraData(config).toString("hex")}`;

  if (genesis?.config?.chainId !== config.chainId) {
    throw new Error(
      `stale launch genesis artifact: ${relativeToRoot(genesisPath)} has chainId ${genesis?.config?.chainId}, expected ${config.chainId}`,
    );
  }
  if (String(genesis.extraData || "").toLowerCase() !== expectedExtraData.toLowerCase()) {
    throw new Error(`stale launch genesis artifact: ${relativeToRoot(genesisPath)} validator extraData does not match launch config`);
  }

  const alloc = genesis.alloc || {};
  const findAlloc = (address) => alloc[address] || alloc[String(address).toLowerCase()] || alloc[String(address).replace(/^0x/i, "")];
  assertPredeployClassifications(predeploys);
  const validatorBootstrap = assertValidatorBootstrapStorage(config, findAlloc(VALIDATOR_SET_ADDRESS), genesisPath);
  const goldAlloc = findAlloc(config.gold.address);
  if (!goldAlloc?.code || !goldAlloc?.storage) {
    throw new Error(`stale launch genesis artifact: ${relativeToRoot(genesisPath)} does not predeploy launch GOLD at ${config.gold.address}`);
  }

  const stakeHubAlloc = findAlloc(STAKE_HUB_ADDRESS);
  const stakeHubGoldSlot = stakeHubAlloc?.storage?.[hex32(STAKE_HUB_SLOTS.stakeTokenB)];
  if (String(stakeHubGoldSlot || "").toLowerCase() !== hex32(BigInt(config.gold.address)).toLowerCase()) {
    throw new Error(
      `stale launch genesis artifact: ${relativeToRoot(genesisPath)} does not wire StakeHub to launch GOLD ${config.gold.address}`,
    );
  }

  const genesisStat = fs.statSync(genesisPath);
  const configStat = fs.statSync(configPath);
  if (configStat.mtimeMs > genesisStat.mtimeMs) {
    throw new Error(
      `stale launch genesis artifact: ${relativeToRoot(genesisPath)} is older than ${relativeToRoot(configPath)}`,
    );
  }

  for (const artifact of artifacts) {
    if (artifact.artifactMtimeMs && artifact.artifactMtimeMs > genesisStat.mtimeMs) {
      throw new Error(
        `stale launch genesis artifact: ${relativeToRoot(genesisPath)} is older than ${artifact.artifactPath}`,
      );
    }
  }

  return {
    genesisText,
    goldBytecode: goldAlloc.code,
    predeploys: assertGenesisPredeploys(alloc, predeploys),
    validatorBootstrap,
  };
}

function launchSummary(config, configPath, genesisPath, systemArtifacts = {}) {
  const { hashes: artifactHashesRaw, artifacts, predeploys } = normalizeArtifactInput(systemArtifacts);
  const artifactHashes = JSON.parse(JSON.stringify(artifactHashesRaw));
  if (Object.keys(artifactHashes).length === 0) {
    throw new Error("missing system contract artifact hashes for launch report");
  }
  assertNoActiveCoreOldBscBridgeMachinery(artifactHashes, "launch artifact hashes");
  if (artifactHashes.physicalGold1155) {
    artifactHashes.physicalGold1155.address = config.gold.address;
  }
  const resolvedPredeploys = predeploys.map((predeploy) =>
    predeploy.name === "physicalGold1155" && !predeploy.address
      ? { ...predeploy, address: config.gold.address }
      : predeploy,
  );

  const configText = fs.readFileSync(configPath, "utf8");
  const {
    genesisText,
    goldBytecode,
    predeploys: genesisPredeploys,
    validatorBootstrap,
  } = assertGenesisFresh(config, configPath, genesisPath, artifacts, resolvedPredeploys);
  if (artifactHashes.physicalGold1155) {
    artifactHashes.physicalGold1155.sha256 = sha256Hex(goldBytecode);
    artifactHashes.physicalGold1155.runtimeBytecodeBytes = runtimeBytecodeBytes(goldBytecode);
    artifactHashes.physicalGold1155.patchedLaunchImmutables = true;
  }
  const totalGiltAllocationWei = config.gilt.allocations
    .reduce((sum, allocation) => sum + BigInt(allocation.balanceWei), 0n)
    .toString();

  return {
    profile: config.profile,
    chainId: config.chainId,
    sourceChainId: config.sourceChainId,
    configPath: relativeToRoot(configPath),
    configHash: sha256Hex(stableJson(JSON.parse(configText))),
    genesisPath: relativeToRoot(genesisPath),
    genesisHash: sha256Hex(genesisText),
    totalGiltAllocationWei,
    giltInflation: config.gilt.inflation,
    staking: config.staking,
    gold: config.gold,
    migration: config.migration,
    governance: config.governance,
    validators: validatorsForReport(config),
    allocations: config.gilt.allocations,
    validatorSetBytesHash: sha256Hex(validatorSetBytes(config)),
    validatorBootstrapHash: validatorBootstrap.validatorBootstrapHash,
    extraDataHash: sha256Hex(validatorExtraData(config).toString("hex")),
    artifactHashes,
    predeploys: genesisPredeploys,
  };
}

function renderMarkdownReport(summary) {
  assertNoActiveCoreOldBscBridgeMachinery(summary.artifactHashes, "launch report artifact hashes");
  assertNoActiveCoreOldBscBridgeMachinery(summary.predeploys, "launch report predeploy table");

  const lines = [];
  lines.push(`# Gold Chain Launch Report: ${summary.profile}`);
  lines.push("");
  lines.push(`- Chain ID: ${summary.chainId}`);
  lines.push(`- Source chain ID: ${summary.sourceChainId}`);
  lines.push(`- Config: ${summary.configPath}`);
  lines.push(`- Config hash: ${summary.configHash}`);
  lines.push(`- Genesis: ${summary.genesisPath}`);
  lines.push(`- Genesis hash: ${summary.genesisHash}`);
  lines.push(`- Validator set bytes hash: ${summary.validatorSetBytesHash}`);
  lines.push(`- Validator bootstrap hash: ${summary.validatorBootstrapHash}`);
  lines.push(`- Extra data hash: ${summary.extraDataHash}`);
  lines.push("");
  lines.push("## Required Launch Features");
  lines.push("");
  lines.push(`- Total allocated GILT wei: ${summary.totalGiltAllocationWei}`);
  lines.push(`- GILT inflation: ${summary.giltInflation.enabled ? "ON" : "OFF"} from ${summary.giltInflation.starts}`);
  lines.push(`- GILT reward source: ${summary.giltInflation.rewardSource}`);
  lines.push(`- GILT inflation base supply wei: ${summary.giltInflation.baseSupplyWei}`);
  lines.push(`- GILT inflation initial rate: ${summary.giltInflation.initialRateBps} bps`);
  lines.push(`- GILT inflation minimum rate: ${summary.giltInflation.minimumRateBps} bps`);
  lines.push(`- GILT inflation yearly decay: ${summary.giltInflation.decayBpsPerYear} bps`);
  lines.push(`- GILT staking: ${summary.staking.giltStakingEnabled ? "ON" : "OFF"}`);
  lines.push(`- GOLD staking: ${summary.staking.goldStakingEnabled ? "ON" : "OFF"} from day one`);
  lines.push(`- GOLD staking rewards: ${summary.staking.goldRewardSource}`);
  lines.push(`- GOLD reward split: ${summary.staking.goldRewardSplitBps} bps`);
  lines.push(`- Staking unbond period: ${summary.staking.unbondPeriod}`);
  lines.push(`- Slash reserve vault: ${summary.staking.slashReserveVault}`);
  lines.push(`- Max elected validators: ${summary.staking.maxElectedValidators}`);
  lines.push(`- GOLD contract address: ${summary.gold.address}`);
  lines.push(`- GOLD admin: ${summary.gold.admin}`);
  lines.push(`- GOLD bridge depositor: ${summary.gold.bridgeDepositor}`);
  lines.push(`- GOLD type: ${summary.gold.type}`);
  lines.push(`- GOLD emits GOLD rewards: ${summary.gold.emitsGoldRewards}`);
  lines.push(`- PAXG-backed GOLD token ID: ${summary.gold.tokenIds.paxgBacked}`);
  lines.push(`- XAUT-backed GOLD token ID: ${summary.gold.tokenIds.xautBacked}`);
  lines.push(
    `- GOLD route lock: ${summary.gold.routePrecisionFinalizedAtLaunch ? "LOCKED" : "UNLOCKED"} (PAXG/XAUT precision finalized)`,
  );
  lines.push(`- GOLD route precision finalized at launch: ${summary.gold.routePrecisionFinalizedAtLaunch}`);
  lines.push(`- GOLD bridge deposits closed at launch: ${summary.gold.bridgeDepositsClosedAtLaunch}`);
  lines.push(`- GOLD migration minting enabled at launch: ${summary.gold.migrationMintingEnabledAtLaunch}`);
  lines.push(`- Migration at launch: ${summary.migration.launchState}`);
  lines.push(`- Ratio enforcement at launch: ${summary.staking.ratioEnabledAtLaunch ? "ON" : "OFF"}`);
  lines.push(`- PAXG route: rootDecimals=${summary.gold.routes.paxg.rootDecimals}, goldDecimals=${summary.gold.routes.paxg.goldDecimals}, scale=${summary.gold.routes.paxg.scaleNumerator}/${summary.gold.routes.paxg.scaleDenominator}, rootUnit=${summary.gold.routes.paxg.rootUnit}`);
  lines.push(`- XAUT route: rootDecimals=${summary.gold.routes.xaut.rootDecimals}, goldDecimals=${summary.gold.routes.xaut.goldDecimals}, scale=${summary.gold.routes.xaut.scaleNumerator}/${summary.gold.routes.xaut.scaleDenominator}, rootUnit=${summary.gold.routes.xaut.rootUnit}`);
  lines.push("");
  lines.push("## GILT Allocations");
  lines.push("");
  lines.push(`- Total allocated GILT wei: ${summary.totalGiltAllocationWei}`);
  for (const allocation of summary.allocations) {
    lines.push(`- ${allocation.address}: ${allocation.balanceWei}`);
  }
  lines.push("");
  lines.push("## Validators");
  lines.push("");
  for (const validator of summary.validators) {
    lines.push(
      `- ${validator.consensusAddress}: votingPower=${validator.votingPower}, fee=${validator.feeAddress}, giltFee=${validator.giltFeeAddress}, bls=${validator.blsPublicKey}`,
    );
  }
  lines.push("");
  lines.push("## Governance");
  lines.push("");
  lines.push(`- StakeHub protector: ${summary.governance.stakeHubProtector}`);
  lines.push(`- Governor protector: ${summary.governance.governorProtector}`);
  lines.push("");
  lines.push("## System Predeploys");
  lines.push("");
  lines.push("| Contract | Address | Classification | Runtime bytes | Code hash | Artifact |");
  lines.push("| --- | --- | --- | ---: | --- | --- |");
  for (const predeploy of summary.predeploys) {
    const patchNote = predeploy.patchedLaunchImmutables ? " launch immutables patched" : "";
    lines.push(
      `| ${predeploy.contract} | ${predeploy.address} | ${predeploy.classification} | ${predeploy.runtimeBytecodeBytes} | ${predeploy.sha256} | ${predeploy.path}${patchNote} |`,
    );
  }
  lines.push("");
  lines.push("## System Contract Bytecode Hashes");
  lines.push("");
  for (const [name, artifact] of Object.entries(summary.artifactHashes)) {
    const patchNote = artifact.patchedLaunchImmutables ? ", launch immutables patched" : "";
    lines.push(
      `- ${name}: ${artifact.sha256} (${artifact.path}, ${artifact.classification}, ${artifact.runtimeBytecodeBytes} bytes${patchNote})`,
    );
  }
  lines.push("");
  lines.push("## Storage Layout Hashes");
  lines.push("");
  for (const predeploy of summary.predeploys.filter((entry) => entry.storageLayoutHash)) {
    lines.push(
      `- ${predeploy.contract}: ${predeploy.storageLayoutHash} (${predeploy.storageLayoutCheck.length} launch fields, ${predeploy.classification})`,
    );
  }
  lines.push("");
  return `${lines.join("\n")}\n`;
}

module.exports = {
  launchSummary,
  renderMarkdownReport,
};
