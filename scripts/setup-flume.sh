#!/bin/bash

echo "FLUME: Starting"
echo "FLUME: Copying Files"
tar -xzf /vagrant/resources/software/apache-flume-1.11.0-bin.tar.gz -C /usr/local
ln -s /usr/local/apache-flume-1.11.0-bin/ /usr/local/flume

echo "FLUME: Generating Startup scripts"
echo export FLUME_HOME=/usr/local/flume >> /etc/profile.d/flume.sh
echo export PATH=\${FLUME_HOME}/bin:\${PATH} >> /etc/profile.d/flume.sh

echo "FLUME: Copying Configuration Files"
cp -f /vagrant/resources/flume/config/* /usr/local/flume/conf

chown -R vagrant /usr/local/apache-flume-1.11.0-bin
