#!/bin/bash


_assign_sr_role_bindings() {

  curl -X POST $1/User:$SR_CLIENT_ID/roles/SystemAdmin -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}'
  curl -X POST $1/User:$SR_CLIENT_ID/roles/SystemAdmin -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q", "schema-registry-cluster":"schema-registry"}}'
  curl -X POST $1/User:$SR_CLIENT_ID/roles/ResourceOwner/bindings -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"_confluent-command", "patternType":"LITERAL"}]}'
  curl -X POST $1/User:$SR_CLIENT_ID/roles/ResourceOwner/bindings -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"_exporter_configs", "patternType":"LITERAL"}]}'
  curl -X POST $1/User:$SR_CLIENT_ID/roles/ResourceOwner/bindings -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"_exporter_states", "patternType":"LITERAL"}]}'

}

_assign_connect_role_bindings() {

  curl -X POST $1/User:$CONNECT_CLIENT_ID/roles/SystemAdmin -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}'
  curl -X POST $1/User:$CONNECT_CLIENT_ID/roles/SystemAdmin -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q", "connect-cluster":"connect-cluster"}}'
  curl -X POST $1/User:$CONNECT_CLIENT_ID/roles/ResourceOwner/bindings -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Group", "name":"connect-cluster", "patternType":"LITERAL"}]}'
  curl -X POST $1/User:$CONNECT_CLIENT_ID/roles/ResourceOwner/bindings -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"connect-configs", "patternType":"LITERAL"}]}'
  curl -X POST $1/User:$CONNECT_CLIENT_ID/roles/ResourceOwner/bindings -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"connect-offsets", "patternType":"LITERAL"}]}'
  curl -X POST $1/User:$CONNECT_CLIENT_ID/roles/ResourceOwner/bindings -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"connect-statuses", "patternType":"LITERAL"}]}'
  curl -X POST $1/User:$CONNECT_SECRET_PROTECTION_CLIENT_ID/roles/ResourceOwner/bindings -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"_confluent-secrets", "patternType":"LITERAL"}]}'
}

_assign_ksql_role_bindings() {
    curl -X POST $1/User:$KSQL_CLIENT_ID/roles/SystemAdmin -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}'
    curl -X POST $1/User:$KSQL_CLIENT_ID/roles/SystemAdmin -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q", "ksql-cluster":"ksql-cluster"}}'
    curl -X POST $1/User:$KSQL_CLIENT_ID/roles/ResourceOwner/bindings -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"_confluent-ksql-ksql-cluster_command_topic", "patternType":"LITERAL"}]}'
    curl -X POST $1/User:$KSQL_CLIENT_ID/roles/ResourceOwner/bindings -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"ksql-clusterksql_processing_log", "patternType":"LITERAL"}]}'
    curl -X POST $1/User:$KSQL_CLIENT_ID/roles/ResourceOwner/bindings -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Group", "name":"_confluent-ksql-ksql-cluster", "patternType":"LITERAL"}]}'
}

_assign_c3_role_bindings() {

  curl -X POST $1/User:$C3_CLIENT_ID/roles/SystemAdmin -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}'
  curl -X POST $1/User:$C3_CLIENT_ID/roles/SystemAdmin -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q", "schema-registry-cluster":"schema-registry"}}'
  curl -X POST $1/User:$C3_CLIENT_ID/roles/SystemAdmin -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q", "ksql-cluster":"ksql-cluster"}}'
  curl -X POST $1/User:$C3_CLIENT_ID/roles/ResourceOwner/bindings -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"_confluent-command", "patternType":"LITERAL"}]}'

}

_assign_client_role_bindings() {

  curl -X POST $1/User:$CLIENT_APP_ID/roles/ResourceOwner/bindings -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Group", "name":"schema-registry", "patternType":"LITERAL"}]}'
  curl -X POST $1/User:$CLIENT_APP_ID/roles/ResourceOwner/bindings -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q","connect-cluster":"connect-cluster"}}, "resourcePatterns":[{"resourceType":"Connector", "name":"datagen", "patternType":"PREFIXED"}]}'
  curl -X POST $1/User:$CLIENT_APP_ID/roles/ResourceOwner/bindings -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q", "schema-registry-cluster":"schema-registry"}}, "resourcePatterns":[{"resourceType":"Subject", "name":"test", "patternType":"PREFIXED"}]}'
  curl -X POST $1/User:$CLIENT_APP_ID/roles/ResourceOwner/bindings -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Group", "name":"console-consumer-group", "patternType":"LITERAL"}]}'
  curl -X POST $1/User:$CLIENT_APP_ID/roles/ResourceOwner/bindings -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"test", "patternType":"PREFIXED"}]}'

  # Secret registry in connect needs either UserAdmin or ClusterAdmin role
  curl -X POST $1/User:$CLIENT_APP_ID/roles/UserAdmin -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q", "connect-cluster":"connect-cluster"}}'

}

_assign_users_role_bindings(){

  curl -X POST $1/Group:$SSO_SUPER_USER_GROUP/roles/SystemAdmin -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}'
  curl -X POST $1/Group:$SSO_SUPER_USER_GROUP/roles/SystemAdmin -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q", "schema-registry-cluster":"schema-registry"}}'
  curl -X POST $1/Group:$SSO_SUPER_USER_GROUP/roles/SystemAdmin -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q", "connect-cluster":"connect-cluster"}}'
  curl -X POST $1/Group:$SSO_SUPER_USER_GROUP/roles/SystemAdmin -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q", "ksql-cluster":"ksql-cluster"}}'
}

# Assign application role bindings
assign_role_bindings()
{
auth_token=$(curl -s -d "client_id=$SUPERUSER_CLIENT_ID" -d "client_secret=$SUPERUSER_CLIENT_SECRET" -d "grant_type=client_credentials" $IDP_TOKEN_ENDPOINT | grep -Po '"access_token": *\K"[^"]*"' | grep -o '[^"]*')
echo $auth_token

MDS_RBAC_ENDPOINT=http://broker:8091/security/1.0/principals

_assign_sr_role_bindings  $MDS_RBAC_ENDPOINT $auth_token
_assign_connect_role_bindings $MDS_RBAC_ENDPOINT $auth_token
_assign_ksql_role_bindings $MDS_RBAC_ENDPOINT $auth_token
_assign_c3_role_bindings $MDS_RBAC_ENDPOINT $auth_token
_assign_client_role_bindings $MDS_RBAC_ENDPOINT $auth_token
_assign_users_role_bindings $MDS_RBAC_ENDPOINT $auth_token
}

create_topic(){
  kafka-topics --bootstrap-server broker:9095 --topic $1 --create --command-config /etc/confluent/configs/superuser.properties
}

# Run it
assign_role_bindings

