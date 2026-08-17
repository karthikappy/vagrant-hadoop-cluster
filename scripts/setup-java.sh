#!/bin/bash

echo "JAVA: Starting"
echo "JAVA: Copying Files"
#tar -xzf /vagrant/resources/software/openjdk-11.0.1_linux-x64_bin.tar.gz -C /usr/local
tar -xzf /vagrant/resources/software/jdk-17.0.19_linux-x64_bin.tar.gz -C /usr/local
#ln -s /usr/local/jdk-11.0.1 /usr/local/java
ln -s /usr/local/jdk-17.0.19 /usr/local/java
update-alternatives --install /usr/bin/java java /usr/local/java/bin/java 1000
update-alternatives --install /usr/bin/javac javac /usr/local/java/bin/javac 1000

echo "creating java environment variables"
echo export JAVA_HOME=/usr/local/java >> /etc/profile.d/java.sh
echo export PATH=\${JAVA_HOME}/bin:\${PATH} >> /etc/profile.d/java.sh