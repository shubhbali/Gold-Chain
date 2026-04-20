# Gilt Bridge contracts

Ethereum smart contracts that power the Gilt Chain bridge stack.

## Development
### Install dependencies with

```
npm install
```

### Setup git hooks

```
pre-commit install
```

### Prepare templates

```
npm run template:process -- --gilt-chain-id 15001
```

gilt-chain-id should be:
**local: 15001**  
Mainnet = 137  
Testnet = 80001

### Generate interfaces

```
npm run generate:interfaces
```

### Build

```
forge build
```

## Testing

### Run forge upgrade forktest

```
forge test
```

### Run unit tests


#### Main chain and side chain

- Main chain

All tests are run against a fork of mainnet using Hardhat's forking functionality. No need to run any local chain!

- Start child side chain. Requires docker.

```
npm run gilt:simulate
```

- Stop with

```
npm run gilt:stop
```

- If you want a clean chain, this also deletes your /data folder containing the chain state.

```
npm run gilt:clean
```

#### Run tests

Run Hardhat test

```
npm run test:hardhat
```

### Coverage

Run coverage with

```
npm run coverage
```

## Contact

For more discussions, use your project's internal engineering communication channels.
