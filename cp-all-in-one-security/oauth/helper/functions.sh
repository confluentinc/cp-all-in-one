#!/bin/bash


update_cli_permissions(){

  # Script to get Confluent CLI `curl -k CLI_URL -o confluent`
  # Update the confluent cli permissions
  CONFLUENT_CLI='./bin/confluent'
  if [ -f $CONFLUENT_CLI ]; then
    echo "Updating permission of ${CONFLUENT_CLI} to 744"
    chmod 744 $CONFLUENT_CLI
  fi

}

create_certificates(){

  # Generate keys and certificates used by MDS
  echo -e "Generate keys and certificates used for MDS"
  rm -rf ./keypair/keypair.pem ./keypair/public.pem
  mkdir -p ./keypair

  openssl genrsa -out ./keypair/keypair.pem 2048; openssl rsa -in ./keypair/keypair.pem -outform PEM -pubout -out ./keypair/public.pem
}

create_client_files(){

  echo "Creating client files"
  cat templates/superuser.template | envsubst > configs/superuser.properties
  cat templates/client.template | envsubst > configs/client.properties

}

_assign_sr_role_bindings() {

  curl -X POST $1/User:$SR_CLIENT_ID/roles/SystemAdmin -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}'
  curl -X POST $1/User:$SR_CLIENT_ID/roles/SystemAdmin -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q", "schema-registry-cluster":"schema-registry"}}'
  curl -X POST $1/User:$SR_CLIENT_ID/roles/ResourceOwner/bindings -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"_confluent-command", "patternType":"LITERAL"}]}'
  curl -X POST $1/User:$SR_CLIENT_ID/roles/ResourceOwner/bindings -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"_exporter_configs", "patternType":"LITERAL"}]}'
  curl -X POST $1/User:$SR_CLIENT_ID/roles/ResourceOwner/bindings -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"_exporter_states", "patternType":"LITERAL"}]}'

}

_assign_connect_role_bindings() {

  curl -X POST $1/User:$CONNECT_CLIENT_ID/roles/SystemAdmin  -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}'
  curl -X POST $1/User:$CONNECT_CLIENT_ID/roles/ResourceOwner/bindings -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Group", "name":"connect-cluster", "patternType":"LITERAL"}]}'
  curl -X POST $1/User:$CONNECT_CLIENT_ID/roles/ResourceOwner/bindings -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"connect-configs", "patternType":"LITERAL"}]}'
  curl -X POST $1/User:$CONNECT_CLIENT_ID/roles/ResourceOwner/bindings -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"connect-offsets", "patternType":"LITERAL"}]}'
  curl -X POST $1/User:$CONNECT_CLIENT_ID/roles/ResourceOwner/bindings -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"connect-statuses", "patternType":"LITERAL"}]}'

}

_assign_c3_role_bindings() {

  curl -X POST $1/User:$C3_CLIENT_ID/roles/SystemAdmin -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}'
  curl -X POST $1/User:$C3_CLIENT_ID/roles/SystemAdmin -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q", "schema-registry-cluster":"schema-registry"}}'
  curl -X POST $1/User:$C3_CLIENT_ID/roles/ResourceOwner/bindings -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"_confluent-command", "patternType":"LITERAL"}]}'


  curl -X POST $1/Group:$SSO_USER_GROUP/roles/SystemAdmin -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}'
  curl -X POST $1/Group:$SSO_USER_GROUP/roles/SystemAdmin -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q", "schema-registry-cluster":"schema-registry"}}'
  curl -X POST $1/Group:$SSO_USER_GROUP/roles/SystemAdmin -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q","connect-cluster":"connect-cluster"}}'
}

_assign_client_role_bindings() {

 curl -X POST $1/User:$CLIENT_ID/roles/ResourceOwner/bindings -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Group", "name":"schema-registry", "patternType":"LITERAL"}]}'
 curl -X POST $1/User:$CLIENT_ID/roles/ResourceOwner/bindings -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q","connect-cluster":"connect-cluster"}}, "resourcePatterns":[{"resourceType":"Connector", "name":"datagen-source-connector", "patternType":"LITERAL"}]}'
 curl -X POST $1/User:$CLIENT_ID/roles/ResourceOwner/bindings -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"test", "patternType":"LITERAL"}]}'
 curl -X POST $1/User:$CLIENT_ID/roles/ResourceOwner/bindings -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q", "schema-registry-cluster":"schema-registry"}}, "resourcePatterns":[{"resourceType":"Subject", "name":"test_topic", "patternType":"PREFIXED"}]}'
 curl -X POST $1/User:$CLIENT_ID/roles/ResourceOwner/bindings -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Group", "name":"console-consumer-group", "patternType":"LITERAL"}]}'
 curl -X POST $1/User:$CLIENT_ID/roles/ResourceOwner/bindings -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"test_topic", "patternType":"PREFIXED"}]}'
 curl -X POST $1/User:$CLIENT_ID/roles/ResourceOwner/bindings -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Group", "name":"console-consumer-group", "patternType":"LITERAL"}]}'

}

_assing_users_role_bindings(){

  curl -X POST $1/Group:$SSO_SUPER_USER_GROUP/roles/SystemAdmin -H "Authorization: Bearer $2" -i -H "Content-Type: application/json" -H "Accept: application/json" -d '{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}'

}

# Assign application role bindings
assign_role_bindings()
{
auth_token=$(curl -s -d "client_id=$SUPERUSER_CLIENT_ID" -d "client_secret=$SUPERUSER_CLIENT_SECRET" -d "grant_type=client_credentials" $IDP_TOKEN_ENDPOINT | jq -r .access_token)
echo $auth_token

MDS_RBAC_ENDPOINT=http://broker:8091/security/1.0/principals

_assign_sr_role_bindings  $MDS_RBAC_ENDPOINT $auth_token
_assign_connect_role_bindings $MDS_RBAC_ENDPOINT $auth_token
_assign_c3_role_bindings $MDS_RBAC_ENDPOINT $auth_token
_assign_client_role_bindings $MDS_RBAC_ENDPOINT $auth_token
_assing_users_role_bindings $MDS_RBAC_ENDPOINT $auth_token
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
    -d "client_id=$SUPERUSER_CLIENT_ID" \
    -d "client_secret=$SUPERUSER_CLIENT_SECRET" \
    -d "grant_type=client_credentials" \
    $IDP_TOKEN_ENDPOINT | jq -r .access_token)

  export SCHEMA_REGISTRY_ACCESS_TOKEN=$(curl -s \
    -d "client_id=$SR_CLIENT_ID" \
    -d "client_secret=$SR_CLIENT_SECRET" \
    -d "grant_type=client_credentials" \
    $IDP_TOKEN_ENDPOINT | jq -r .access_token)

  export CONNECT_ACCESS_TOKEN=$(curl -s \
    -d "client_id=$CONNECT_CLIENT_ID" \
    -d "client_secret=$CONNECT_CLIENT_SECRET" \
    -d "grant_type=client_credentials" \
    $IDP_TOKEN_ENDPOINT | jq -r .access_token)

  export C3_ACCESS_TOKEN=$(curl -s \
    -d "client_id=$C3_CLIENT_ID" \
    -d "client_secret=$C3_CLIENT_SECRET" \
    -d "grant_type=client_credentials" \
    $IDP_TOKEN_ENDPOINT | jq -r .access_token)
}

create_topic(){
docker exec broker kafka-topics --bootstrap-server broker:9095 --topic $1 --create --command-config /etc/confluent/configs/keycloak/superuser.properties
}
