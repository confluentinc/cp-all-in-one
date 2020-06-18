![image](../images/confluent-logo-300-2.png)

* [Overview](#overview)
* [Pre-requisites](#pre-requisites)
* [Setup](#setup)
* [Bring up services](#bring-up-services)


# Overview

This [docker-compose.yml](docker-compose.yml) launches all services in Confluent Platform (except for the Kafka brokers), runs them in containers in your local host, and automatically configures them to connect to Confluent Cloud.

## Confluent Cloud Promo Code

The first 20 users to sign up for [Confluent Cloud](https://www.confluent.io/confluent-cloud/?utm_source=github&utm_medium=demo&utm_campaign=ch.cp-all-in-one_type.community_content.cp-all-in-one-cloud) and use promo code ``C50INTEG`` will receive an additional $50 free usage ([details](https://www.confluent.io/confluent-cloud-promo-disclaimer/?utm_source=github&utm_medium=demo&utm_campaign=ch.cp-all-in-one_type.community_content.cp-all-in-one-cloud)).

# Pre-requisites

* Docker version 17.06.1-ce
* Docker Compose version 1.14.0 with Docker Compose file format 2.1
* You must have access to a [Confluent Cloud](https://www.confluent.io/confluent-cloud/?utm_source=github&utm_medium=demo&utm_campaign=ch.cp-all-in-one_type.community_content.cp-all-in-one-cloud) cluster
* Create a local file (e.g. at `$HOME/.confluent/java.config`) with configuration parameters to connect to your [Confluent Cloud](https://www.confluent.io/confluent-cloud/?utm_source=github&utm_medium=demo&utm_campaign=ch.cp-all-in-one_type.community_content.cp-all-in-one-cloud) Kafka cluster.  Follow [these detailed instructions](https://github.com/confluentinc/configuration-templates/tree/master/README.md) to properly create this file.
* This setup assumes that you are using credentials associated with the Confluent Cloud user account for which no additional ACLs are required. If you are using a service account, you are responsible for pre-configuring the required ACLs using the Confluent Cloud CLI.

# Setup

1. By default, the example uses Confluent Schema Registry running in a local Docker container. If you prefer to use Confluent Cloud Schema Registry instead, you need to first [enable Confluent Cloud Schema Registry](http://docs.confluent.io/current/quickstart/cloud-quickstart.html#step-3-configure-sr-ccloud?utm_source=github&utm_medium=demo&utm_campaign=ch.cp-all-in-one_type.community_content.cp-all-in-one-cloud) prior to running the example.

2. By default, the example uses ksqlDB running in a local Docker container. If you prefer to use Confluent Cloud ksqlDB instead, you need to first [enable Confluent Cloud ksqlDB](https://docs.confluent.io/current/quickstart/cloud-quickstart/ksql.html#create-a-ksqldb-application-in-ccloud?utm_source=github&utm_medium=demo&utm_campaign=ch.cp-all-in-one_type.community_content.cp-all-in-one-cloud) prior to running the example.

3. Generate a file of ENV variables used by Docker to set the bootstrap servers and security configuration, which requires you to first create a local configuration file with connection information.
(See [documentation](https://docs.confluent.io/current/cloud/connect/auto-generate-configs.html?utm_source=github&utm_medium=demo&utm_campaign=ch.cp-all-in-one_type.community_content.cp-all-in-one-cloud) for more information on using this script.)

```bash
../utils/ccloud-generate-cp-configs.sh $HOME/.confluent/java.config
```

4. Source the generated file of ENV variables.

```bash
source ./delta_configs/env.delta
```

5. Validate your credentials to Confluent Cloud Schema Registry.

```bash
curl -u $SCHEMA_REGISTRY_BASIC_AUTH_USER_INFO $SCHEMA_REGISTRY_URL/subjects
``` 

6. Validate your credentials to Confluent Cloud ksqlDB.

```bash
curl -H "Content-Type: application/vnd.ksql.v1+json; charset=utf-8" -u $KSQLDB_BASIC_AUTH_USER_INFO $KSQLDB_ENDPOINT/info
```

# Bring up services

Make sure you completed the steps in the Setup section above before proceeding. 

You may bring up all services in the Docker Compose file at once or individually.

## All services at once

```bash
docker-compose up -d
```

## Confluent Schema Registry

If you are not using Confluent Cloud Schema Registry:

```bash
docker-compose up -d schema-registry
```

## Kafka Connect

The [docker-compose.yml](docker-compose.yml) file has a container called `connect` that is running a custom Docker image [cnfldemos/cp-server-connect-datagen](https://hub.docker.com/r/cnfldemos/cp-server-connect-datagen/) which pre-bundles the [kafka-connect-datagen](https://www.confluent.io/hub/confluentinc/kafka-connect-datagen?utm_source=github&utm_medium=demo&utm_campaign=ch.cp-all-in-one_type.community_content.cp-all-in-one-cloud) connector.
Start this Docker container:

```bash
docker-compose up -d connect
```

If you want to run Connect with any other connector, you need to first build a custom Docker image that adds the desired connector to the base Kafka Connect Docker image (documentation [here](https://docs.confluent.io/current/connect/managing/extending.html?utm_source=github&utm_medium=demo&utm_campaign=ch.cp-all-in-one_type.community_content.cp-all-in-one-cloud)).
Search through [Confluent Hub](https://www.confluent.io/hub/?utm_source=github&utm_medium=demo&utm_campaign=ch.cp-all-in-one_type.community_content.cp-all-in-one-cloud) to find the appropriate connector and set `CONNECTOR_NAME`, then build the new, custom Docker container using the provided [Dockerfile](../Docker/Dockerfile):

```bash
docker build --build-arg CONNECTOR_NAME=${CONNECTOR_NAME} -t localbuild/connect_custom_example:latest -f ../Docker/Dockerfile .
```

Start this custom Docker container in one of two ways:

```bash
# Override the original Docker Compose file
docker-compose -f docker-compose.yml -f ../Docker/connect.overrides.yml up -d connect

# Run a new Docker Compose file
docker-compose -f docker-compose.connect.local.yml up -d
```

## Confluent Control Center

```bash
docker-compose up -d control-center
```

## ksqlDB Server

If you are not using Confluent Cloud ksqlDB:

```bash
docker-compose up -d ksqldb-server
```

## ksqlDB CLI

Assuming you are using Confluent Cloud ksqldB, if you want to just run a Docker container that is transient:

```bash
docker run -it confluentinc/cp-ksqldb-cli:5.5.0 -u $(echo $KSQLDB_BASIC_AUTH_USER_INFO | awk -F: '{print $1}') -p $(echo $KSQLDB_BASIC_AUTH_USER_INFO | awk -F: '{print $2}') $KSQLDB_ENDPOINT
```

If you want to run a Docker container for ksqlDB CLI from the Docker Compose file and connect to Confluent Cloud ksqlDB in a separate step:

```bash
docker-compose up -d ksqldb-cli
```

## Confluent REST Proxy

```bash
docker-compose up -d rest-proxy
```
