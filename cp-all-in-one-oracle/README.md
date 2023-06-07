
# Oracle CDC - MongoDB PoC

- [Oracle CDC - MongoDB PoC](#oracle-cdc---mongodb-poc)
  - [Steps](#steps)
  - [cp-all-in-one](#cp-all-in-one)
  - [Oracle](#oracle)
    - [Docker Image](#docker-image)
    - [Setup ARCHIVELOG mode](#setup-archivelog-mode)
  - [Setup confluent Oracle CDC & MongoDB connector.](#setup-confluent-oracle-cdc--mongodb-connector)
  - [Setup data stream flow on ksqlDB.](#setup-data-stream-flow-on-ksqldb)

## Steps

- Setup the quick start Docker platform provided by confluent.
- Setup Oracle Database deployed on Docker.
- Setup confluent Oracle CDC & MongoDB connector.
- Setup data stream flow on ksqlDB.
- Setup Atlas cluster.
- Setup Mongodb sink connectors.
- Execute Oracle CRUD operations.

This PoC is running the confluent quick start (cp-all-in-one) to get up and running with Confluent Platform and its main components using Docker containers. 

This quick start uses Confluent Control Center included in Confluent Platform for topic management and event stream processing using ksqlDB.


## cp-all-in-one


Download or copy the contents of the Confluent Platform all-in-one Docker Compose file, for example:

```sh
curl --silent --output docker-compose.yml \
  https://raw.githubusercontent.com/confluentinc/cp-all-in-one/6.2.0-post/cp-all-in-one/docker-compose.yml
```

## Oracle
### Docker Image

The  Oracle Database Server  Docker Image contains the  Oracle Database Server 12.2.0.1 Enterprise  Edition running on  Oracle Linux 7. This image contains a default database in a multitenant  configuration with one pdb.

- log into https://hub.docker.com/
- search "oracle database"
- click on "Oracle Database Enterprise Edition"
- click on "Proceed to Checkout"
- fill in your contact info on the left, check two boxes under "Developer Tier" on the right, click on "Get Content"

After you can use this image in the docker-compose file. You need to update the **docker-compose.yml** file
```docker
database:
   image: 'store/oracle/database-enterprise:${ORA_VER}'
   hostname: oracle
   container_name: oracle
   volumes:
     - /Volumes/SanDisk/oradata:/ORCL  # persistent oracle database data.
     - ./scripts:/scripts 
   ports:
     - 1521:1521
     - 8080:8080
     - 5500:5500

```

### Setup ARCHIVELOG mode
For this purpose we are going to use the [scripts](scripts/oracle_setup_docker.sql) prepared by [Simon Aubury](https://github.com/saubury/kafka-connect-oracle-cdc) that simplifies this process. I have modified this script to create a more complex table than the one designed by him.

But if you need further information please check confluent [documentation](https://docs.confluent.io/kafka-connect-oracle-cdc/current/prereqs-validation.html). 

```shell
docker-compose exec oracle /scripts/go_sqlplus.sh /scripts/oracle_setup_docker.sql

```
## Setup confluent Oracle CDC & MongoDB connector.
1. The easy way is to install them using confluent hub.
```shell
docker exec -it connect /bin/bash
confluent-hub install mongodb/kafka-connect-mongodb:latest
confluent-hub install confluentinc/kafka-connect-oracle-cdc:latest
```

2. Before creating the CDC connector is a good practice to create the redo topic.
```shell
docker exec -it broker /bin/bash

kafka-topics --create --topic SimpleOracleCDC-ORCLCDB-redo-log \
--bootstrap-server broker:9092 --replication-factor 1 \
--partitions 1 --config cleanup.policy=delete \
--config retention.ms=120960000
```

3. Create Oracle CDC connector

```shell
curl --location --request POST 'http://localhost:8083/connectors' \
--header 'Content-Type: text/plain' \
--data-raw '{
  "name": "SimpleOracleCDC",
  "config": {
    "connector.class": "io.confluent.connect.oracle.cdc.OracleCdcSourceConnector",
    "name": "SimpleOracleCDC",
    "tasks.max": 1,
    "key.converter": "io.confluent.connect.avro.AvroConverter",
    "key.converter.schema.registry.url": "http://schema-registry:8081",
    "value.converter": "io.confluent.connect.avro.AvroConverter",
    "value.converter.schema.registry.url": "http://schema-registry:8081",
    "confluent.topic.bootstrap.servers": "broker:29092",
    "oracle.server": "oracle",
    "oracle.port": 1521,
    "oracle.sid": "ORCLCDB",
    "oracle.username": "C##MYUSER",
    "oracle.password": "password",
    "start.from": "snapshot",
    "table.inclusion.regex": "ORCLCDB\\.C##MYUSER\\.EMP",
    "table.exclusion.regex": "",
    "table.topic.name.template": "${databaseName}-${tableName}",
    "connection.pool.max.size": 20,
    "confluent.topic.replication.factor": 1,
    "redo.log.consumer.bootstrap.servers": "broker:29092",
    "topic.creation.groups": "redo",
    "topic.creation.redo.include": "redo-log-topic",
    "topic.creation.redo.replication.factor": 1,
    "topic.creation.redo.partitions": 1,
    "topic.creation.redo.cleanup.policy": "delete",
    "topic.creation.redo.retention.ms": 1209600000,
    "topic.creation.default.replication.factor": 1,
    "topic.creation.default.partitions": 1,
    "topic.creation.default.cleanup.policy": "delete"
  }
}
'
```
## Setup data stream flow on ksqlDB.

This demo will support every Oracle CRUD operation and it will replicate it to MongoDB. We will use ksqlDB to be able to create the different flows necessary to consume all the Orcel CRUD operations.

The following streams will need it:
1. Navigate to the [Control Center web](http://localhost:9021) interface  http://localhost:9021.
2. In the navigation bar, click ksqlDB.
3. Select the ksqlDB application.
4. Create a stream from the CDC topic. 

```sql
CREATE STREAM CDCORACLE (I DECIMAL(20,0), NAME varchar, LASTNAME varchar, op_type VARCHAR) WITH
    (kafka_topic='ORCLCDB-EMP', value_format='AVRO');
```
5. Create a first flow for writing (Insert and Updates) operations

```sql
CREATE STREAM WRITEOP AS
  SELECT CAST(I AS BIGINT) as "_id",  NAME ,  LASTNAME , OP_TYPE  from CDCORACLE WHERE OP_TYPE!='D' EMIT CHANGES;
```

6. Create a second flow for deleting operations.

```sql
CREATE STREAM DELETEOP AS
  SELECT CAST(I AS BIGINT) as "_id",  NAME ,  LASTNAME , OP_TYPE  from CDCORACLE WHERE OP_TYPE='D' EMIT CHANGES;
```

You should see the following flow.
![](/images/flow.png)