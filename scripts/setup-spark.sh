#!/bin/bash

echo "SPARK: Starting"
echo "SPARK: Copying Files"
tar -xzf /vagrant/resources/software/spark-3.4.1-bin-without-hadoop.tgz -C /usr/local
ln -s /usr/local/spark-3.4.1-bin-without-hadoop/ /usr/local/spark

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
chown vagrant /usr/local/spark/logs

echo "SPARK: Task Completed Successfully"