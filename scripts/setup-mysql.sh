#!/bin/bash
set -euo pipefail

echo "MYSQL: Starting"
echo "MYSQL: Installing via apt-get"
echo "mysql-server-5.5 mysql-server/root_password password root" | sudo debconf-set-selections
echo "mysql-server-5.5 mysql-server/root_password_again password root" | sudo debconf-set-selections
apt-get update

apt-get install -y mysql-server

mysql -u root -proot -e "CREATE USER IF NOT EXISTS 'hiveuser'@'%' IDENTIFIED BY 'hive'; ALTER USER 'hiveuser'@'%' IDENTIFIED BY 'hive'; GRANT ALL ON *.* TO 'hiveuser'@'%'; FLUSH PRIVILEGES;"

cp -f /vagrant/resources/hive/mysql/mysql-connector-java-8.0.30.jar /usr/local/hive/lib
cp -f /vagrant/resources/hive/mysql/mysql-connector-java-8.0.30.jar /usr/local/spark/jars

export JAVA_HOME=/usr/local/java
export HADOOP_HOME=/usr/local/hadoop
export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop
export HIVE_HOME=/usr/local/hive
export HIVE_CONF_DIR=/usr/local/hive/conf

if ! /usr/local/hive/bin/schematool -dbType mysql -info >/dev/null 2>&1; then
    /usr/local/hive/bin/schematool -dbType mysql -initSchema
fi
