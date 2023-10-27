# cp-all-in-one

Use `cp-all-in-one` to run the Confluent Enterprise License version of Confluent Platform in Docker.
This Docker Compose file launches Confluent Platform services locally in containers.

## Run the Example

You can refer to the [Quick Start for Confluent Platform](https://docs.confluent.io/platform/current/platform-quickstart.html) for a guided quick start that is based on `cp-all-in-one`. The quick start shows you how to build a basic streaming app on mock data.

Or, to get started with a fresh Confluent Platform installation:

1. Clone this repository.

       git clone https://github.com/confluentinc/cp-all-in-one.git

1. Navigate to the `cp-all-in-one` directory.

       cd cp-all-in-one

1. Checkout the `<github-branch>` branch.

       git checkout <github-branch>

1. Bring up all services:

       docker compose up -d

## Ports

To connect to services in Docker, refer to the following ports:

- ZooKeeper: 2181
- Kafka broker: 9092
- Kafka broker JMX: 9101
- Confluent Schema Registry: 8081
- Kafka Connect: 8083
- Confluent Control Center: 9021
- ksqlDB: 8088
- Confluent REST Proxy: 8082
