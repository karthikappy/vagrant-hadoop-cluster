#!/bin/bash
set -euo pipefail

timedatectl set-timezone America/New_York

echo "NAMENODE SERVICES - INSTALLING UNITS"
cp /vagrant/resources/zookeeper/systemd/zookeeper.service /etc/systemd/system/zookeeper.service
cp /vagrant/resources/hadoop/systemd/hadoop.service /etc/systemd/system/hadoop.service
cp /vagrant/resources/hbase/systemd/hbase.service /etc/systemd/system/hbase.service
cp /vagrant/resources/spark/systemd/spark.service /etc/systemd/system/spark.service
cp /vagrant/resources/spark/systemd/spark-history-server.service /etc/systemd/system/spark-history-server.service
cp /vagrant/resources/storm/systemd/storm-nimbus.service /etc/systemd/system/storm-nimbus.service
cp /vagrant/resources/storm/systemd/storm-supervisor.service /etc/systemd/system/storm-supervisor.service
cp /vagrant/resources/storm/systemd/storm-ui.service /etc/systemd/system/storm-ui.service
cp /vagrant/resources/storm/systemd/storm-logviewer.service /etc/systemd/system/storm-logviewer.service
cp /vagrant/resources/hive/systemd/hive.service /etc/systemd/system/hive.service
cp /vagrant/resources/flume/systemd/flume.service /etc/systemd/system/flume.service
cp /vagrant/resources/nifi/systemd/nifi.service /etc/systemd/system/nifi.service

systemctl daemon-reload

echo "NAMENODE SERVICES - ENABLING UNITS"
systemctl enable zookeeper.service hadoop.service hbase.service
systemctl enable spark.service spark-history-server.service
systemctl enable storm-nimbus.service storm-supervisor.service storm-ui.service storm-logviewer.service
systemctl enable hive.service flume.service nifi.service

echo "NAMENODE SERVICES - STARTING CORE SERVICES"
systemctl start zookeeper.service
systemctl start hadoop.service

echo "NAMENODE SERVICES - STARTING DATA SERVICES"
systemctl start hbase.service
systemctl start hive.service

echo "NAMENODE SERVICES - STARTING COMPUTE AND INGESTION SERVICES"
systemctl start spark.service spark-history-server.service
systemctl start storm-nimbus.service storm-supervisor.service storm-ui.service storm-logviewer.service
systemctl start flume.service nifi.service
