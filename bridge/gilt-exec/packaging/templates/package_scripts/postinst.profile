#!/bin/bash
# This is a postinstallation script so the service can be configured and started when requested
#
if [ -d "/var/lib/gilt-exec" ]
then
    echo "Directory /var/lib/gilt-exec exists."
else
    mkdir -p /var/lib/gilt-exec
    sudo chown -R gilt /var/lib/gilt-exec
fi
sudo systemctl daemon-reload
