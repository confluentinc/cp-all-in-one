DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
if [ "$1" ]; then
  env_file=${DIR}/helper/idp_config-$1.sh
else
  env_file=${DIR}/helper/idp_config.sh
fi
source ${DIR}/idp_config.sh

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
