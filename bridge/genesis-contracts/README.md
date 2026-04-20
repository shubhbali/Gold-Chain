# genesis-contracts

> NOTE (IMPORTANT!)
> If you modify contracts, run `forge build` before testing/deploying/etc, or Foundry may not recompile them!

#### Setup genesis

Setup genesis whenever contracts get changed
### 1. Install dependencies and submodules
```bash
npm install
git submodule init
git submodule update
```

### 2. Compile child contracts
```bash
cd child-contracts
npm install
node scripts/process-templates.js --gilt-chain-id <gilt-chain-id>
npm run truffle:compile
cd ..
```

### 3. Generate Gilt validator set sol file

Following command will generate `GiltValidatorSet.sol` file from `GiltValidatorSet.template` file.

```bash
# Generate gilt validator set using stake and balance
# Modify validators.json before as per your need
$ node generate-giltvalidatorset.js --gilt-chain-id <gilt-chain-id> --giltconsensus-chain-id <giltconsensus-chain-id>
```

### 4. Compile contracts
```bash
$ npm run truffle:compile
```

### 5. Configure Block times

To add custom block time and associated block no.s in genesis, edit the `blocks.js` file

### 6. Generate genesis file

Following command will generate `genesis.json` file from `genesis-template.json` file.

```bash
# Generate genesis file
node generate-genesis.js --gilt-chain-id <gilt-chain-id> --giltconsensus-chain-id <giltconsensus-chain-id>
```

### 7. Run Tests
```bash
$ npm run testrpc
$ npm test
```
