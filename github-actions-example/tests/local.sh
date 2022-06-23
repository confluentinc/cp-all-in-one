#!/bin/bash

TOPIC=$1

# Test for 10 messages in topic
[[ $(docker exec -e TOPIC=$TOPIC broker bash -c 'kafka-console-consumer --bootstrap-server localhost:9092 --topic $TOPIC --from-beginning --max-messages 10 --timeout-ms 10000' 2>&1 | grep "Processed a total of 10 messages") == "Processed a total of 10 messages" ]]
