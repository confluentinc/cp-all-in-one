#!/bin/bash

# Assign application role bindings
assign_role_bindings()
{
auth_token=$(curl -s -d "client_id=superuser_client_app" -d "client_secret=superuser_client_app_secret" -d "grant_type=client_credentials" http://keycloak:8080/realms/cp/protocol/openid-connect/token | jq -r .access_token)
echo $auth_token

curl -X POST http://broker:8091/security/1.0/principals/Group:/app_group1/roles/SecurityAdmin -H "Authorization: Bearer $auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q", "schema-registry-cluster":"schema-registry"}}'

curl -X POST http://broker:8091/security/1.0/principals/Group:/app_group1/roles/ResourceOwner/bindings -H "Authorization: Bearer $auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Group", "name":"schema-registry-demo", "patternType":"LITERAL"}]}'

curl -X POST http://broker:8091/security/1.0/principals/Group:/app_group1/roles/ResourceOwner/bindings -H "Authorization: Bearer $auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"_confluent-command", "patternType":"LITERAL"}]}'

curl -X POST http://broker:8091/security/1.0/principals/Group:/app_group1/roles/ResourceOwner/bindings -H "Authorization: Bearer $auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"_schemas", "patternType":"LITERAL"}]}'

curl -X POST http://broker:8091/security/1.0/principals/Group:/app_group1/roles/ResourceOwner/bindings -H "Authorization: Bearer $auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Group", "name":"schema-registry", "patternType":"LITERAL"}]}'

curl -X POST http://broker:8091/security/1.0/principals/Group:/app_group1/roles/ResourceOwner/bindings -H "Authorization: Bearer $auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Group", "name":"connect-cluster", "patternType":"LITERAL"}]}'

curl -X POST http://broker:8091/security/1.0/principals/Group:/app_group1/roles/ResourceOwner/bindings -H "Authorization: Bearer $auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"connect-configs", "patternType":"LITERAL"}]}'

curl -X POST http://broker:8091/security/1.0/principals/Group:/app_group1/roles/ResourceOwner/bindings -H "Authorization: Bearer $auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"connect-offsets", "patternType":"LITERAL"}]}'

curl -X POST http://broker:8091/security/1.0/principals/Group:/app_group1/roles/ResourceOwner/bindings -H "Authorization: Bearer $auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"connect-statuses", "patternType":"LITERAL"}]}'

curl -X POST http://broker:8091/security/1.0/principals/Group:/app_group1/roles/SecurityAdmin -H "Authorization: Bearer $auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q","connect-cluster":"connect-cluster"}}'

curl -X POST http://broker:8091/security/1.0/principals/Group:/app_group1/roles/ResourceOwner/bindings -H "Authorization: Bearer $auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q","connect-cluster":"connect-cluster"}}, "resourcePatterns":[{"resourceType":"Connector", "name":"datagen-source-connector", "patternType":"LITERAL"}]}'

curl -X POST http://broker:8091/security/1.0/principals/Group:/app_group1/roles/SystemAdmin -H "Authorization: Bearer $auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}'

curl -X POST http://broker:8091/security/1.0/principals/User:client_app1/roles/ResourceOwner/bindings -H "Authorization: Bearer $auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json"  -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"test", "patternType":"LITERAL"}]}'

curl -X POST http://broker:8091/security/1.0/principals/User:client_app1/roles/ResourceOwner/bindings -H "Authorization: Bearer $auth_token"  -i -H "Content-Type: application/json"  -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Group", "name":"console-consumer-group", "patternType":"LITERAL"}]}'

curl -X POST http://broker:8091/security/1.0/principals/User:sr_client_app/roles/SystemAdmin -H "Authorization: Bearer $auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q", "schema-registry-cluster":"schema-registry"}}'

curl -X POST http://broker:8091/security/1.0/principals/User:connect_client_app/roles/SystemAdmin  -H "Authorization: Bearer $auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q","connect-cluster":"connect-cluster"}}'

curl -X POST http://broker:8091/security/1.0/principals/User:client_app1/roles/ResourceOwner/bindings -H "Authorization: Bearer $auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q", "schema-registry-cluster":"schema-registry"}}, "resourcePatterns":[{"resourceType":"Subject", "name":"test_topic", "patternType":"PREFIXED"}]}'

curl -X POST http://broker:8091/security/1.0/principals/User:client_app1/roles/ResourceOwner/bindings -H "Authorization: Bearer $auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"test_topic", "patternType":"PREFIXED"}]}'

curl -X POST http://broker:8091/security/1.0/principals/User:client_app1/roles/ResourceOwner/bindings -H "Authorization: Bearer $auth_token" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Group", "name":"console-consumer-group", "patternType":"LITERAL"}]}'

}

create_topic(){
docker exec broker kafka-topics --bootstrap-server broker:9095 --topic $1 --create --command-config /etc/confluent/configs/superuser_client.properties
}

install_connectors(){
  # Install datagen connector
  docker exec connect confluent-hub install --no-prompt confluentinc/kafka-connect-datagen:0.6.5
  # Install avro converter
  docker exec connect confluent-hub install --no-prompt confluentinc/kafka-connect-avro-converter:7.6.0
  # Restart the connect to load the connectors
  docker restart connect
}

get_user_tokens(){

  export SUPER_USER_ACCESS_TOKEN=$(curl -s \
    -d "client_id=superuser_client_app" \
    -d "client_secret=superuser_client_app_secret" \
    -d "grant_type=client_credentials" \
    http://keycloak:8080/realms/cp/protocol/openid-connect/token | jq -r .access_token)

  export SCHEMA_REGISTRY_ACCESS_TOKEN=$(curl -s \
    -d "client_id=sr_client_app" \
    -d "client_secret=sr_client_app_secret" \
    -d "grant_type=client_credentials" \
    http://keycloak:8080/realms/cp/protocol/openid-connect/token | jq -r .access_token)

  export CONNECT_ACCESS_TOKEN=$(curl -s \
    -d "client_id=connect_client_app" \
    -d "client_secret=connect_client_app_secret" \
    -d "grant_type=client_credentials" \
    http://keycloak:8080/realms/cp/protocol/openid-connect/token | jq -r .access_token)

}