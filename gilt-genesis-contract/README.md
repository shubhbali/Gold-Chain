# gilt-genesis-contracts

This repo holds the genesis contracts for Gilt Chain.

## Prepare

Install node.js dependency:
```shell script
npm install
```

Install foundry:
```shell script
curl -L https://foundry.paradigm.xyz | bash
foundryup
forge install --no-git foundry-rs/forge-std@v1.7.3
```

Install poetry:
```shell script
curl -sSL https://install.python-poetry.org | python3 -
poetry install
```

Tips: You can manage multi version of Node:
```Shell
## Install nvm and node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
nvm install 18.17.0 && nvm use 18.17.0
```

## Unit test

You can get a free archive node endpoint from https://nodereal.io/.

Run forge test:
```shell script
forge test --fork-url ${archive_node_rpc}
```

## Flatten all system contracts

```shell script
bash scripts/flatten.sh
```

All system contracts will be flattened and output into `${workspace}/contracts/flattened/`.

## How to generate genesis file

Use `launch-config/testnet.json` or `launch-config/mainnet.json` as the only
human-edited launch input. The official launch commands below validate config,
compile contracts, check ABI/storage/bytecode integrity, generate genesis, write
the launch report, and build the node.

## Final testnet/mainnet launch pipeline

Use one launch path for both public launch profiles. These commands validate
the launch config, run `forge clean`, compile the system contracts, check
canonical ABIs, check storage layouts, check runtime sizes, generate the genesis
file and launch report, then build `gilt-chain`.

```shell
npm run launch:core:testnet
npm run launch:core:mainnet
```

For config-only checks:

```shell
npm run launch:validate:testnet
npm run launch:validate:mainnet
```

For individual artifact gates after `forge build`:

```shell
npm run abi:check
npm run launch:storage
npm run launch:runtime
```

The old source-mutating `scripts.generate` / `generate.py` path and the old
`scripts/generate-genesis.js` path are disabled for production launch.

```
# you can verify the bytecode in genesis.json with solc, take ./contracts/StakeHub.sol for example:
solc-select use 0.8.17
solc --optimize --optimize-runs 200 --abi --metadata-hash none --bin-runtime ./contracts/StakeHub.sol --base-path . --include-path ./node_modules/ -o output
```

## update ABI files

```bash
npm run abi:export
```

This command regenerates all canonical system-contract ABIs, updates `abi/manifest.json`,
and rewrites `../gilt-chain/consensus/parlia/abi.go` current ABI embeddings from canonical outputs.

## How to update contract interface for test

```shell script
// get metadata
forge build

// generate interface
cast interface ${workspace}/out/{contract_name}.sol/${contract_name}.json -p ^0.8.0 -n ${contract_name} > ${workspace}/test/utils/interface/I${contract_name}.sol
```

## Gold Migration Helpers

Plain-English runbook:

- `GOLD_MIGRATION_RUNBOOK.md`
- `PhysicalGold1155` bridge ratio is immutable per deployment; ratio changes require deploying new `GOLD` and migration.

RPC scripts:

- `node scripts/activate-gold-migration.js`
- `node scripts/check-gold-migration-state.js`
- `node scripts/swap-legacy-gold.js`

## License

The library is licensed under the [Apache License, Version 2.0](https://www.apache.org/licenses/LICENSE-2.0),
also included in our repository in the [LICENSE](LICENSE) file.
