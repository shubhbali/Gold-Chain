#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const { readSystemArtifacts } = require("./lib/launch-artifacts");
const { launchSummary, renderMarkdownReport } = require("./lib/launch-report");
const {
  GENESIS_ROOT,
  loadLaunchConfig,
  parseProfileArg,
  resolveFromRoot,
  validateLaunchConfig,
} = require("./lib/launch-config");

try {
  const options = parseProfileArg();
  const { config, configPath } = loadLaunchConfig(options);
  validateLaunchConfig(config);

  const systemArtifacts = readSystemArtifacts();
  const genesisPath = resolveFromRoot(options.outputPath || config.genesisOutput);
  const summary = launchSummary(config, configPath, genesisPath, systemArtifacts);
  const report = options.json ? `${JSON.stringify(summary, null, 2)}\n` : renderMarkdownReport(summary);

  if (options.reportPath) {
    const reportPath = resolveFromRoot(options.reportPath);
    fs.writeFileSync(reportPath, report);
    console.log(`Wrote launch report: ${path.relative(GENESIS_ROOT, reportPath)}`);
  } else {
    process.stdout.write(report);
  }
} catch (error) {
  console.error(error.message);
  process.exit(1);
}
