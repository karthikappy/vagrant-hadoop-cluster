#!/bin/bash

echo "NIFI: Starting"
echo "NIFI: Installing Apache NiFi"
apt-get install unzip
unzip /vagrant/resources/software/nifi-1.23.2-bin.zip -d /usr/local
ln -s /usr/local/nifi-1.23.2 /usr/local/nifi                       # Create symbolic link to simplify scripting

echo "NIFI: Generating Startup scripts"
echo export NIFI_HOME=/usr/local/nifi >> /etc/profile.d/nifi.sh
echo export PATH=\${NIFI_HOME}/bin:\${PATH} >> /etc/profile.d/nifi.sh

echo "NIFI: Copying Configuration Files"
cp -f /vagrant/resources/nifi/config/* /usr/local/nifi/conf

chown -R vagrant /usr/local/nifi-1.23.2

