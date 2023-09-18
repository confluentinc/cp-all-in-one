# cp-all-in-one

This repo runs [cp-all-in-one](https://github.com/confluentinc/cp-all-in-one/tree/latest/cp-all-in-one), a Docker Compose for Confluent Platform.

# Standalone Usage

## Confluent Cloud
This page provides resources for you to build your own Apache Kafka® demo or test
environment using Confluent Cloud or Confluent Platform. Using these as a foundation, you can
add any connectors or applications.

The examples bring up Kafka services with no pre-configured topics,
connectors, data sources, or schemas. Once the services are running, you
can provision your own topics, etc.


### cp-all-in-one-cloud

Use `cp-all-in-one-cloud` to connect your self-managed services to Confluent Cloud.
This Docker Compose file launches all services in Confluent Platform (except for the Kafka brokers), runs them in containers in your local host, and automatically
configures them to connect to Confluent Cloud.

#### Setup

1. By default, the example uses Schema Registry running in a local Docker container. 

1. By default, the example uses ksqlDB running in a local Docker container. 

1. Generate and source a file of ENV variables used by Docker to set the bootstrap
   servers and security configuration, which requires you to first
   create a local configuration file with connection information. 

1. Validate your credentials to Confluent Cloud Schema Registry:

   ```curl -u $SCHEMA_REGISTRY_BASIC_AUTH_USER_INFO $SCHEMA_REGISTRY_URL/subjects```

1. Validate your credentials to Confluent Cloud ksqlDB:

      ```curl -H "Content-Type: application/vnd.ksql.v1+json; charset=utf-8" -u $KSQLDB_BASIC_AUTH_USER_INFO $KSQLDB_ENDPOINT/info```

#### Bring up services

Make sure you completed the steps in the Setup section above before
proceeding.

1. Clone the `confluentinc/cp-all-in-one` GitHub repository.

       git clone https://github.com/confluentinc/cp-all-in-one.git

1. Navigate to the `cp-all-in-one-cloud` directory.

       cd cp-all-in-one-cloud

1. Checkout the `<github-branch>` branch.

       git checkout <github-branch>

1. To bring up all services locally, at once:

       docker-compose up -d

1. To bring up just Schema Registry locally (if you are not using Confluent Cloud Schema Registry):

       docker-compose up -d schema-registry

1. To bring up Connect locally: the `cp-all-in-one-cloud/docker-compose.yml`: file has a container called `connect` that is running a custom Docker image `cnfldemos/cp-server-connect-datagen <https://hub.docker.com/r/cnfldemos/cp-server-connect-datagen/>`__ which pre-bundles the `kafka-connect-datagen <https://www.confluent.io/hub/confluentinc/kafka-connect-datagen>`__ connector. Start this Docker container:

       docker-compose up -d connect

   If you want to run Connect with any other connector, you need to first build a custom Docker image that adds the desired connector to the base Kafka Connect Docker image (see [Add Connectors or Software](https://docs.confluent.io/platform/current/connect/extending.html)).  Search through [Confluent Hub](https://www.confluent.io/hub/) to find the appropriate connector and set `CONNECTOR_NAME`, then build the new, custom Docker container using the provided `Docker/Dockerfile`:

       docker build --build-arg CONNECTOR_NAME=${CONNECTOR_NAME} -t localbuild/connect_custom_example:latest -f ../Docker/Dockerfile .```

   Start this custom Docker container in one of two ways:

       # Override the original Docker Compose file
       docker-compose -f docker-compose.yml -f ../Docker/connect.overrides.yml up -d connect

       # Run a new Docker Compose file
       docker-compose -f docker-compose.connect.local.yml up -d

1. To bring up Control Center locally:

       docker-compose up -d control-center

1. To bring up ksqlDB locally (if you are not using Confluent Cloud ksqlDB):

       docker-compose up -d ksqldb-server

1. To bring up ksqlDB CLI locally, assuming you are using Confluent Cloud ksqldB, if you want to just run a Docker container that is transient:

       docker run -it confluentinc/cp-ksqldb-cli:5.5.0 -u $(echo $KSQLDB_BASIC_AUTH_USER_INFO | awk -F: '{print $1}') -p $(echo $KSQLDB_BASIC_AUTH_USER_INFO | awk -F: '{print $2}') $KSQLDB_ENDPOINT

   If you want to run a Docker container for ksqlDB CLI from the Docker Compose file and connect to Confluent Cloud ksqlDB in a separate step:

       docker-compose up -d ksqldb-cli

1. To bring up REST Proxy locally:

       docker-compose up -d rest-proxy


### ccloud-stack Utility

The [Example: Create Fully-Managed Services in Confluent Cloud](https://docs.confluent.io/cloud/current/get-started/examples/ccloud/docs/ccloud-stack.html) creates a stack of fully managed services in Confluent Cloud.
Executed with a single command, it is a quick way to create fully managed components in Confluent Cloud, which you can then use for learning and building other demos.
Do not use this in a production environment.
The script uses the Confluent Cloud CLI to dynamically do the following in Confluent Cloud:

-  Create a new environment.
-  Create a new service account.
-  Create a new Kafka cluster and associated credentials.
-  Enable Schema Registry in Confluent Cloud and associated credentials.
-  Create a new ksqlDB app and associated credentials.
-  Create ACLs with wildcard for the service account.
-  Generate a local configuration file with all above connection information, useful for other demos/automation.

To learn how to use `ccloud-stack` with Confluent Cloud, read more at [Example: Create Fully-Managed Services in Confluent Cloud](https://docs.confluent.io/cloud/current/get-started/examples/ccloud/docs/ccloud-stack.html).


### Generate Test Data with Datagen

Read the blog post [Creating a Serverless Environment for Testing Your Apache Kafka Applications](https://www.confluent.io/blog/testing-kafka-applications/): a “Hello, World!” for getting started with Confluent Cloud, plus different ways to generate more interesting test data to the Kafka topics.

## On-Premises

### cp-all-in-one

Use `cp-all-in-one` to run the Confluent Platform stack on-premesis.
This Docker Compose file launches all services in Confluent Platform, and runs them in containers in your local host.

1. Clone the `confluentinc/cp-all-in-one` GitHub repository.

       git clone https://github.com/confluentinc/cp-all-in-one.git

1. Navigate to the `cp-all-in-one` directory.

       cd cp-all-in-one

1. Checkout the `<github-branch>` branch.

       git checkout <github-branch>

1. To bring up all services:

       docker-compose up -d


### cp-all-in-one-community

Use `cp-all-in-one-community` to run only the community services from Confluent Platform on-premises.
This Docker Compose file launches all community services and runs them in containers in your local host.

1. Clone the `confluentinc/cp-all-in-one` GitHub repository.

       git clone https://github.com/confluentinc/cp-all-in-one.git

1. Navigate to the `cp-all-in-one-community` directory.

       cd cp-all-in-one-community

1. Checkout the `<github-branch>` branch.

       git checkout <github-branch>

1. To bring up all services:

       docker-compose up -d


#### Generate Test Data with kafka-connect-datagen

Read the blog post [Easy Ways to Generate Test Data in Kafka](https://www.confluent.io/blog/easy-ways-generate-test-data-kafka): a “Hello, World!” for launching Confluent Platform, plus different ways to generate more interesting test data to the Kafka topics.

# Usage as a GitHub Action

- `service`: up to which service in the docker-compose.yml file to run.  Default is none, so all services are run
- `github-branch-version`: which GitHub branch of [cp-all-in-one](https://github.com/confluentinc/cp-all-in-one) to run.  Default is `latest`.
- `type`: cp-all-in-one (based on Confluent Server) or cp-all-in-one-community (based on Apache Kafka)

Example to run ZooKeeper and Confluent Server on Confluent Platform `7.1.0`:

```yaml

    steps:

      - name: Run Confluent Platform (Confluent Server)
        uses: confluentinc/cp-all-in-one@v0.1
        with:
          service: broker
          github-branch-version: 7.1.1-post
```

Example to run all Apache Kafka services on `latest`:

```yaml

    steps:

      - name: Run Confluent Platform (Confluent Server)
        uses: confluentinc/cp-all-in-one@v0.1
          type: cp-all-in-one-community
```

# Ports

To connect to services in Docker, refer to the following ports:

- ZooKeeper: 2181
- Kafka broker: 9092
- Kafka broker JMX: 9101
- Confluent Schema Registry: 8081
- Kafka Connect: 8083
- Confluent Control Center: 9021
- ksqlDB: 8088
- Confluent REST Proxy: 8082