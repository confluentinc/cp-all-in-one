#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
source ${DIR}/helper/functions.sh
# source ${DIR}/env.sh

#-------------------------------------------------------------------------------
# Script to get Confluent CLI
# curl -k CLI_URL -o confluent
# Update the confluent cli permissions
CONFLUENT_CLI='./confluent'
if [ -f $CONFLUENT_CLI ]; then
  echo "Updating permission of ${CONFLUENT_CLI} to 744"
  chmod 744 $CONFLUENT_CLI
fi

/bin/bash ./create-certificates.sh

# Start Keycloak and Broker instances
docker-compose up --no-recreate -d keycloak broker
# Wait for sometime to get the broker properly booted
sleep 30

# Assign all required role bindings.
assign_role_bindings

# Do we need this??
create_topic test

# Get other CP component services
docker-compose up --no-recreate -d schema-registry connect control-center

# Install some connectors for demo use case
install_connectors

# Get different user tokens and set it in current session
get_user_tokens