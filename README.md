# Vagrant Hadoop Cluster
## Preface/ Why does this project exist?
I recently found myself in a position where I had to conduct some experiments with big data and hadoop technologies such as MapReduce, Spark and HBase. Unfortunatelely, while all these technologies are free and open source, the process for getting things up and running is slow and cumbersome. Between poor documentation, non-standardized installation proce4sses and incompatibilities between versions, it's easy to ignore hadoop's potential.

Here are a few alternative solutions that I have considered (they might work for you!):
- Bitnami Hadoop
- Cloudera Data Platform (formerly, HortonWorks Data Platform)

This project is based on a number of projects on GitHub that do similar things, such as:
- https://github.com/ssalat/vagrant-hadoop-cluster
- https://github.com/martinprobson/vagrant-hadoop-hive-spark


Unfortunately, these projects are all very old and require quite a bit of work to get them to work with the latest versions of Hadoop.

## Introduction/ What does this project do?
This project contains scripts that will do the following:
- Set up a cluster of VM's that will be networked together
- Install an LTS version of Ubuntu Server edition
- Install and configure Hadoop
- Install and configure additional big data tools built on Hadoop such as Spark, Hive and HBase

## Prerequisites
You will need the following applications to use set up the virtual cluster:
- Vagrant (tested with version 2.3.6)
- VirtualBox (tested with version 7.0.8)
## Installation Instructions
### STEP 1: Configure the number of nodes
Open ```Vagrantfile``` and change the number of nodes in line 7, you must have a minumum of 2 nodes (one namenode and one datanode)

### STEP 2: Configure hosts file
To make it easy to access the nodes of your virtual cluster, it is recommended that you update your hosts file.

In windows, this file can be found in: ```c:\Windows\System32\Drivers\etc\hosts```
Simply add the following lines to the end of the file:
```
10.211.55.101 node1
10.211.55.102 node2
10.211.55.103 node3
10.211.55.104 node4
10.211.55.105 node5
```
You can add further to this if you have more than 5 nodes.
Now we can open a browser and type ```http://node1:9870``` instead of ```http://10.211.55.101:9870``` to access the NameNode

### STEP 3: Create SSH keys
For nodes in a hadoop cluster to communicate with each other, they must all have the same SSH keys installed. Before these keys can be installed, we need to generate them on our host machine.

Go to the root directiory of the project (the folder with this readme) and run the following command
```
ssh-keygen -f "resources/ssh/id_rsa"
```
NOTE: do not use a passphrase

### STEP 4: Download Software
We need to download all the archives that will have to be installed in our nodes.
In future, I will integrate this into the Vagrantfile. For now, you will need to run ```download-software.bat``` on a windows machine

### STEP 5: Start vagrant
Open a terminal window in the root directory of this project and run:
```
vagrant up
```

## Application-specific notes

Unless stated otherwise, configuration paths and commands below are run inside a VM. Most applications run as `vagrant` and are managed by systemd. Use `systemctl status <unit>` to check a service and `journalctl -u <unit>` to view its journal.

### Hadoop

Hadoop is installed on every node with `HADOOP_HOME=/usr/local/hadoop`. `node1` runs the NameNode, SecondaryNameNode, ResourceManager, JobHistory Server, DataNode, and NodeManager. Nodes `node2` and higher run a DataNode and NodeManager.

#### Configuration files

Configuration files are stored in `$HADOOP_HOME/etc/hadoop` (`/usr/local/hadoop/etc/hadoop`). HDFS data is stored in `/var/hadoop/hadoop-namenode` on the NameNode and `/var/hadoop/hadoop-datanode` on each DataNode.

#### Web interfaces and ports

- http://node1:9870/ — HDFS NameNode
- http://node1:9868/ — HDFS SecondaryNameNode
- http://node1:8088/ — YARN ResourceManager
- http://node1:8089/ — YARN web proxy
- http://node1:19888/ — MapReduce JobHistory Server
- `http://nodeN:8042/` — YARN NodeManager on every provisioned node, including `node1`
- `http://nodeN:9864/` — HDFS DataNode on every provisioned node, including `node1`

The HDFS RPC endpoint is `node1:8020`, and the MapReduce JobHistory RPC endpoint is `node1:10020`.

#### Logs and services

Application logs are stored in `$HADOOP_HOME/logs`; aggregated YARN application logs are stored in HDFS under `/tmp/logs`. The systemd units are `hadoop-namenode`, `hadoop-secondarynamenode`, `hadoop-datanode`, `hadoop-resourcemanager`, `hadoop-nodemanager`, and `hadoop-jobhistory` (as applicable to the node).

### ZooKeeper

ZooKeeper is installed on `node1` with `ZK_HOME=/usr/local/zookeeper`. It is used by HBase and Storm. Although Hadoop contains HA-related settings, this project provisions only one NameNode and one ZooKeeper server, so it is not an HA deployment.

#### Configuration and data

Configuration files are stored in `$ZK_HOME/conf`; ZooKeeper data is stored in `/var/zookeeper/data`.

#### Interfaces and ports

- http://node1:8180/commands — AdminServer command API
- `node1:2181` — client connections

#### Logs and service

Logs are stored in `$ZK_HOME/logs` and are also available with `journalctl -u zookeeper`. The systemd unit is `zookeeper`.

### Storm

Storm is installed on `node1` with `STORM_HOME=/usr/local/storm`. Nimbus, Supervisor, the UI, and Logviewer all run on that node and use ZooKeeper at `node1:2181`.

#### Configuration files

Configuration files are stored in `$STORM_HOME/conf`.

#### Interfaces and ports

- http://node1:8090/ — Storm UI
- http://node1:8000/ — Storm Logviewer
- http://node1:8000/api/v1/daemonlog?file=nimbus.log — Nimbus log through the Logviewer API
- `node1:6627` — Nimbus Thrift endpoint

#### Logs and services

Storm logs are stored in `/var/log/storm`. They are also available through the journals for `storm-nimbus`, `storm-supervisor`, `storm-ui`, and `storm-logviewer`.

### Hive

Hive is installed on `node1` with `HIVE_HOME=/usr/local/hive`. HiveServer2 uses a MySQL-backed metastore and stores its warehouse in HDFS at `/user/hive/warehouse`.

#### Configuration files

Configuration files are stored in `$HIVE_HOME/conf`.

#### Interfaces and ports

- http://node1:10002/ — HiveServer2 Web UI
- `jdbc:hive2://node1:10000/default` — HiveServer2 JDBC/Thrift endpoint (connect with `beeline`)
- `thrift://node1:9083` — Hive Metastore endpoint

#### Logs and services

Hive's Log4j configuration writes the main log to `/tmp/vagrant/hive.log`. Service output is also available with `journalctl -u hive` and `journalctl -u hive-metastore`.

### Spark

Spark is installed on `node1` with `SPARK_HOME=/usr/local/spark`. The standalone Master, one Worker, and the History Server run on `node1`; submitted applications default to YARN because `spark.master` is set to `yarn`.

#### Configuration files

Configuration files are stored in `$SPARK_HOME/conf`.

#### Web interfaces and ports

- http://node1:8080/ — Spark standalone Master
- http://node1:8081/ — Spark standalone Worker
- http://node1:18080/ — Spark History Server
- http://node1:4040/ — an application's driver UI while that application is running (subsequent concurrent applications use 4041, 4042, and so on)
- `spark://node1:7077` — standalone Master endpoint

#### Logs and services

Daemon logs are stored in `$SPARK_HOME/logs`; Worker state is stored in `/var/lib/spark/work`. Journals are available for `spark-master`, `spark-worker`, and `spark-history-server`.

Event logging is disabled in the supplied `spark-defaults.conf`, so the History Server will not show completed applications until `spark.eventLog.enabled` and a shared `spark.eventLog.dir` are configured.

### HBase

HBase is installed on every node with `HBASE_HOME=/usr/local/hbase`, but the current systemd setup starts both the HBase Master and one RegionServer on `node1`. HBase runs in distributed mode, stores data in HDFS at `hdfs://node1:8020/hbase`, and uses ZooKeeper at `node1`.

#### Configuration files

Configuration files are stored in `$HBASE_HOME/conf`.

#### Web interfaces and ports

- http://node1:16010/ — HBase Master UI
- http://node1:16030/ — HBase RegionServer UI

#### Logs and services

Logs are stored in `$HBASE_HOME/logs` and are available with `journalctl -u hbase-master` and `journalctl -u hbase-regionserver`.

### Cassandra

Cassandra is installed only on nodes `node2` and higher with `CASSANDRA_HOME=/usr/local/cassandra`. Each node runs an independent Cassandra service with the default cluster name `Test Cluster`.

#### Configuration and data

Configuration files are stored in `$CASSANDRA_HOME/conf`; data is stored beneath `$CASSANDRA_HOME/data`.

#### Interfaces and ports

- `localhost:9042` — CQL native transport
- `localhost:7000` — internode storage transport

The supplied configuration sets both `listen_address` and `rpc_address` to `localhost`. Consequently, the Cassandra instances do not currently form a multi-node cluster and CQL is not reachable from the host or other VMs without changing those settings.

#### Logs and service

Logs are stored in `$CASSANDRA_HOME/logs` (including `system.log` and `debug.log`) and are available with `journalctl -u cassandra`.

### NiFi

NiFi is installed on `node1` with `NIFI_HOME=/usr/local/nifi`.

#### Configuration files

Configuration files are stored in `$NIFI_HOME/conf`. NiFi creates its repositories and working data beneath `$NIFI_HOME` using the paths in `nifi.properties`.

#### Web interface

- https://node1:8443/nifi/ — NiFi UI and API

NiFi uses HTTPS with an automatically generated certificate. A browser may warn that the certificate is not trusted or does not match the host name.

#### Logs and service

Logs are stored in `$NIFI_HOME/logs` (including `nifi-app.log`, `nifi-bootstrap.log`, `nifi-user.log`, and `nifi-request.log`) and are available with `journalctl -u nifi`.

### Flume

Flume is installed on `node1` with `FLUME_HOME=/usr/local/flume`. The enabled `agent` uses `lidar.conf`: it accepts Avro events on port `9898` and writes JSON records to the Hive table `default.lidar` through the metastore at `node1:9083`.

#### Configuration files

Configuration files are stored in `$FLUME_HOME/conf`.

#### Logs and service

The Flume unit logs to standard output, so use `journalctl -u flume`.

### MySQL

MySQL runs on `node1` and provides Hive's metastore database, `hivemetastore`, over its standard local endpoint on port `3306`. Manage it with the distribution's `mysql` systemd service and inspect logs with `journalctl -u mysql`. Hive's connection settings are in `$HIVE_HOME/conf/hive-site.xml`.

### Optional components

Conda/Jupyter and Apache Sedona setup scripts exist in the repository, but they are not enabled by the current `Vagrantfile`. They have no running service or Web UI after a normal `vagrant up`.

## Verifying that everything is running
### JPS

The easiest way to verify that things are working correctly is with JPS, simply run the command ```jps -mlV```.

On the name node you should see the following:
- org.apache.hadoop.hdfs.server.namenode.NameNode - Hadoop Namenode
- org.apache.hadoop.yarn.server.resourcemanager.ResourceManager - Hadoop Resource Manager
- org.apache.zookeeper.server.quorum.QuorumPeerMain - Zookeeper
- org.apache.spark.deploy.worker.Worker - Spark Worker
- org.apache.spark.deploy.history.HistoryServer - Spark History Server

On data nodes, you should see the following:
- org.apache.hadoop.hdfs.server.datanode.DataNode - Hadoop Datanode
- org.apache.hadoop.yarn.server.nodemanager.NodeManager - Hadoop Node Manager
- org.apache.zookeeper.server.quorum.QuorumPeerMain - Zookeeper

## Known Issues
