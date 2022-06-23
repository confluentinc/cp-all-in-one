#!/bin/sh

cp $INPUT_TYPE/docker-compose.yml docker-compose.yml
docker-compose up -d $INPUT_SERVICE
sleep 20
