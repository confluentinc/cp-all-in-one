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
  cat templates/superuser.template | envsubst > mount/superuser.properties
  cat templates/client.template | envsubst > mount/client.properties

}

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
auth_token=$(curl -s -d "client_id=$SUPERUSER_CLIENT_ID" -d "client_secret=$SUPERUSER_CLIENT_SECRET" -d "grant_type=client_credentials" $IDP_TOKEN_ENDPOINT | jq -r .access_token)
echo $auth_token

MDS_RBAC_ENDPOINT=http://broker:8091/security/1.0/principals

_assign_sr_role_bindings  $MDS_RBAC_ENDPOINT $auth_token
_assign_connect_role_bindings $MDS_RBAC_ENDPOINT $auth_token
_assign_ksql_role_bindings $MDS_RBAC_ENDPOINT $auth_token
_assign_c3_role_bindings $MDS_RBAC_ENDPOINT $auth_token
_assign_client_role_bindings $MDS_RBAC_ENDPOINT $auth_token
_assign_users_role_bindings $MDS_RBAC_ENDPOINT $auth_token
}

install_connectors(){
  # Install datagen connector
  docker exec connect confluent-hub install --no-prompt confluentinc/kafka-connect-datagen:0.6.5
  # Install avro converter
  docker exec connect confluent-hub install --no-prompt confluentinc/kafka-connect-avro-converter:7.6.0
  # Restart the connect to load the connectors
  docker restart connect
}

set_user_tokens(){

  echo "Setting up tokens for different workflows"

  export SUPER_USER_ACCESS_TOKEN=$(curl -s \
    -d "client_id=$SUPERUSER_CLIENT_ID" \
    -d "client_secret=$SUPERUSER_CLIENT_SECRET" \
    -d "grant_type=client_credentials" \
    $IDP_TOKEN_ENDPOINT | jq -r .access_token)

  export CLIENT_APP_ACCESS_TOKEN=$(curl -s \
      -d "client_id=$CLIENT_APP_ID" \
      -d "client_secret=$CLIENT_APP_SECRET" \
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

  export KSQL_ACCESS_TOKEN=$(curl -s \
     -d "client_id=$KSQL_CLIENT_ID" \
     -d "client_secret=$KSQL_CLIENT_SECRET" \
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

create_env_file() {
    echo DOCKER_REGISTRY=$DOCKER_REGISTRY > .env
    echo CONFLUENT=$CONFLUENT >> .env
    echo CONFLUENT_DOCKER_TAG=$CONFLUENT_DOCKER_TAG >> .env
    echo CONFLUENT_SHORT=$CONFLUENT_SHORT >> .env
    echo CONFLUENT_PREVIOUS=$CONFLUENT_PREVIOUS >> .env
    echo CONFLUENT_RELEASE_TAG_OR_BRANCH=$CONFLUENT_RELEASE_TAG_OR_BRANCH >> .env
    echo CONFLUENT_MAJOR=$CONFLUENT_MAJOR >> .env
    echo CONFLUENT_MINOR=$CONFLUENT_MINOR >> .env
    echo CONFLUENT_PATCH=$CONFLUENT_PATCH >> .env
    echo CP_VERSION_FULL=$CP_VERSION_FULL >> .env
    echo IDP_TOKEN_ENDPOINT=$IDP_TOKEN_ENDPOINT >> .env
    echo IDP_JWKS_ENDPOINT=$IDP_JWKS_ENDPOINT >> .env
    echo IDP_EXPECTED_ISSUER=$IDP_EXPECTED_ISSUER >> .env
    echo IDP_AUTH_ENDPOINT=$IDP_AUTH_ENDPOINT >> .env
    echo IDP_DEVICE_AUTH_ENDPOINT=$IDP_DEVICE_AUTH_ENDPOINT >> .env
    echo SUB_CLAIM_NAME=$SUB_CLAIM_NAME >> .env
    echo GROUP_CLAIM_NAME=$GROUP_CLAIM_NAME >> .env
    echo EXPECTED_AUDIENCE=$EXPECTED_AUDIENCE >> .env

# Client configurations
    echo APP_GROUP_NAME=$APP_GROUP_NAME >> .env

    echo SUPERUSER_CLIENT_ID=$SUPERUSER_CLIENT_ID >> .env
    echo SUPERUSER_CLIENT_SECRET=$SUPERUSER_CLIENT_SECRET >> .env

    echo SR_CLIENT_ID=$SR_CLIENT_ID >> .env
    echo SR_CLIENT_SECRET=$SR_CLIENT_SECRET >> .env

    echo RP_CLIENT_ID=$RP_CLIENT_ID >> .env
    echo RP_CLIENT_SECRET=$RP_CLIENT_SECRET >> .env

    echo CONNECT_CLIENT_ID=$CONNECT_CLIENT_ID >> .env
    echo CONNECT_CLIENT_SECRET=$CONNECT_CLIENT_SECRET >> .env

    echo CONNECT_SECRET_PROTECTION_CLIENT_ID=$CONNECT_SECRET_PROTECTION_CLIENT_ID >> .env
    echo CONNECT_SECRET_PROTECTION_CLIENT_SECRET=$CONNECT_SECRET_PROTECTION_CLIENT_SECRET >> .env

    echo C3_CLIENT_ID=$C3_CLIENT_ID >> .env
    echo C3_CLIENT_SECRET=$C3_CLIENT_SECRET >> .env

    echo CLIENT_APP_ID=$CLIENT_APP_ID >> .env
    echo CLIENT_APP_SECRET=$CLIENT_APP_SECRET >> .env

    echo SSO_CLIENT_ID=$SSO_CLIENT_ID >> .env
    echo SSO_CLIENT_SECRET=$SSO_CLIENT_SECRET >> .env

    echo SSO_SUPER_USER_GROUP=$SSO_SUPER_USER_GROUP >> .env
    echo SSO_USER_GROUP=$SSO_USER_GROUP >> .env

    echo KSQL_CLIENT_ID=$KSQL_CLIENT_ID >> .env
    echo KSQL_CLIENT_SECRET=$KSQL_CLIENT_SECRET >> .env
}
