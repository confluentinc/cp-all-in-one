#!/bin/bash

# DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
# source ${DIR}/helper/functions.sh
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

auth_token=$(docker exec broker curl -s -d "client_id=superuser_client_app" -d "client_secret=superuser_client_app_secret" -d "grant_type=client_credentials" http://keycloak:8080/realms/cp/protocol/openid-connect/token | jq .access_token)

stripped_auth_token=${auth_token//\"/}

echo $stripped_auth_token

docker exec broker curl http://broker:8091 -H "Authorization: Bearer $stripped_auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://broker:8091/security/1.0/principals/Group:/app_group1/roles/SecurityAdmin -d '{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q", "schema-registry-cluster":"schema-registry"}}'

docker exec broker curl http://broker:8091 -H "Authorization: Bearer $stripped_auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://broker:8091/security/1.0/principals/Group:/app_group1/roles/ResourceOwner/bindings -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Group", "name":"schema-registry-demo", "patternType":"LITERAL"}]}'

docker exec broker curl http://broker:8091 -H "Authorization: Bearer $stripped_auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://broker:8091/security/1.0/principals/Group:/app_group1/roles/ResourceOwner/bindings -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"_confluent-command", "patternType":"LITERAL"}]}'

docker exec broker curl http://broker:8091 -H "Authorization: Bearer $stripped_auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://broker:8091/security/1.0/principals/Group:/app_group1/roles/ResourceOwner/bindings -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"_schemas", "patternType":"LITERAL"}]}'

docker exec broker curl http://broker:8091 -H "Authorization: Bearer $stripped_auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://broker:8091/security/1.0/principals/Group:/app_group1/roles/ResourceOwner/bindings -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Group", "name":"schema-registry", "patternType":"LITERAL"}]}'

docker exec broker curl http://broker:8091 -H "Authorization: Bearer $stripped_auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://broker:8091/security/1.0/principals/Group:/app_group1/roles/ResourceOwner/bindings -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Group", "name":"connect-cluster", "patternType":"LITERAL"}]}'

docker exec broker curl http://broker:8091 -H "Authorization: Bearer $stripped_auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://broker:8091/security/1.0/principals/Group:/app_group1/roles/ResourceOwner/bindings -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"connect-configs", "patternType":"LITERAL"}]}'

docker exec broker curl http://broker:8091 -H "Authorization: Bearer $stripped_auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://broker:8091/security/1.0/principals/Group:/app_group1/roles/ResourceOwner/bindings -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"connect-offsets", "patternType":"LITERAL"}]}'

docker exec broker curl http://broker:8091 -H "Authorization: Bearer $stripped_auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://broker:8091/security/1.0/principals/Group:/app_group1/roles/ResourceOwner/bindings -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"connect-statuses", "patternType":"LITERAL"}]}'

docker exec broker curl http://broker:8091 -H "Authorization: Bearer $stripped_auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://broker:8091/security/1.0/principals/Group:/app_group1/roles/SecurityAdmin -d '{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q","connect-cluster":"connect-cluster"}}'

docker-compose up --no-recreate -d schema-registry connect