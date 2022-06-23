#!/bin/bash

TOPIC=$1

# Test for 10th message in topic
[[ $(docker run -t -e TOPIC=$TOPIC -e CONFLUENT_BOOTSTRAP_SERVERS=${CONFLUENT_BOOTSTRAP_SERVERS} -e CONFLUENT_API_KEY=${CONFLUENT_API_KEY} -e CONFLUENT_API_SECRET=${CONFLUENT_API_SECRET} --name confluent-cli confluentinc/confluent-cli:2.16.0 bash -c 'confluent context create context-test --bootstrap ${CONFLUENT_BOOTSTRAP_SERVERS} --api-key ${CONFLUENT_API_KEY} --api-secret ${CONFLUENT_API_SECRET} && confluent context use context-test && timeout 10s confluent kafka topic consume -b $TOPIC') =~ '{"count": 9}' ]]
