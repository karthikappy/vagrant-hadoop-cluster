#!/bin/bash
set -euo pipefail

echo "DATANODE SERVICES - HADOOP WORKERS AND CASSANDRA"
cp /vagrant/resources/hadoop/systemd/hadoop-datanode.service /etc/systemd/system/hadoop-datanode.service
cp /vagrant/resources/hadoop/systemd/hadoop-nodemanager.service /etc/systemd/system/hadoop-nodemanager.service
cp /vagrant/resources/cassandra/systemd/cassandra.service /etc/systemd/system/cassandra.service
systemctl daemon-reload
systemctl enable hadoop-datanode.service hadoop-nodemanager.service cassandra.service
systemctl start hadoop-datanode.service hadoop-nodemanager.service cassandra.service
