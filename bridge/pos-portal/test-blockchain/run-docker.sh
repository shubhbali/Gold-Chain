#!/usr/bin/env sh

docker run --name gilt-test -it -d -p 8545:8545 -v $(pwd):/giltdata giltchain/gilt:develop /bin/sh -c "cd /giltdata; sh start.sh"
