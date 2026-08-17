#!/bin/bash

echo "SPARK: Starting"
echo "SPARK: Copying Files"
tar -xzf /vagrant/resources/software/spark-4.2.0-bin-hadoop3.tgz -C /usr/local
ln -s /usr/local/spark-4.2.0-bin-hadoop3/ /usr/local/spark

echo "SPARK: Generating Startup scripts"
echo export SPARK_HOME=/usr/local/spark >> /etc/profile.d/spark.sh
echo export PATH=\${SPARK_HOME}/bin:\${SPARK_HOME}/sbin:\${PATH} >> /etc/profile.d/spark.sh
echo export CLASSPATH=\$CLASSPATH:/usr/local/hive/lib/mysql-connector-java-8.0.30.jar >> /etc/profile.d/spark.sh
echo export SPARK_CLASSPATH=\$CLASSPATH >> /etc/profile.d/spark.sh
echo export SPARK_SUBMIT_CLASSPATH=\$CLASSPATH >> /etc/profile.d/spark.sh
echo export SPARK_MASTER_HOST=node1 >> /etc/profile.d/spark.sh

echo "SPARK: Copying Configuration Files"
cp -f /vagrant/resources/spark/config/* /usr/local/spark/conf

echo "SPARK: Creating working directories"
mkdir /usr/local/spark/logs
mkdir /tmp/spark-events

chown vagrant /usr/local/spark/logs
chown vagrant /tmp/spark-events

echo "SPARK: Task Completed Successfully"