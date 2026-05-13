#!/usr/bin/env node

const crypto = require("crypto");
const fs = require("fs");
const path = require("path");
const { execFileSync } = require("child_process");
const { Interface } = require("ethers");

const MONOREPO_ROOT = path.resolve(__dirname, "..", "..");
const GENESIS_ROOT = path.resolve(__dirname, "..");
const ABI_ROOT = path.join(GENESIS_ROOT, "abi");
const OUT_ROOT = path.join(GENESIS_ROOT, "out");
const MANIFEST_PATH = path.join(ABI_ROOT, "manifest.json");
const PARLIA_ABI_GO = path.join(MONOREPO_ROOT, "gilt-chain", "consensus", "parlia", "abi.go");
const GETCHAINSTATUS_PATH = path.join(MONOREPO_ROOT, "gilt-chain", "cmd", "jsutils", "getchainstatus.js");
const DEPLOY_LIVE_BRIDGE_PATH = path.join(MONOREPO_ROOT, "bridge", "pos-portal", "scripts", "deploy-live-bridge.mjs");
const LIVE_ROUGHNET_GOLD_FLOW_PATH = path.join(GENESIS_ROOT, "scripts", "live-roughnet-gold-flow.js");
const CHECK_GOLD_MIGRATION_STATE_PATH = path.join(GENESIS_ROOT, "scripts", "check-gold-migration-state.js");
const ACTIVATE_GOLD_MIGRATION_PATH = path.join(GENESIS_ROOT, "scripts", "activate-gold-migration.js");

const SYSTEM_CONTRACTS = [
  { name: "GiltValidatorSet", abiFile: "giltvalidatorset.abi", expectedSolc: "0.6.4" },
  { name: "SlashIndicator", abiFile: "slashindicator.abi", expectedSolc: "0.6.4" },
  { name: "SystemReward", abiFile: "systemreward.abi", expectedSolc: "0.6.4" },
  { name: "TendermintLightClient", abiFile: "tendermintlightclient.abi", expectedSolc: "0.6.4" },
  { name: "TokenHub", abiFile: "tokenhub.abi", expectedSolc: "0.6.4" },
  { name: "RelayerIncentivize", abiFile: "relayerincentivize.abi", expectedSolc: "0.6.4" },
  { name: "RelayerHub", abiFile: "relayerhub.abi", expectedSolc: "0.6.4" },
  { name: "GovHub", abiFile: "govhub.abi", expectedSolc: "0.6.4" },
  { name: "TokenManager", abiFile: "tokenmanager.abi", expectedSolc: "0.6.4" },
  { name: "CrossChain", abiFile: "crosschain.abi", expectedSolc: "0.6.4" },
  { name: "Staking", abiFile: "staking.abi", expectedSolc: "0.6.4" },
  { name: "StakeHub", abiFile: "stakehub.abi", expectedSolc: "0.8.17" },
  { name: "StakeCredit", abiFile: "stakecredit.abi", expectedSolc: "0.8.17" },
  { name: "GiltGovernor", abiFile: "giltgovernor.abi", expectedSolc: "0.8.17" },
  { name: "GovToken", abiFile: "govtoken.abi", expectedSolc: "0.8.17" },
  { name: "GiltTimelock", abiFile: "gilttimelock.abi", expectedSolc: "0.8.17" },
  { name: "TokenRecoverPortal", abiFile: "tokenrecoverportal.abi", expectedSolc: "0.8.17" },
];

const SOLC_VERSION_BY_PREFIX = {
  "0.6.4": "0.6.4+commit.1dca32f3",
  "0.8.17": "0.8.17+commit.8df45f5f",
};

function usage() {
  console.log(
    "Usage: node scripts/abi-integrity.js <export|check> [--skip-build] [--allow-existing-abi-fallback]",
  );
}

function parseArgs() {
  const args = process.argv.slice(2);
  if (args.length === 0) {
    usage();
    process.exit(1);
  }
  const command = args[0];
  if (command !== "export" && command !== "check") {
    usage();
    process.exit(1);
  }
  const skipBuild = args.includes("--skip-build");
  const allowExistingAbiFallback = args.includes("--allow-existing-abi-fallback");
  return { command, skipBuild, allowExistingAbiFallback };
}

function stableValue(value) {
  if (Array.isArray(value)) {
    return value.map(stableValue);
  }
  if (value && typeof value === "object") {
    const out = {};
    for (const key of Object.keys(value).sort()) {
      out[key] = stableValue(value[key]);
    }
    return out;
  }
  return value;
}

function stableJson(value) {
  return JSON.stringify(stableValue(value));
}

function sha256Hex(value) {
  return crypto.createHash("sha256").update(value).digest("hex");
}

function readJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function readText(filePath) {
  return fs.readFileSync(filePath, "utf8");
}

function writeIfChanged(filePath, content) {
  let current = null;
  if (fs.existsSync(filePath)) {
    current = fs.readFileSync(filePath, "utf8");
  }
  if (current !== content) {
    fs.mkdirSync(path.dirname(filePath), { recursive: true });
    fs.writeFileSync(filePath, content, "utf8");
    return true;
  }
  return false;
}

function runOrThrow(command, args, cwd) {
  execFileSync(command, args, {
    cwd,
    stdio: "inherit",
  });
}

function runCapture(command, args, cwd) {
  return execFileSync(command, args, {
    cwd,
    stdio: ["ignore", "pipe", "pipe"],
    encoding: "utf8",
  });
}

function artifactPath(contractName) {
  return path.join(OUT_ROOT, `${contractName}.sol`, `${contractName}.json`);
}

function compilerVersionOf(artifact) {
  if (artifact.metadata && typeof artifact.metadata === "object" && artifact.metadata.compiler) {
    return artifact.metadata.compiler.version || "";
  }
  if (typeof artifact.metadata === "string") {
    const metadata = JSON.parse(artifact.metadata);
    return metadata?.compiler?.version || "";
  }
  if (typeof artifact.rawMetadata === "string") {
    const metadata = JSON.parse(artifact.rawMetadata);
    return metadata?.compiler?.version || "";
  }
  return "";
}

function assertCompilerVersion(contractName, expectedPrefix, actualVersion) {
  if (!actualVersion || !actualVersion.startsWith(`${expectedPrefix}+`)) {
    throw new Error(
      `${contractName} compiler mismatch: expected ${expectedPrefix}.x, got "${actualVersion || "unknown"}"`,
    );
  }
}

function signatureSet(abi) {
  const iface = new Interface(abi);
  const functions = [];
  const events = [];
  const errors = [];
  for (const fragment of iface.fragments) {
    if (fragment.type === "function") {
      const signature = fragment.format("sighash");
      const selector = iface.getFunction(signature).selector;
      functions.push({ signature, selector });
      continue;
    }
    if (fragment.type === "event") {
      const signature = fragment.format("sighash");
      const topic = iface.getEvent(signature).topicHash;
      events.push({ signature, topic });
      continue;
    }
    if (fragment.type === "error") {
      const signature = fragment.format("sighash");
      const selector = iface.getError(signature).selector;
      errors.push({ signature, selector });
    }
  }
  functions.sort((a, b) => a.signature.localeCompare(b.signature));
  events.sort((a, b) => a.signature.localeCompare(b.signature));
  errors.sort((a, b) => a.signature.localeCompare(b.signature));
  return { functions, events, errors };
}

function normalizeAbi(abi) {
  return stableValue(abi);
}

function parseBacktickConst(fileContent, constantName) {
  const pattern = new RegExp(`const\\s+${constantName}\\s*=\\s*\\\`([\\s\\S]*?)\\\``);
  const match = fileContent.match(pattern);
  if (!match) {
    throw new Error(`Unable to locate ${constantName} in ${PARLIA_ABI_GO}`);
  }
  return match[1];
}

function normalizeAbiJsonString(jsonString) {
  return stableJson(JSON.parse(jsonString));
}

function failOnCaseVariantTrackedAbis() {
  const tracked = runCapture("git", ["ls-files", "abi"], GENESIS_ROOT)
    .split(/\r?\n/)
    .filter(Boolean)
    .map((line) => line.trim())
    .filter((line) => line.toLowerCase().endsWith(".abi"));

  const seenLower = new Map();
  const errors = [];
  for (const file of tracked) {
    const base = path.basename(file);
    const lower = base.toLowerCase();
    if (base !== lower) {
      errors.push(`Tracked ABI file must be lowercase: ${file}`);
    }
    const existing = seenLower.get(lower);
    if (existing && existing !== file) {
      errors.push(`Duplicate ABI track by case detected: ${existing} and ${file}`);
    } else {
      seenLower.set(lower, file);
    }
  }

  if (errors.length > 0) {
    throw new Error(errors.join("\n"));
  }
}

function assertNoManualInlineAbiArrays() {
  const systemAbiArrayPatterns = [
    /const\s+validatorSetAbi\s*=\s*\[/,
    /const\s+slashAbi\s*=\s*\[/,
    /const\s+stakeHubAbi\s*=\s*\[/,
    /const\s+liveStakeHubAbi\s*=\s*\[/,
    /const\s+govHubAbi\s*=\s*\[/,
    /const\s+governorAbi\s*=\s*\[/,
    /const\s+govTokenAbi\s*=\s*\[/,
    /const\s+timelockAbi\s*=\s*\[/,
  ];
  const checks = [
    {
      filePath: GETCHAINSTATUS_PATH,
      patterns: systemAbiArrayPatterns,
    },
    {
      filePath: DEPLOY_LIVE_BRIDGE_PATH,
      patterns: systemAbiArrayPatterns,
    },
    {
      filePath: LIVE_ROUGHNET_GOLD_FLOW_PATH,
      patterns: systemAbiArrayPatterns,
    },
    {
      filePath: CHECK_GOLD_MIGRATION_STATE_PATH,
      patterns: systemAbiArrayPatterns,
    },
    {
      filePath: ACTIVATE_GOLD_MIGRATION_PATH,
      patterns: [
        /new\s+ethers\.Interface\(\s*\[\s*['"]function\s+updateParam\(/,
      ],
    },
  ];

  const violations = [];
  for (const check of checks) {
    if (!fs.existsSync(check.filePath)) {
      continue;
    }
    const content = readText(check.filePath);
    for (const pattern of check.patterns) {
      if (pattern.test(content)) {
        violations.push(`${check.filePath} still has inline ABI arrays: ${pattern}`);
      }
    }
  }

  if (violations.length > 0) {
    throw new Error(violations.join("\n"));
  }
}

function writeParliaCurrentAbis(canonicalValidatorSetJson, canonicalStakeHubJson) {
  const currentContent = readText(PARLIA_ABI_GO);
  const beforeLuban = parseBacktickConst(currentContent, "validatorSetABIBeforeLuban");

  const next = `package parlia

// Code generated by gilt-genesis-contract/scripts/abi-integrity.js. DO NOT EDIT.

const validatorSetABIBeforeLuban = \`${beforeLuban}\`

const validatorSetABI = \`${canonicalValidatorSetJson}\`

const stakeABI = \`${canonicalStakeHubJson}\`
`;

  writeIfChanged(PARLIA_ABI_GO, next);
}

function verifyParliaCurrentAbiAlignment(canonicalValidatorSetJson, canonicalStakeHubJson) {
  const content = readText(PARLIA_ABI_GO);
  const embeddedValidatorSet = parseBacktickConst(content, "validatorSetABI");
  const embeddedStakeHub = parseBacktickConst(content, "stakeABI");

  const canonicalValidatorSet = normalizeAbiJsonString(canonicalValidatorSetJson);
  const canonicalStakeHub = normalizeAbiJsonString(canonicalStakeHubJson);

  const embeddedValidatorSetNormalized = normalizeAbiJsonString(embeddedValidatorSet);
  const embeddedStakeHubNormalized = normalizeAbiJsonString(embeddedStakeHub);

  if (embeddedValidatorSetNormalized !== canonicalValidatorSet) {
    throw new Error("Parlia validatorSetABI does not match canonical giltvalidatorset.abi");
  }
  if (embeddedStakeHubNormalized !== canonicalStakeHub) {
    throw new Error("Parlia stakeABI does not match canonical stakehub.abi");
  }
}

function exportCanonicalAbis({ skipBuild, allowExistingAbiFallback }) {
  if (!skipBuild) {
    runOrThrow("forge", ["build"], GENESIS_ROOT);
  }

  const manifestContracts = [];
  const generatedAbiByFile = new Map();

  for (const contract of SYSTEM_CONTRACTS) {
    const aPath = artifactPath(contract.name);
    let compilerVersion = "";
    let normalizedAbi;
    if (fs.existsSync(aPath)) {
      const artifact = readJson(aPath);
      compilerVersion = compilerVersionOf(artifact);
      assertCompilerVersion(contract.name, contract.expectedSolc, compilerVersion);
      normalizedAbi = normalizeAbi(artifact.abi);
    } else {
      if (!allowExistingAbiFallback) {
        throw new Error(`Missing artifact: ${aPath}. Run forge build first.`);
      }
      const existingAbiPath = path.join(ABI_ROOT, contract.abiFile);
      if (!fs.existsSync(existingAbiPath)) {
        throw new Error(`Missing artifact and fallback ABI: ${aPath} and ${existingAbiPath}`);
      }
      compilerVersion = SOLC_VERSION_BY_PREFIX[contract.expectedSolc] || `${contract.expectedSolc}+fallback`;
      normalizedAbi = normalizeAbi(readJson(existingAbiPath));
    }
    const abiJson = `${JSON.stringify(normalizedAbi)}\n`;
    const abiPath = path.join(ABI_ROOT, contract.abiFile);
    writeIfChanged(abiPath, abiJson);

    const signatures = signatureSet(normalizedAbi);
    manifestContracts.push({
      contract: contract.name,
      abiFile: contract.abiFile,
      compilerVersion,
      expectedCompilerVersion: contract.expectedSolc,
      abiSha256: sha256Hex(JSON.stringify(normalizedAbi)),
      selectors: signatures,
    });
    generatedAbiByFile.set(contract.abiFile, JSON.stringify(normalizedAbi));
  }

  manifestContracts.sort((a, b) => a.contract.localeCompare(b.contract));
  const manifest = {
    schemaVersion: 1,
    source: "gilt-genesis-contract/out/*",
    generator: "scripts/abi-integrity.js",
    contracts: manifestContracts,
  };
  writeIfChanged(MANIFEST_PATH, `${JSON.stringify(stableValue(manifest), null, 2)}\n`);

  const canonicalValidatorSetJson = generatedAbiByFile.get("giltvalidatorset.abi");
  const canonicalStakeHubJson = generatedAbiByFile.get("stakehub.abi");
  if (!canonicalValidatorSetJson || !canonicalStakeHubJson) {
    throw new Error("Canonical StakeHub/GiltValidatorSet ABI export missing");
  }

  writeParliaCurrentAbis(canonicalValidatorSetJson, canonicalStakeHubJson);
  verifyParliaCurrentAbiAlignment(canonicalValidatorSetJson, canonicalStakeHubJson);
  assertNoManualInlineAbiArrays();
  failOnCaseVariantTrackedAbis();
}

function assertGitCleanAfterRegeneration() {
  const trackedTargets = [
    "abi",
    "scripts/abi-integrity.js",
    "scripts/live-roughnet-gold-flow.js",
    "scripts/check-gold-migration-state.js",
    "scripts/activate-gold-migration.js",
    "../gilt-chain/consensus/parlia/abi.go",
    "../gilt-chain/cmd/jsutils/getchainstatus.js",
    "../bridge/pos-portal/scripts/deploy-live-bridge.mjs",
  ];

  const status = runCapture("git", ["status", "--short", "--", ...trackedTargets], GENESIS_ROOT)
    .split(/\r?\n/)
    .filter(Boolean);

  if (status.length > 0) {
    throw new Error(
      `ABI regeneration produced uncommitted changes. Run npm run abi:export and commit results.\n${status.join("\n")}`,
    );
  }
}

function main() {
  const { command, skipBuild, allowExistingAbiFallback } = parseArgs();
  exportCanonicalAbis({ skipBuild, allowExistingAbiFallback });
  if (command === "check") {
    assertGitCleanAfterRegeneration();
  }
  console.log(`ABI integrity ${command} completed successfully.`);
}

main();
