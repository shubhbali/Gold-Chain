#!/bin/bash
#
###################
# Remove giltconsensus profile installation
###################
sudo rm /var/lib/gilt-consensus/config/app.toml
sudo rm /var/lib/gilt-consensus/config/config.toml
sudo rm /var/lib/gilt-consensus/config/client.toml
sudo systemctl daemon-reload
