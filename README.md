![image](images/confluent-logo-300-2.png)

# cp-all-in-one

This repo runs [cp-all-in-one](https://github.com/confluentinc/cp-all-in-one/tree/latest/cp-all-in-one), a Docker Compose for Confluent Platform.

# Standalone Usage

See [Confluent documentation](https://docs.confluent.io/platform/current/tutorials/build-your-own-demos.html?utm_source=github&utm_medium=demo&utm_campaign=ch.examples_type.community_content.cp-all-in-one) for details.

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
