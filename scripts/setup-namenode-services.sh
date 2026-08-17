#!/bin/bash
timedatectl set-timezone America/New_York

echo "NAMENODE SERVICES - ZOOKEEPER"
cp /vagrant/resources/zookeeper/systemd/zookeeper.service /etc/systemd/system/zookeeper.service
systemctl enable zookeeper.service
systemctl start zookeeper.service

echo "NAMENODE SERVICES - HADOOP"
cp /vagrant/resources/hadoop/systemd/hadoop.service /etc/systemd/system/hadoop.service
systemctl enable hadoop.service
systemctl start hadoop.service

echo "NAMENODE SERVICES - HBASE"
cp /vagrant/resources/hbase/systemd/hbase.service /etc/systemd/system/hbase.service
systemctl daemon-reload
systemctl enable hbase.service
systemctl start hbase.service

echo "NAMENODE SERVICES - SPARK"
cp /vagrant/resources/spark/systemd/spark.service /etc/systemd/system/spark.service
systemctl enable spark.service
systemctl start spark.service

echo "NAMENODE SERVICES - SPARK-HISTORY-SERVER"
cp /vagrant/resources/spark/systemd/spark-history-server.service /etc/systemd/system/spark-history-server.service
systemctl enable spark-history-server.service
systemctl start spark-history-server.service

echo "NAMENODE SERVICES - STORM-NIMBUS"
cp /vagrant/resources/storm/systemd/storm-nimbus.service /etc/systemd/system/storm-nimbus.service
systemctl enable storm-nimbus.service
systemctl start storm-nimbus.service

echo "NAMENODE SERVICES - STORM-SUPERVISOR"
cp /vagrant/resources/storm/systemd/storm-supervisor.service /etc/systemd/system/storm-supervisor.service
systemctl enable storm-supervisor.service
systemctl start storm-supervisor.service

echo "NAMENODE SERVICES - STORM-UI"
cp /vagrant/resources/storm/systemd/storm-ui.service /etc/systemd/system/storm-ui.service
systemctl enable storm-ui.service
systemctl start storm-ui.service

echo "NAMENODE SERVICES - STORM-LOGVIEWER"
cp /vagrant/resources/storm/systemd/storm-logviewer.service /etc/systemd/system/storm-logviewer.service
systemctl enable storm-logviewer.service
systemctl start storm-logviewer.service



echo "NAMENODE SERVICES - HIVE"
cp /vagrant/resources/hive/systemd/hive.service /etc/systemd/system/hive.service
systemctl daemon-reload
systemctl enable hive.service
systemctl start hive.service


#/vagrant/bin/dumplogs.sh
