#!/usr/bin/env sh

# Usage: 
# generate.sh 15001 giltconsensus-15001

set -x #echo on

if [ -z "$1" ]
  then
    echo "Gilt chain id is required first argument"
  exit 1
fi

if [ -z "$2" ]
  then
    echo "GiltConsensus chain id is required as second argument"
  exit 1
fi

npm install
npm run truffle:compile
git submodule init
git submodule update
cd child-contracts
npm install
node scripts/process-templates.js --gilt-chain-id $1
npm run truffle:compile
cd ..
node generate-giltvalidatorset.js --gilt-chain-id $1 --giltconsensus-chain-id $2
node generate-genesis.js --gilt-chain-id $1 --giltconsensus-chain-id $2
