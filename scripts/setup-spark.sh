#!/bin/bash
set -euo pipefail

spark_version=4.2.0
spark_archive="/vagrant/resources/software/spark-${spark_version}-bin-hadoop3.tgz"
spark_install_dir="/usr/local/spark-${spark_version}-bin-hadoop3"

echo "SPARK: Starting"
echo "SPARK: Copying Files"
[[ -f "$spark_archive" ]]
if [[ ! -d "$spark_install_dir" ]]; then
  tar -xzf "$spark_archive" -C /usr/local
fi
[[ -x "$spark_install_dir/bin/spark-class" ]]
ln -sfn "$spark_install_dir" /usr/local/spark

echo "SPARK: Generating Startup scripts"
printf '%s\n' \
  'export SPARK_HOME=/usr/local/spark' \
  'export PATH=${SPARK_HOME}/bin:${SPARK_HOME}/sbin:${PATH}' \
  'export CLASSPATH=${CLASSPATH:-}:/usr/local/hive/lib/mysql-connector-java-8.0.30.jar' \
  'export SPARK_CLASSPATH=${CLASSPATH}' \
  'export SPARK_SUBMIT_CLASSPATH=${CLASSPATH}' \
  'export SPARK_MASTER_HOST=node1' \
  > /etc/profile.d/spark.sh

echo "SPARK: Copying Configuration Files"
cp -f /vagrant/resources/spark/config/* /usr/local/spark/conf

echo "SPARK: Creating working directories"
install -d -o vagrant -g vagrant -m 0755 \
  /usr/local/spark/logs \
  /var/lib/spark/work \
  /tmp/spark-events

echo "SPARK: Task Completed Successfully"
