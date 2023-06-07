# Demonstration Oracle CDC Source Connector with Kafka Connect

## Clone this repo
```
git clone https://github.com/saubury/kafka-connect-oracle-cdc
cd kafka-connect-oracle-cdc
```

## Get Oracle CDC Source Connector
Be sure to review license at https://www.confluent.io/hub/confluentinc/kafka-connect-oracle-cdc and download the zip file.

Unzip to `confluentinc-kafka-connect-oracle-cdc` (and remove any trailing version numbers)

```
unzip ~/Downloads/confluentinc-kafka-connect-oracle-cdc-1.0.3.zip
mv confluentinc-kafka-connect-oracle-cdc-1.0.3 confluentinc-kafka-connect-oracle-cdc
```


## Get Oracle Docker
From [Stackoverflow](https://stackoverflow.com/questions/47887403/pull-access-denied-for-container-registry-oracle-com-database-enterprise) ...


- log into https://hub.docker.com/
- search "oracle database"
- click on "Oracle Database Enterprise Edition"
- click on "Proceed to Checkout"
- fill in your contact info on the left, check two boxes under "Developer Tier" on the right, click on "Get Content"


```
docker login --username YourDockerUserName --password-stdin
<<Enter your password>>

docker pull store/oracle/database-enterprise:12.2.0.1
```

# Docker Startup

- Install docker/docker-compose
- Set your Docker maximum memory to something really big, such as 10GB. (preferences -> advanced -> memory)
- Startup the platform (Oracle, Kafka, Kafka Connect, Schema registry)
```
docker-compose up -d
```


## Setup Oracle Docker
Once the Oracle database is running, we need to turn on ARCHIVELOG mode, create some users, and establish permissions

First, ensure the database looks like it's running (`docker-compose logs -f oracle`) and then run the following (for the curious, the SQL script is [here](scripts/oracle_setup_docker.sql) )

```
docker-compose exec oracle /scripts/go_sqlplus.sh /scripts/oracle_setup_docker
```

## Sample Data
This SQL script also creates an `EMP` table, and adds four employees.

| I (primary key)    | Name |
| ----------- | ----------- |
| 1           | Bob         |
| 2           | Jane        |
| 3           | Mary        |
| 4           | Alice       |


# Create topics
Optional, but it's a good idea to create the topics 
```
kafka-topics --bootstrap-server localhost:9092 --create --partitions 1 --replication-factor 1 --topic ORCLCDB.C__MYUSER.EMP
kafka-topics --bootstrap-server localhost:9092 --create --partitions 1 --replication-factor 1 --topic SimpleOracleCDC-ORCLCDB-redo-log
```


## Connector Configuration 

Check the OracleCdcSourceConnector source plug-in is available
```
curl -s -X GET -H 'Content-Type: application/json' http://localhost:8083/connector-plugins | jq '.'
```

And look for an occurrence of `"class": "io.confluent.connect.oracle.cdc.OracleCdcSourceConnector"`



Establish the `SimpleOracleCDC` connector
```
curl -s -X POST -H 'Content-Type: application/json' --data @SimpleOracleCDC.json http://localhost:8083/connectors | jq
```

Check the status of the connector. You may need to wait a while for the status to show up
```
curl -s -X GET -H 'Content-Type: application/json' http://localhost:8083/connectors/SimpleOracleCDC/status | jq
```



## Check topic
If you have Kafka tools installed locally, you can look at the de-serialised AVRO like this
```
kafka-avro-console-consumer --bootstrap-server localhost:9092 --topic ORCLCDB.C__MYUSER.EMP --from-beginning
```

Or if you don't have the Kafka tools installed, you can launch them via a container like
```
docker-compose exec connect kafka-avro-console-consumer --bootstrap-server broker:29092 --property schema.registry.url="http://schema-registry:8081" --topic ORCLCDB.C__MYUSER.EMP --from-beginning
```

The (simplified) output of kafka-avro-console-consumer should look something like
```
{"I":"\u0001","NAME":{"string":"Bob"}}
{"I":"\u0002","NAME":{"string":"Jane"}}
{"I":"\u0003","NAME":{"string":"Mary"}}
{"I":"\u0004","NAME":{"string":"Alice"}}
```

# Schema
Let's see what schemas we have registered now
```console
curl -s -X GET http://localhost:8081/subjects/ORCLCDB.C__MYUSER.EMP-value/versions/1 | jq -r .schema | jq .
```

Amongst other things, you'll see version 1 of the schema has been registered like this
```
  "fields": [
    {
      "name": "I",
      "type": {
        "type": "bytes"
    },
    {
      "name": "NAME",
      "type": [
        "string"
      ]
    }
  ```


# Insert, update and delete some data

Run `docker-compose exec oracle /scripts/go_sqlplus.sh` followed by this SQL

```
insert into C##MYUSER.emp (name) values ('Dale');
insert into C##MYUSER.emp (name) values ('Emma');
update C##MYUSER.emp set name = 'Robert' where name = 'Bob';
delete C##MYUSER.emp where name = 'Jane';
commit;
exit
```

## Updated Sample Data
This adds 2 rows to `EMP` table, updates 1 row, and deletes 1 row.

| I (primary key)    | Name |
| ----------- | ----------- |
| 1           | Bob --> Robert         |
| 2           | Jane (deleted)        |
| 3           | Mary        |
| 4           | Alice       |
| 5           | Dale        |
| 6           | Emma        |


The (simplified) output of kafka-avro-console-consumer should look something like
```
{"I":"\u0005","NAME":{"string":"Dale"},"op_type":{"string":"I"}}
{"I":"\u0006","NAME":{"string":"Emma"},"op_type":{"string":"I"}}
{"I":"\u0001","NAME":{"string":"Robert"},"op_type":{"string":"U"}}
{"I":"\u0002","NAME":{"string":"Jane"},"op_type":{"string":"D"}
```



# DDL 
Run `docker-compose exec oracle /scripts/go_sqlplus.sh` followed by this SQL

```
ALTER TABLE C##MYUSER.EMP ADD (SURNAME VARCHAR2(100));

insert into C##MYUSER.emp (name, surname) values ('Mickey', 'Mouse');
commit;
```

## Updated Sample Data
Our new row looks like this (note the new surname column)

| I (primary key)    | Name | Surname |
| ----------- | ----------- | -------- |
| 7           | Mickey        | Mouse |


## Schema mutation
Let's see what schemas we have registered now. We have data registered against version 1 and version 2 of the schema

```console
curl -s -X GET http://localhost:8081/subjects/ORCLCDB.C__MYUSER.EMP-value/versions

curl -s -X GET http://localhost:8081/subjects/ORCLCDB.C__MYUSER.EMP-value/versions/1 | jq '.'

curl -s -X GET http://localhost:8081/subjects/ORCLCDB.C__MYUSER.EMP-value/versions/2 | jq '.'

or you can also use:

curl -s -X GET http://localhost:8081/subjects/ORCLCDB.C__MYUSER.EMP-value/versions/2 | jq -r .schema | jq .
```

Note, schema version 2 has this addition

```
    {
      "name": "SURNAME",
      "type": [
        "null",
        "string"
      ],
      "default": null
    }
```


## Connector Delete Configuration 

If something goes wrong, you can delete the connector like this
```
curl -X DELETE localhost:8083/connectors/SimpleOracleCDC
```


# Tear down
To tear down the containers
```
docker-compose down
```