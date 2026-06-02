#!/usr/bin/env node

const fs = require("fs");
const nunjucks = require("nunjucks");
const path = require("path");
const web3 = require("web3");

const { readSystemArtifacts, runtimeBytecodeBytes } = require("./lib/launch-artifacts");
const { launchSummary, renderMarkdownReport } = require("./lib/launch-report");
const { buildLaunchGenesisState } = require("./lib/launch-storage");
const {
  GENESIS_ROOT,
  initHoldersForGenesis,
  loadLaunchConfig,
  parseProfileArg,
  resolveFromRoot,
  sha256Hex,
  validateLaunchConfig,
  validatorExtraData,
} = require("./lib/launch-config");

try {
  const options = parseProfileArg();
  const { config, configPath } = loadLaunchConfig(options);
  validateLaunchConfig(config);

  const systemArtifacts = readSystemArtifacts();
  const { data: artifactData } = systemArtifacts;
  const launchGenesisState = buildLaunchGenesisState(config, systemArtifacts.rawArtifacts.physicalGold1155);
  artifactData.physicalGold1155 = launchGenesisState.physicalGoldBytecode;
  systemArtifacts.hashes.physicalGold1155.sha256 = sha256Hex(launchGenesisState.physicalGoldBytecode);
  systemArtifacts.hashes.physicalGold1155.runtimeBytecodeBytes = runtimeBytecodeBytes(
    launchGenesisState.physicalGoldBytecode,
  );
  systemArtifacts.hashes.physicalGold1155.patchedLaunchImmutables = true;
  const goldPredeploy = systemArtifacts.predeploys.find((predeploy) => predeploy.name === "physicalGold1155");
  if (goldPredeploy) {
    goldPredeploy.address = config.gold.address;
    goldPredeploy.sha256 = systemArtifacts.hashes.physicalGold1155.sha256;
    goldPredeploy.runtimeBytecodeBytes = systemArtifacts.hashes.physicalGold1155.runtimeBytecodeBytes;
    goldPredeploy.patchedLaunchImmutables = true;
  }
  const outputPath = resolveFromRoot(options.outputPath || config.genesisOutput);
  const templatePath = resolveFromRoot(config.genesisTemplate);
  const reportPath = resolveFromRoot(options.reportPath || config.reportOutput);

  const template = fs.readFileSync(templatePath, "utf8");
  const rendered = nunjucks.renderString(template, {
    ...artifactData,
    chainId: config.chainId,
    initHolders: initHoldersForGenesis(config),
    extraData: web3.utils.bytesToHex(validatorExtraData(config)),
    goldAddress: launchGenesisState.goldAddress,
    validatorSetGenesisStorage: JSON.stringify(launchGenesisState.validatorSetStorage, null, 6),
    stakeHubGenesisStorage: JSON.stringify(launchGenesisState.stakeHubStorage, null, 6),
    physicalGoldGenesisStorage: JSON.stringify(launchGenesisState.physicalGoldStorage, null, 6),
  });

  JSON.parse(rendered);
  fs.writeFileSync(outputPath, rendered);

  const summary = launchSummary(config, configPath, outputPath, systemArtifacts);
  fs.writeFileSync(reportPath, renderMarkdownReport(summary));

  console.log(`Generated genesis: ${path.relative(GENESIS_ROOT, outputPath)}`);
  console.log(`Generated launch report: ${path.relative(GENESIS_ROOT, reportPath)}`);
} catch (error) {
  console.error(error.message);
  process.exit(1);
}
