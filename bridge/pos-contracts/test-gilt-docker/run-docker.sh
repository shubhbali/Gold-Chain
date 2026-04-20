#!/usr/bin/env sh

docker run --name gilt-test -it -d -p 9545:9545 -v $(pwd):/giltdata giltchain/gilt:v0.2.8 /bin/sh -c "cd /giltdata; sh start.sh"
