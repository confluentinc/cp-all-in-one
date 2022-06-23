#!/bin/sh

docker-compose -f $INPUT_TYPE/docker-compose.yml up -d $INPUT_SERVICE
sleep 20
