[![Try Confluent Cloud - The Data Streaming Platform](https://images.ctfassets.net/8vofjvai1hpv/10bgcSfn5MzmvS4nNqr94J/af43dd2336e3f9e0c0ca4feef4398f6f/confluent-banner-v2.svg)](https://confluent.cloud/signup?utm_source=github&utm_medium=banner&utm_campaign=oss-repos&utm_term=cp-all-in-one)

# cp-all-in-one

1. `cp-all-in-one`: Confluent Enterprise License version of Confluent Platform, including Confluent Server,
Schema Registry, a Kafka Connect worker with the Datagen Source connector plugin installed, Confluent Control Center,
REST Proxy, ksqlDB, and Flink.
2. `cp-all-in-one-community`: Confluent Community License version of Confluent Platform include the Kafka broker,
Schema Registry, a Kafka Connect worker with the Datagen Source connector plugin installed, Confluent Control Center,
REST Proxy, ksqlDB, and Flink.
3. `cp-all-in-one-cloud`: Docker Compose files that can be used to run Confluent Platform components (Schema Registry, a Kafka Connect worker with the Datagen Source connector plugin installed, Confluent Control Center,
REST Proxy, or ksqlDB) against Confluent Cloud. 
4. `cp-all-in-one-security/oauth`: Confluent Enterprise License version of Confluent Platform that showcases Confluent Platform's OAuth 2.0 support using the [Keycloak](https://www.keycloak.org/) identity provider.

# Usage as a GitHub Action

- `service`: up to which service in the docker-compose.yml file to run.  Default is none, so all services are run
- `github-branch-version`: which GitHub branch of [cp-all-in-one](https://github.com/confluentinc/cp-all-in-one) to run.  Default is `latest`.
- `type`: cp-all-in-one (based on Confluent Server) or cp-all-in-one-community (based on Apache Kafka)

Example to run Confluent Server on Confluent Platform `7.7.1`:

```yaml

    steps:

      - name: Run Confluent Platform (Confluent Server)
        uses: confluentinc/cp-all-in-one@v0.1
        with:
          service: broker
          github-branch-version: 7.7.1-post
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

- Kafka broker: 9092
- Kafka broker JMX: 9101
- Confluent Schema Registry: 8081
- Kafka Connect: 8083
- Confluent Control Center: 9021
- ksqlDB: 8088
- Confluent REST Proxy: 8082
- Flink Job Manager: 9081
