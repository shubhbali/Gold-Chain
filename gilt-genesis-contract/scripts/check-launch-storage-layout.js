#!/usr/bin/env node

const { readSystemArtifacts } = require("./lib/launch-artifacts");

try {
  const { predeploys } = readSystemArtifacts();
  const checked = predeploys.filter((predeploy) => predeploy.storageLayoutHash);
  const required = new Set(["validatorContract", "stakeHub", "physicalGold1155"]);

  for (const name of required) {
    if (!checked.some((predeploy) => predeploy.name === name)) {
      throw new Error(`missing required storage layout gate for ${name}`);
    }
  }

  for (const predeploy of checked) {
    console.log(
      `${predeploy.contract} storage layout OK: ${predeploy.storageLayoutHash} (${predeploy.storageLayoutCheck.length} launch fields)`,
    );
  }
} catch (error) {
  console.error(error.message);
  process.exit(1);
}
