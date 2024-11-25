ARG CONFLUENT_DOCKER_TAG
FROM confluentinc/cp-server-connect-base:$CONFLUENT_DOCKER_TAG

RUN   confluent-hub install --no-prompt confluentinc/kafka-connect-datagen:0.6.5 \
   && confluent-hub install --no-prompt confluentinc/kafka-connect-avro-converter:7.6.0
