#!/usr/bin/env node

const { assertNotLegacySourceMutatingLaunchScript } = require("./lib/launch-gates");

assertNotLegacySourceMutatingLaunchScript(__filename);
