#!/usr/bin/env node

const { loadLaunchConfig, parseProfileArg, validateLaunchConfig } = require("./lib/launch-config");

try {
  const options = parseProfileArg();
  const { config, configPath } = loadLaunchConfig(options);
  validateLaunchConfig(config);
  console.log(`Launch config valid: ${config.profile} (${configPath})`);
} catch (error) {
  console.error(error.message);
  process.exit(1);
}
