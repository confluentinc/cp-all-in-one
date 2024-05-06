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

# ARG REPOSITORY
# ARG CP_VERSION

# Stage 1 -- install connectors
FROM confluentinc/cp-server-connect:master-latest AS install-connectors

ENV CONNECT_PLUGIN_PATH: "/usr/share/java,/usr/share/confluent-hub-components"

# Install datagen connector
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-datagen:0.6.5

# Install avro converter
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-avro-converter:7.6.0

# Stage 2 -- copy jars
FROM confluentinc/cp-server-connect:master-latest

COPY --from=install-connectors /usr/share/confluent-hub-components/ /usr/share/confluent-hub-components/