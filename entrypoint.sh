#!/bin/sh

wget -O docker-compose.yml https://raw.githubusercontent.com/confluentinc/cp-all-in-one/$INPUT_GITHUB_BRANCH_VERSION/cp-all-in-one/docker-compose.yml
docker-compose up -d $INPUT_SERVICE
sleep 20
