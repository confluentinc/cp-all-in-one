#!/bin/sh

# Generate random cluster ID that gets used when formatting storage
echo "export CLUSTER_ID=$(kafka-storage random-uuid)" >> /etc/confluent/docker/bash-config