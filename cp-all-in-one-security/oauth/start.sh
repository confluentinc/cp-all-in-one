#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
if [ "$1" ]; then
  env_file=${DIR}/helper/idp_config-$1.sh
else
  env_file=${DIR}/helper/idp_config.sh
fi
echo "Processing $env_file"
source $env_file
source ${DIR}/helper/cp_config.sh
source ${DIR}/helper/functions.sh

#-------------------------------------------------------------------------------
# Update cli permission to be executable
update_cli_permissions

# Create client files to be used for produce/consume
create_client_files

create_env_file

docker compose up -d

# # Start Keycloak and Broker instances
# docker compose up -d broker

# # waiting for sometime to get broker fully started. If it takes more time than this
# # you may want to rerun the script.
# echo "Waiting for 60 seconds to complete the broker startup"
# sleep 60

# # Assign all required role bindings.
# assign_role_bindings

# # Get other CP component services
# docker compose up --no-recreate -d schema-registry connect ksqldb-server control-center

# # Get prometheus and Grafana up
# docker compose up --no-recreate -d prometheus grafana

# # Install some connectors for demo use case
# install_connectors

# # Set different user tokens and set it in current session
# set_user_tokens
