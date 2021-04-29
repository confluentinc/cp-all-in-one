#!/bin/sh

# Remove check for KAFKA_ZOOKEEPER_CONNECT parameter
sed -i '/KAFKA_ZOOKEEPER_CONNECT/d' /etc/confluent/docker/configure

# Ignore cub zk-ready
sed -i 's/cub zk-ready/echo ignore zk-ready/' /etc/confluent/docker/ensure

# Format the storage directory with a new cluster ID
echo "kafka-storage format -t $(kafka-storage random-uuid) -c /etc/kafka/kafka.properties" >> /etc/confluent/docker/ensure

# Add the additional properties to the existing properties file
sed -i '/docker\/configure/a \\ncat /tmp/myprops.properties >> /etc/kafka/kafka.properties' /etc/confluent/docker/run
