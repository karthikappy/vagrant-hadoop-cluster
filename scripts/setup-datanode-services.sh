#!/bin/bash
set -euo pipefail

echo "DATANODE SERVICES - CASSANDRA"
cp /vagrant/resources/cassandra/systemd/cassandra.service /etc/systemd/system/cassandra.service
systemctl daemon-reload
systemctl enable cassandra.service
systemctl start cassandra.service
