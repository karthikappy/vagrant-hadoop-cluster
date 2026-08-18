#!/bin/bash
set -euo pipefail

timedatectl set-timezone America/New_York

echo "NAMENODE SERVICES - INSTALLING UNITS"
cp /vagrant/resources/zookeeper/systemd/zookeeper.service /etc/systemd/system/zookeeper.service
cp /vagrant/resources/hadoop/systemd/hadoop-namenode.service /etc/systemd/system/hadoop-namenode.service
cp /vagrant/resources/hadoop/systemd/hadoop-secondarynamenode.service /etc/systemd/system/hadoop-secondarynamenode.service
cp /vagrant/resources/hadoop/systemd/hadoop-datanode.service /etc/systemd/system/hadoop-datanode.service
cp /vagrant/resources/hadoop/systemd/hadoop-resourcemanager.service /etc/systemd/system/hadoop-resourcemanager.service
cp /vagrant/resources/hadoop/systemd/hadoop-nodemanager.service /etc/systemd/system/hadoop-nodemanager.service
cp /vagrant/resources/hadoop/systemd/hadoop-jobhistory.service /etc/systemd/system/hadoop-jobhistory.service
cp /vagrant/resources/hbase/systemd/hbase-master.service /etc/systemd/system/hbase-master.service
cp /vagrant/resources/hbase/systemd/hbase-regionserver.service /etc/systemd/system/hbase-regionserver.service
cp /vagrant/resources/spark/systemd/spark-master.service /etc/systemd/system/spark-master.service
cp /vagrant/resources/spark/systemd/spark-worker.service /etc/systemd/system/spark-worker.service
cp /vagrant/resources/spark/systemd/spark-history-server.service /etc/systemd/system/spark-history-server.service
cp /vagrant/resources/storm/systemd/storm-nimbus.service /etc/systemd/system/storm-nimbus.service
cp /vagrant/resources/storm/systemd/storm-supervisor.service /etc/systemd/system/storm-supervisor.service
cp /vagrant/resources/storm/systemd/storm-ui.service /etc/systemd/system/storm-ui.service
cp /vagrant/resources/storm/systemd/storm-logviewer.service /etc/systemd/system/storm-logviewer.service
cp /vagrant/resources/hive/systemd/hive-metastore.service /etc/systemd/system/hive-metastore.service
cp /vagrant/resources/hive/systemd/hive.service /etc/systemd/system/hive.service
cp /vagrant/resources/flume/systemd/flume.service /etc/systemd/system/flume.service
cp /vagrant/resources/nifi/systemd/nifi.service /etc/systemd/system/nifi.service

systemctl disable --now hadoop.service hbase.service spark.service 2>/dev/null || true
rm -f /etc/systemd/system/hadoop.service /etc/systemd/system/hbase.service /etc/systemd/system/spark.service
systemctl daemon-reload

echo "NAMENODE SERVICES - ENABLING UNITS"
systemctl enable zookeeper.service
systemctl enable hadoop-namenode.service hadoop-secondarynamenode.service hadoop-datanode.service
systemctl enable hadoop-resourcemanager.service hadoop-nodemanager.service hadoop-jobhistory.service
systemctl enable hbase-master.service hbase-regionserver.service
systemctl enable spark-master.service spark-worker.service spark-history-server.service
systemctl enable storm-nimbus.service storm-supervisor.service storm-ui.service storm-logviewer.service
systemctl enable hive-metastore.service hive.service flume.service nifi.service

echo "NAMENODE SERVICES - STARTING CORE SERVICES"
systemctl start zookeeper.service
systemctl start hadoop-namenode.service
systemctl start hadoop-secondarynamenode.service hadoop-datanode.service
systemctl start hadoop-resourcemanager.service hadoop-nodemanager.service

echo "NAMENODE SERVICES - PREPARING HDFS SERVICE DIRECTORIES"
hdfs_ready=false
for _ in {1..90}; do
  if runuser -u vagrant -- /usr/local/hadoop/bin/hdfs dfs -mkdir -p /user/hive/warehouse /mr-history/tmp /mr-history/done /tmp/logs >/dev/null 2>&1; then
    hdfs_ready=true
    break
  fi
  sleep 1
done
if [[ "$hdfs_ready" != true ]]; then
  echo "Service directory creation timed out waiting for writable HDFS" >&2
  runuser -u vagrant -- /usr/local/hadoop/bin/hdfs dfs -mkdir -p /user/hive/warehouse /mr-history/tmp /mr-history/done /tmp/logs
  exit 1
fi
runuser -u vagrant -- /usr/local/hadoop/bin/hdfs dfs -chown vagrant:supergroup /user/hive /user/hive/warehouse
runuser -u vagrant -- /usr/local/hadoop/bin/hdfs dfs -chmod 1777 /user/hive/warehouse
runuser -u vagrant -- /usr/local/hadoop/bin/hdfs dfs -chown vagrant:supergroup /mr-history /mr-history/tmp /mr-history/done /tmp/logs
runuser -u vagrant -- /usr/local/hadoop/bin/hdfs dfs -chmod 1777 /mr-history/tmp /tmp/logs
runuser -u vagrant -- /usr/local/hadoop/bin/hdfs dfs -chmod 0770 /mr-history/done

echo "NAMENODE SERVICES - STARTING MAPREDUCE HISTORY"
systemctl start hadoop-jobhistory.service

echo "NAMENODE SERVICES - STARTING DATA SERVICES"
systemctl start hbase-master.service hbase-regionserver.service
systemctl start hive-metastore.service
systemctl start hive.service

echo "NAMENODE SERVICES - STARTING COMPUTE AND INGESTION SERVICES"
systemctl start spark-master.service spark-worker.service spark-history-server.service
systemctl start storm-nimbus.service storm-supervisor.service storm-ui.service storm-logviewer.service
systemctl start flume.service nifi.service
