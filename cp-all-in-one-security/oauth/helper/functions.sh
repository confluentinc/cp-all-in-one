#!/bin/bash

assign_role_bindings()
{

docker exec broker curl http://broker:8091 -H "Authorization: Bearer $auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://broker:8091/security/1.0/principals/Group:/app_group1/roles/SecurityAdmin -d '{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q", "schema-registry-cluster":"schema-registry"}}'

docker exec broker curl http://broker:8091 -H "Authorization: Bearer $auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://broker:8091/security/1.0/principals/Group:/app_group1/roles/ResourceOwner/bindings -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Group", "name":"schema-registry-demo", "patternType":"LITERAL"}]}'

docker exec broker curl http://broker:8091 -H "Authorization: Bearer $auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://broker:8091/security/1.0/principals/Group:/app_group1/roles/ResourceOwner/bindings -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"_confluent-command", "patternType":"LITERAL"}]}'

docker exec broker curl http://broker:8091 -H "Authorization: Bearer $auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://broker:8091/security/1.0/principals/Group:/app_group1/roles/ResourceOwner/bindings -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"_schemas", "patternType":"LITERAL"}]}'

docker exec broker curl http://broker:8091 -H "Authorization: Bearer $auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://broker:8091/security/1.0/principals/Group:/app_group1/roles/ResourceOwner/bindings -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Group", "name":"schema-registry", "patternType":"LITERAL"}]}'

docker exec broker curl http://broker:8091 -H "Authorization: Bearer $auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://broker:8091/security/1.0/principals/Group:/app_group1/roles/ResourceOwner/bindings -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Group", "name":"connect-cluster", "patternType":"LITERAL"}]}'

docker exec broker curl http://broker:8091 -H "Authorization: Bearer $auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://broker:8091/security/1.0/principals/Group:/app_group1/roles/ResourceOwner/bindings -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"connect-configs", "patternType":"LITERAL"}]}'

docker exec broker curl http://broker:8091 -H "Authorization: Bearer $auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://broker:8091/security/1.0/principals/Group:/app_group1/roles/ResourceOwner/bindings -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"connect-offsets", "patternType":"LITERAL"}]}'

docker exec broker curl http://broker:8091 -H "Authorization: Bearer $auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://broker:8091/security/1.0/principals/Group:/app_group1/roles/ResourceOwner/bindings -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"connect-statuses", "patternType":"LITERAL"}]}'

docker exec broker curl http://broker:8091 -H "Authorization: Bearer $auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://broker:8091/security/1.0/principals/Group:/app_group1/roles/SecurityAdmin -d '{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q","connect-cluster":"connect-cluster"}}'

docker exec broker curl http://broker:8091 -H "Authorization: Bearer $auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://broker:8091/security/1.0/principals/Group:/app_group1/roles/ResourceOwner/bindings -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q","connect-cluster":"connect-cluster"}}, "resourcePatterns":[{"resourceType":"Connector", "name":"datagen-source-connector", "patternType":"LITERAL"}]}'

docker exec broker curl http://broker:8091 -H "Authorization: Bearer $auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://broker:8091/security/1.0/principals/Group:/app_group1/roles/SystemAdmin -d '{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}'

docker exec broker curl http://broker:8091 -H "Authorization: Bearer $auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://broker:8091/security/1.0/principals/User:5efae8dc-08e8-4980-8453-cb81375a029b/roles/SystemAdmin -d '{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}'

docker exec broker curl http://broker:8091 -H "Authorization: Bearer $auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://broker:8091/security/1.0/principals/User:5efae8dc-08e8-4980-8453-cb81375a029b/roles/SystemAdmin -d '{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q", "schema-registry-cluster":"schema-registry"}}'

docker exec broker curl http://broker:8091 -H "Authorization: Bearer $auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://broker:8091/security/1.0/principals/User:5efae8dc-08e8-4980-8453-cb81375a029b/roles/SystemAdmin -d '{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q","connect-cluster":"connect-cluster"}}'

}

build_connect_image()
{
  echo
  echo "Building custom Docker image with Connect version ${CONFLUENT_DOCKER_TAG} and connector version ${CONNECTOR_VERSION}"

  local DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

  DOCKERFILE="${DIR}/../Dockerfile"
  CONTEXT="${DIR}/."
  echo "docker build -t localbuild/connect:${CONFLUENT_DOCKER_TAG}-${CONNECTOR_VERSION} -f $DOCKERFILE $CONTEXT"
  docker build --build-arg CP_VERSION=${CONFLUENT_DOCKER_TAG} --build-arg REPOSITORY=${DOCKER_REGISTRY} -t localbuild/connect:master-latest -f $DOCKERFILE $CONTEXT || {
    echo "ERROR: Docker image build failed. Please troubleshoot and try again. For troubleshooting instructions see https://docs.confluent.io/platform/current/tutorials/cp-demo/docs/troubleshooting.html"
    exit 1
  }

}