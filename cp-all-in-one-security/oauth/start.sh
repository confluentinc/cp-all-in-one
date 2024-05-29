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

docker-compose up --no-recreate -d keycloak broker

sleep 30

auth_token=$(docker exec broker curl -s -d "client_id=superuser_client_app" -d "client_secret=superuser_client_app_secret" -d "grant_type=client_credentials" http://keycloak:8080/realms/cp/protocol/openid-connect/token | jq -r .access_token)

echo $auth_token

assign_role_bindings

docker-compose up --no-recreate -d schema-registry

docker-compose up --no-recreate -d connect control-center
