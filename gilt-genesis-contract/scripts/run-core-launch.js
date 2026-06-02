#!/usr/bin/env node

const { execFileSync } = require("child_process");
const fs = require("fs");
const path = require("path");

const { GENESIS_ROOT, loadLaunchConfig, parseProfileArg, validateLaunchConfig } = require("./lib/launch-config");
const { assertNoLegacySourceMutatingLaunchInvocation } = require("./lib/launch-gates");

function run(command, args, cwd, options = {}) {
  assertNoLegacySourceMutatingLaunchInvocation(command, args, cwd);
  console.log(`> ${command} ${args.join(" ")}`);
  execFileSync(command, args, { cwd, stdio: "inherit", env: options.env || process.env });
}

function hasExecutableOnPath(executable, env) {
  const pathValue = env.Path || env.PATH || "";
  const extensions = process.platform === "win32" ? [".exe", ".cmd", ".bat", ""] : [""];
  for (const entry of pathValue.split(path.delimiter)) {
    if (!entry) {
      continue;
    }
    for (const extension of extensions) {
      if (fs.existsSync(path.join(entry, `${executable}${extension}`))) {
        return true;
      }
    }
  }
  return false;
}

function localCompilerBins() {
  const bins = [];
  if (process.env.GOLD_CHAIN_MINGW_BIN) {
    bins.push(process.env.GOLD_CHAIN_MINGW_BIN);
  }
  if (process.env.W64DEVKIT_HOME) {
    bins.push(path.join(process.env.W64DEVKIT_HOME, "bin"));
  }
  if (process.env.LOCALAPPDATA) {
    bins.push(
      path.join(process.env.LOCALAPPDATA, "CodexTools", "w64devkit-1.23.0", "w64devkit", "bin"),
      path.join(process.env.LOCALAPPDATA, "CodexTools", "w64devkit", "bin"),
    );
  }
  return bins.filter((bin) => fs.existsSync(path.join(bin, process.platform === "win32" ? "gcc.exe" : "gcc")));
}

function goBuildEnv() {
  const env = { ...process.env, CGO_ENABLED: "1" };
  for (const bin of localCompilerBins()) {
    env.Path = `${bin}${path.delimiter}${env.Path || env.PATH || ""}`;
    env.PATH = env.Path;
    break;
  }
  if (!hasExecutableOnPath("gcc", env)) {
    throw new Error(
      "gilt-chain build requires GCC for CGO/BLS. Install MinGW-w64 or set GOLD_CHAIN_MINGW_BIN to a bin directory containing gcc.",
    );
  }
  env.CC = env.CC || "gcc";
  env.CXX = env.CXX || "g++";
  return env;
}

function profileArgs(options, config, includeOutputs = false) {
  const args = ["--profile", config.profile];
  if (options.configPath) {
    args.push("--config", options.configPath);
  }
  if (includeOutputs && options.outputPath) {
    args.push("--output", options.outputPath);
  }
  if (includeOutputs && options.reportPath) {
    args.push("--report", options.reportPath);
  }
  return args;
}

function reportGateArgs(options, config) {
  const args = profileArgs(options, config);
  if (options.outputPath) {
    args.push("--output", options.outputPath);
  }
  args.push("--json");
  return args;
}

try {
  const options = parseProfileArg();
  const { config } = loadLaunchConfig(options);
  const validationArgs = profileArgs(options, config);
  const generationArgs = profileArgs(options, config, true);
  const reportArgs = reportGateArgs(options, config);

  validateLaunchConfig(config);
  run("node", ["scripts/validate-launch-config.js", ...validationArgs], GENESIS_ROOT);
  run("forge", ["clean"], GENESIS_ROOT);
  run("forge", ["build"], GENESIS_ROOT);
  run("node", ["scripts/abi-integrity.js", "check", "--skip-build"], GENESIS_ROOT);
  run("node", ["scripts/check-launch-storage-layout.js"], GENESIS_ROOT);
  run("node", ["scripts/check-launch-runtime-size.js"], GENESIS_ROOT);
  run("node", ["scripts/generate-launch-genesis.js", ...generationArgs], GENESIS_ROOT);
  run("node", ["scripts/print-launch-report.js", ...reportArgs], GENESIS_ROOT);

  const chainRoot = path.resolve(GENESIS_ROOT, "..", "gilt-chain");
  run("go", ["run", "build/ci.go", "install", "./cmd/geth"], chainRoot, { env: goBuildEnv() });

  console.log(`Core launch pipeline completed for ${config.profile}`);
} catch (error) {
  console.error(error.message);
  process.exit(1);
}
