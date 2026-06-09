# Genesis Source of Truth Moved

The old checked-in `genesis*.json` files in this directory were deleted during the production overhaul because they mixed BSC chain ID `56`, Rialto/fork-test settings, and compressed persistent-testnet fork schedules.

Canonical Gold Chain genesis is now generated from:

- `chain/spec/gold-mainnet.yaml`
- `chain/spec/gold-testnet.yaml`
- `chain/genesis/build-genesis.js`

Generate outputs with:

```bash
node chain/genesis/build-genesis.js --network testnet
node chain/genesis/build-genesis.js --network mainnet
```

Generated files are written under `chain/genesis/out/<network>/` and must pass:

```bash
node chain/scripts/preflight-validators.js \
  --genesis chain/genesis/out/testnet/genesis.json \
  --validators chain/genesis/out/testnet/validators.conf
```
