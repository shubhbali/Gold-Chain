#!/usr/bin/env node

const { readSystemArtifacts } = require("./lib/launch-artifacts");

try {
  const { predeploys } = readSystemArtifacts();
  for (const predeploy of predeploys) {
    console.log(
      `${predeploy.contract} runtime size OK: ${predeploy.runtimeBytecodeBytes} bytes (${predeploy.classification})`,
    );
  }
} catch (error) {
  console.error(error.message);
  process.exit(1);
}
