# cp-all-in-one-cloud

Use `cp-all-in-one-cloud` to connect your self-managed services to Confluent Cloud.
This Docker Compose file launches Confluent Platform services (except for the Kafka brokers) locally in containers, and 
configures them to connect to Confluent Cloud.

## Confluent Cloud Setup

The `cp-all-in-one-cloud` Docker Compose file references environment variables like `BOOTSTRAP_SERVERS` that will be
automatically created for you if you use the [ccloud-stack](https://docs.confluent.io/cloud/current/get-started/examples/ccloud/docs/ccloud-stack.html) utility to create a set of fully managed services in Confluent Cloud.
Executed with a single command, `ccloud-stack` provides a quick way to create fully managed components in Confluent Cloud, which you can then use for learning and building other demos.
The script uses the Confluent Cloud CLI to dynamically do the following in Confluent Cloud:

-  Create a new environment.
-  Create a new service account.
-  Create a new Kafka cluster and associated credentials.
-  Enable Schema Registry in Confluent Cloud and associated credentials.
-  Create a new ksqlDB app and associated credentials.
-  Create ACLs with wildcard for the service account.
-  Generate a local configuration file with all above connection information, useful for other demos/automation.

Note: do not use `ccloud-stack` in Production.

If you do not wish to use `ccloud-stack` and instead want to run `cp-all-in-one-cloud` against Confluent Cloud resources
provisioned in another way, you'll first need to export the following environment variables:

- `BOOTSTRAP_SERVERS`: your Kafka cluster bootstrap servers endpoint, of the form `pkc-<cluster ID>.<cloud provider region>.<cloud provider>.confluent.cloud:9092`
- `SASL_JAAS_CONFIG`: Kafka cluster credentials string of the form `org.apache.kafka.common.security.plain.PlainLoginModule required username='<API key>' password='<API secret>';`
- `BASIC_AUTH_CREDENTIALS_SOURCE`: `USER_INFO`

And, if using Schema Registry in Confluent Cloud:

- `SCHEMA_REGISTRY_BASIC_AUTH_USER_INFO`: Schema Registry credentials of the form `<API key>:<API secret>`
- `SCHEMA_REGISTRY_URL`: Schema Registry endpoint of the form `https://psrc-<Schema Registry ID>.<cloud provider region>.<cloud provider>.confluent.cloud`

## Run the Example

Make sure you completed the steps in the previous section before proceeding.

1. Clone this repository.

       git clone https://github.com/confluentinc/cp-all-in-one.git

1. Navigate to the `cp-all-in-one-cloud` directory.

       cd cp-all-in-one-cloud

1. Checkout the `<github-branch>` branch.

       git checkout <github-branch>

1. To bring up all services locally:

       docker compose up -d

1. To bring up just Schema Registry locally (i.e., if you are not using Confluent Cloud Schema Registry):

       docker compose up -d schema-registry

1. To bring up Connect locally: the `cp-all-in-one-cloud/docker-compose.yml` file has a container called `connect` that is running a custom Docker image `cnfldemos/cp-server-connect-datagen <https://hub.docker.com/r/cnfldemos/cp-server-connect-datagen/>`__ which pre-bundles the `kafka-connect-datagen <https://www.confluent.io/hub/confluentinc/kafka-connect-datagen>`__ connector. Start this Docker container:

       docker compose up -d connect

   If you want to run Connect with any other connector, you need to first build a custom Docker image that adds the desired connector to the base Kafka Connect Docker image (see [Add Connectors or Software](https://docs.confluent.io/platform/current/connect/extending.html)).  Search through [Confluent Hub](https://www.confluent.io/hub/) to find the appropriate connector and set `CONNECTOR_NAME`, then build the new, custom Docker container using the provided `Docker/Dockerfile`:

       docker build --build-arg CONNECTOR_NAME=${CONNECTOR_NAME} -t localbuild/connect_custom_example:latest -f ../Docker/Dockerfile .```

   Start this custom Docker container in one of two ways:

       # Override the original Docker Compose file
       docker compose -f docker-compose.yml -f ../Docker/connect.overrides.yml up -d connect

       # Run a new Docker Compose file
       docker compose -f docker compose.connect.local.yml up -d

1. To bring up Confluent Control Center locally:

       docker compose up -d control-center

1. To bring up ksqlDB locally (if you are not using Confluent Cloud ksqlDB):

       docker compose up -d ksqldb-server

1. To bring up ksqlDB CLI locally, assuming you are using Confluent Cloud ksqldB, if you want to just run a Docker container that is transient:

       docker run -it confluentinc/cp-ksqldb-cli:5.5.0 -u $(echo $KSQLDB_BASIC_AUTH_USER_INFO | awk -F: '{print $1}') -p $(echo $KSQLDB_BASIC_AUTH_USER_INFO | awk -F: '{print $2}') $KSQLDB_ENDPOINT

   If you want to run a Docker container for ksqlDB CLI from the Docker Compose file and connect to Confluent Cloud ksqlDB in a separate step:

       docker compose up -d ksqldb-cli

1. To bring up REST Proxy locally:

       docker compose up -d rest-proxy


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
