![image](../images/confluent-logo-300-2.png)

# Overview

This [docker-compose.yml](docker-compose.yml) launches all services in Confluent Platform (except for the Kafka brokers), runs them in containers in your local host, and automatically configures them to connect to Confluent Cloud.

## Confluent Cloud Promo Code

The first 20 users to sign up for [Confluent Cloud](https://www.confluent.io/confluent-cloud/?utm_source=github&utm_medium=demo&utm_campaign=ch.cp-all-in-one_type.community_content.cp-all-in-one-cloud) and use promo code ``C50INTEG`` will receive an additional $50 free usage.
It must be activated by December 31, 2021, and used within 90 days, and any unused promo value on the expiration date will be forfeited.

# Pre-requisites

* Docker version 17.06.1-ce
* Docker Compose version 1.14.0 with Docker Compose file format 2.1
* You must have access to a [Confluent Cloud](https://www.confluent.io/confluent-cloud/?utm_source=github&utm_medium=demo&utm_campaign=ch.cp-all-in-one_type.community_content.cp-all-in-one-cloud) cluster
* Create a local file (e.g. at `$HOME/.confluent/java.config`) with configuration parameters to connect to your [Confluent Cloud](https://www.confluent.io/confluent-cloud/?utm_source=github&utm_medium=demo&utm_campaign=ch.cp-all-in-one_type.community_content.cp-all-in-one-cloud) Kafka cluster.  Follow [these detailed instructions](https://github.com/confluentinc/configuration-templates/tree/master/README.md) to properly create this file.
* This setup assumes that you are using credentials associated with the Confluent Cloud user account for which no additional ACLs are required. If you are using a service account, you are responsible for pre-configuring the required ACLs using the Confluent Cloud CLI.

# Setup

Note: Use this in a *non-production* Confluent Cloud instance for development purposes only.

## Step 1

By default, the demo uses Confluent Schema Registry running in a local Docker container. If you prefer to use Confluent Cloud Schema Registry instead, you need to first set it up:

   a. [Enable Confluent Cloud Schema Registry](http://docs.confluent.io/current/quickstart/cloud-quickstart.html#step-3-configure-sr-ccloud?utm_source=github&utm_medium=demo&utm_campaign=ch.cp-all-in-one_type.community_content.cp-all-in-one-cloud) prior to running the demo

   b. Validate your credentials to Confluent Cloud Schema Registry

   ```bash
   $ curl -u <SR API KEY>:<SR API SECRET> https://<SR ENDPOINT>/subjects
   ```

## Step 2

By default, the demo uses ksqlDB running in a local Docker container. If you prefer to use Confluent Cloud ksqlDB instead, you need to first set it up:

   a. [Enable Confluent Cloud ksqlDB](https://docs.confluent.io/current/quickstart/cloud-quickstart/ksql.html#create-a-ksqldb-application-in-ccloud?utm_source=github&utm_medium=demo&utm_campaign=ch.cp-all-in-one_type.community_content.cp-all-in-one-cloud) prior to running the demo

   b. Validate your credentials to Confluent Cloud ksqlDB

   ```bash
   $ curl -H "Content-Type: application/vnd.ksql.v1+json; charset=utf-8" -u <ksqlDB API KEY>:<ksqlDB API SECRET> https://<ksqlDB ENDPOINT>/info
   ```

## Step 3

Generate a file of ENV variables used by Docker to set the bootstrap servers and security configuration.
(See [documentation](https://docs.confluent.io/current/cloud/connect/auto-generate-configs.html?utm_source=github&utm_medium=demo&utm_campaign=ch.cp-all-in-one_type.community_content.cp-all-in-one-cloud) for more information on using this script.)

   a. If you want to use Confluent Schema Registry running in a local Docker container:

   ```bash
   $ ../utils/ccloud-generate-cp-configs.sh $HOME/.confluent/java.config schema_registry_docker.config
   ```

   b. If you want to use Confluent Cloud Schema Registry:

   ```bash
   $ ../utils/ccloud-generate-cp-configs.sh $HOME/.confluent/java.config
   ```

## Step 4

Source the generated file of ENV variables

```bash
$ source ./delta_configs/env.delta
```

# Bring up services

Make sure you completed the steps in the Setup section above before proceeding. 

You may bring up all services in the Docker Compose file at once or individually.

## All services at once

```bash
$ docker-compose up -d
```

## Confluent Schema Registry

If you are not using Confluent Cloud Schema Registry:

```bash
$ docker-compose up -d schema-registry
```

## Kafka Connect

```bash
$ docker-compose up -d connect
```

Note that the [docker-compose.yml](docker-compose.yml) file is running the Docker image [cnfldemos/cp-server-connect-datagen](https://hub.docker.com/r/cnfldemos/cp-server-connect-datagen/) which pre-bundles the [kafka-connect-datagen](https://www.confluent.io/hub/confluentinc/kafka-connect-datagen) connector.
If you want to run Connect with any other connector, first add your desired connector to the base Kafka Connect Docker image as described [here](https://docs.confluent.io/current/connect/managing/extending.html) and then substitute that Docker image in your Docker Compose file.

## Confluent Control Center

```bash
$ docker-compose up -d control-center
```

## ksqlDB Server

If you are not using Confluent Cloud ksqlDB:

```bash
$ docker-compose up -d ksqldb-server
```

## ksqlDB CLI

Assuming you are using Confluent Cloud ksqldB, if you want to just run a Docker container that is transient:

```bash
docker run -it confluentinc/cp-ksqldb-cli:5.5.0 -u $(echo $KSQLDB_BASIC_AUTH_USER_INFO | awk -F: '{print $1}') -p $(echo $KSQLDB_BASIC_AUTH_USER_INFO | awk -F: '{print $2}') $KSQLDB_ENDPOINT
```

If you want to run a Docker container for ksqlDB CLI from the Docker Compose file and connect to Confluent Cloud ksqlDB in a separate step:

```bash
$ docker-compose up -d ksqldb-cli
```

## Confluent REST Proxy

```bash
$ docker-compose up -d rest-proxy
```
