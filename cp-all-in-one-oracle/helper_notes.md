## Stuff
```
sqlplus sys/Oradoc_db1@ORCLPDB1 as sysdba

jdbc:oracle:thin:@localhost:1521/ORCLPDB1.localdomain
```

# Setup
```
kafka-configs --bootstrap-server localhost:9092 --entity-type brokers --entity-default --alter --add-config auto.create.topics.enable=true
```


## Topics
ORCLCDB.C__MYUSER.EMP
SimpleOracleCDC_1-ORCLCDB-redo-log

## Setup Oracle Docker


```
docker-compose exec oracle bash
sqlplus '/ as sysdba' @/scripts/oracle_setup_docker.sql
```