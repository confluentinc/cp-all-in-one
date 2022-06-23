#!/bin/bash

TOPICAVRO=$1

# Test for 10 messages in topic
[[ $(docker exec -e TOPICAVRO=$TOPICAVRO schema-registry bash -c 'kafka-avro-console-consumer --bootstrap-server broker:29092 --property schema.registry.url=http://schema-registry:8081 --topic $TOPICAVRO --from-beginning --max-messages 10 --timeout-ms 10000' 2>&1 | grep "Processed a total of 10 messages") == "Processed a total of 10 messages" ]]
