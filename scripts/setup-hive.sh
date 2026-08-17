#!/bin/bash

echo "HIVE: Starting"
echo "HIVE: Copying Files"
tar -xzf /vagrant/resources/software/apache-hive-4.1.0-bin.tar.gz -C /usr/local
ln -s /usr/local/apache-hive-4.1.0-bin/ /usr/local/hive

echo "HIVE: Generating Startup scripts"
echo export HIVE_HOME=/usr/local/hive >> /etc/profile.d/hive.sh
echo export PATH=\${HIVE_HOME}/bin:\${HIVE_HOME}/sbin:\${PATH} >> /etc/profile.d/hive.sh

echo "SPARK: Copying Configuration Files"
cp -f /vagrant/resources/hive/config/* /usr/local/hive/conf
mkdir /var/hive
mkdir /var/hive/iotemp
chown -R vagrant /var/hive
