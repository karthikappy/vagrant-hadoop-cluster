#!/bin/bash

echo "HADOOP: Starting"
echo "HADOOP: Copying Files"
tar -xzf /vagrant/resources/software/hadoop-3.5.0.tar.gz -C /usr/local       # Extract hadoop archive into node
ln -s /usr/local/hadoop-3.5.0 /usr/local/hadoop                       # Create symbolic link to simplify scripting
	
# Create startup script
echo "HADOOP: Generating Startup scripts"
echo export HADOOP_HOME=/usr/local/hadoop >> /etc/profile.d/hadoop.sh
echo export HADOOP_YARN_HOME=\${HADOOP_HOME} >> /etc/profile.d/hadoop.sh
echo export HADOOP_CONF_DIR=\${HADOOP_HOME}/etc/hadoop >> /etc/profile.d/hadoop.sh
echo export HADOOP_LOG_DIR=\${HADOOP_YARN_HOME}/logs >> /etc/profile.d/hadoop.sh
echo export HADOOP_IDENT_STRING=root >> /etc/profile.d/hadoop.sh
echo export HADOOP_MAPRED_IDENT_STRING=root >> /etc/profile.d/hadoop.sh
echo export PATH=\${HADOOP_HOME}/bin:\${PATH} >> /etc/profile.d/hadoop.sh

echo "HADOOP: Copying configuration files"
cp -rf /vagrant/resources/hadoop/config/* /usr/local/hadoop/etc/hadoop

echo "HADOOP: Creating working directories"
mkdir /etc/hadoop
mkdir /usr/local/hadoop/logs
mkdir /tmp/hadoop-yarn-vagrant
mkdir /var/hadoop
mkdir /var/hadoop/hadoop-datanode
mkdir /var/hadoop/hadoop-namenode
mkdir /var/hadoop/mr-history
mkdir /var/hadoop/mr-history/done
mkdir /var/hadoop/mr-history/tmp

chown -R vagrant /tmp/hadoop-yarn-vagrant
chown -R vagrant /usr/local/hadoop/logs
chown -R vagrant /var/hadoop

echo "HADOOP: Task completed successfully"