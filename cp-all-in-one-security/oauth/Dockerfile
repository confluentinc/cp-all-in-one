ARG CONFLUENT_DOCKER_TAG
FROM 519856050701.dkr.ecr.us-west-2.amazonaws.com/docker/prod/confluentinc/cp-server-connect-base:8.0.x-6164-ubi9

RUN   confluent-hub install --no-prompt confluentinc/kafka-connect-datagen:0.6.5 \
   && confluent-hub install --no-prompt confluentinc/kafka-connect-avro-converter:7.6.0
