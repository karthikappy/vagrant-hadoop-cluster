#!/bin/bash

echo "CASSANDRA: Starting"
echo "CASSANDRA: Copying Files"
tar -xzf /vagrant/resources/software/apache-cassandra-5.0.9-bin.tar.gz -C /usr/local
ln -s /usr/local/apache-cassandra-5.0.9/ /usr/local/cassandra

echo "CASSANDRA: Generating Startup scripts"
echo export CASSANDRA_HOME=/usr/local/cassandra >> /etc/profile.d/cassandra.sh
echo export PATH=\${CASSANDRA_HOME}/bin:\${PATH} >> /etc/profile.d/cassandra.sh

echo "CASSANDRA: Copying Configuration Files"
cp -f -r /vagrant/resources/cassandra/config/* /usr/local/cassandra/conf

echo "CASSANDRA: Creating directories"
mkdir /usr/local/cassandra/logs
chown -R vagrant /usr/local/cassandra/logs

mkdir /usr/local/cassandra/data
chown -R vagrant /usr/local/cassandra/data