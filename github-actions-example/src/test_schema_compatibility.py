#!/usr/bin/env python
#
# Copyright 2020 Confluent Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# =============================================================================
#
# Produce messages to Confluent Cloud
# Using Confluent Python Client for Apache Kafka
# Writes Avro data, integration with Confluent Cloud Schema Registry
#
# =============================================================================
import sys
from confluent_kafka.schema_registry import SchemaRegistryClient
from confluent_kafka.schema_registry.schema_registry_client import Schema

import json
import ccloud_lib

if __name__ == '__main__':

    # Read arguments and configurations and initialize
    args = ccloud_lib.parse_args()
    config_file = args.config_file
    topic = args.topic
    schema_new = args.schema
    expected_pass = args.expected_pass
    conf = ccloud_lib.read_ccloud_config(config_file)

    schema_registry_conf = {
        'url': conf['schema.registry.url'],
        'basic.auth.user.info': conf['basic.auth.user.info']}

    schema_registry_client = SchemaRegistryClient(schema_registry_conf)

    with open(schema_new) as fd:
      schema_str = fd.read()
    schema = Schema(schema_str, schema_type='AVRO')
    subject = topic + "-value"
    is_compatible = schema_registry_client.test_compatibility(subject, schema)
    print("Result of compatibility test for schema " + schema_new + " against subject " + subject + " : ", is_compatible, " (expected ", expected_pass, ")")

    if is_compatible == expected_pass:
      sys.exit(0)
    else:
      sys.exit(1)
