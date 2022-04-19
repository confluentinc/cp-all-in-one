#!/bin/sh

sed -i '/docker\/configure/a \\ncat /tmp/myprops.properties >> /etc/confluent-control-center/control-center.properties' /etc/confluent/docker/run
