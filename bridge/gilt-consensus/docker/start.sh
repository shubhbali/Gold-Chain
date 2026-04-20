#!/usr/bin/env sh

# Start giltconsensus.
giltconsd start --all --bridge --rest-server --home $GILTCONSENSUS_DIR >./logs/giltconsd.log

# Tail logs.
tail -f ./logs/giltconsd.log
