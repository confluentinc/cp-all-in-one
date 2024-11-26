![image](../images/confluent-logo-300-2.png)
  
# Documentation

This Docker Compose example includes the Confluent Community License version of Confluent Platform. It runsa Kafka broker, Schema Registry, a Kafka Connect worker with the Datagen Source connector plugin installed, Confluent Control Center,
REST Proxy, ksqlDB, and Flink.

## Flink

The Flink Job Manager is available at [http://localhost:9081](http://localhost:9081)  
Launch the Flink SQL CLI by executing `docker exec -it flink-sql-client sql-client.sh` from the command line.
