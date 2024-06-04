#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
source ${DIR}/helper/env.sh
source ${DIR}/helper/functions.sh

#-------------------------------------------------------------------------------
# Update cli permission to be executable
update_cli_permissions

# Create public/private keys for MDS
create_certificates

# Create client files to be used for produce/consume
create_client_files

# Start Keycloak and Broker instances
docker-compose up --no-recreate -d broker

echo "Waiting for 30 seconds to complete the broker startup"
sleep 30

# Assign all required role bindings.
assign_role_bindings

# Get other CP component services
docker-compose up --no-recreate -d schema-registry connect

# Install some connectors for demo use case
install_connectors

docker-compose up --no-recreate -d control-center

# Get different user tokens and set it in current session
get_user_tokens