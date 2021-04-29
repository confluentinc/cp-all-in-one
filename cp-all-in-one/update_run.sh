#!/bin/sh

sed -i '/KAFKA_ZOOKEEPER_CONNECT/d' /etc/confluent/docker/configure

sed -i 's/cub zk-ready/echo ignore zk-ready/' /etc/confluent/docker/ensure
echo "kafka-storage format -t $(kafka-storage random-uuid) -c /etc/kafka/kafka.properties" >> /etc/confluent/docker/ensure

echo "mkdir /tmp/kraft-combined-logs"
mkdir /tmp/kraft-combined-logs

sed -i '/docker\/configure/a \\ncat /tmp/myprops.properties >> /etc/kafka/kafka.properties' /etc/confluent/docker/run

#echo "ls /etc/kafka/kafka.properties"
#ls /etc/kafka/kafka.properties
#cat /etc/kafka/kafka.properties
#cat /tmp/myprops.properties

#echo "ls /tmp"
#ls /tmp
#echo "cat /etc/confluent/docker/run"
#cat /etc/confluent/docker/run
