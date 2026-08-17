#!/bin/bash

echo "HBASE: Starting"
echo "HBASE: Copying Files"
tar -xzf /vagrant/resources/software/hbase-2.5.15-bin.tar.gz -C /usr/local       # Extract hadoop archive into node
ln -s /usr/local/hbase-2.5.15 /usr/local/hbase                       # Create symbolic link to simplify scripting

echo "HBASE: Generating startup scripts"
echo export HBASE_HOME=/usr/local/hbase >> /etc/profile.d/hbase.sh

echo "HBASE: Copying configuration files"
cp -f /vagrant/resources/hbase/config/* /usr/local/hbase/conf

mkdir /usr/local/hbase/logs
mkdir /tmp/hbase

chown -R vagrant /usr/local/hbase/logs
chown -R vagrant /tmp/hbase