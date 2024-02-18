# Confluent Platform All-In-One

This repository contains a set of Docker Compose files for running Confluent Platform. It is organized as follows:

1. `cp-all-in-one`: Confluent Enterprise License version of Confluent Platform, including Confluent Server (and ZooKeeper),
Schema Registry, a Kafka Connect worker with the Datagen Source connector plugin installed, Confluent Control Center,
REST Proxy, and ksqlDB.
2. `cp-all-in-one-kraft`: Confluent Enterprise License version of Confluent Platform, including Confluent Server using KRaft (no ZooKeeper), Schema Registry, a Kafka Connect worker with the Datagen Source connector plugin installed, Confluent Control Center,
REST Proxy, and ksqlDB.
3. `cp-all-in-one-flink`: Confluent Enterprise License version of Confluent Platform, including Confluent Server using KRaft (no ZooKeeper), Schema Registry, a Kafka Connect worker with the Datagen Source connector plugin installed, Confluent Control Center,
REST Proxy, ksqlDB, Flink Job Manager, Flink Task Manager, and Flink SQL CLI.
4. `cp-all-in-one-community`: Confluent Community License version of Confluent Platform include the Kafka broker,
Schema Registry, a Kafka Connect worker with the Datagen Source connector plugin installed, Confluent Control Center,
REST Proxy, and ksqlDB.
5. `cp-all-in-one-cloud`: Docker Compose files that can be used to run Confluent Platform components (Schema Registry, a Kafka Connect worker with the Datagen Source connector plugin installed, Confluent Control Center,
REST Proxy, or ksqlDB) against Confluent Cloud. 

Please refer to the instructions in each example folder's README.
