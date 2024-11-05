# Config changes
This file keeps track of all the changes made to the default configuration files that are installed with an application

## Hadoop
### core-site.xml
Added the following properties

- fs.defaultFS
- hadoop.http.filter.initializers
- hadoop.http.cross-origin.enabled
- hadoop.http.cross-origin.allowed-origins
- hadoop.http.cross-origin.allowed-methods
- hadoop.http.cross-origin.allowed-headers
- hadoop.http.cross-origin.max-age

### hadoop-env.sh

Line 54: export JAVA_HOME=/usr/local/java

### hdfs-site.xml

- dfs.namenode.name.dir
- dfs.datanode.data.dir
- ha.zookeeper.quorum
- dfs.nameservices
- dfs.ha.namenodes.mycluster

### workers

Created file with the content ```localhost```

NOTE: This file is modified by setup-hadoop-workers.sh when you call ```vagrant up```

### yarn-site.xml

- yarn.resourcemanager.hostname
- yarn.log.server.url
- yarn.web-proxy.address
- yarn.resourcemanager.hostname
- yarn.timeline-service.hostname

## Spark

### spark-defaults.conf

- spark.master
- spark.sql.warehouse.dir
- spark.executor.extraClassPath