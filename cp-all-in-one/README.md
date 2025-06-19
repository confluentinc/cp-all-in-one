![image](../images/confluent-logo-300-2.png)
  
# Confluent Platform All-in-One

This Docker Compose setup provides a complete Confluent Platform environment with Control Center, Prometheus, and Alertmanager monitoring.

## Quick Start

### Default Setup
```bash
docker-compose up -d
```

### Custom Control Center Version
You can specify the Control Center version using the `C3_VERSION` environment variable:

```bash
# For Control Center version 2.1.0
C3_VERSION=2.1.0 docker-compose up -d

# For Control Center version 2.0.0 (default)
C3_VERSION=2.0.0 docker-compose up -d
```

## Supported Versions

The following Control Center versions are supported:
- `2.0.0` (default)
- `2.1.0`

## Services

- **Kafka Broker**: `localhost:9092`
- **Control Center**: `localhost:9021`
- **Schema Registry**: `localhost:8081`
- **Kafka Connect**: `localhost:8083`
- **ksqlDB**: `localhost:8088`
- **Prometheus**: `localhost:9090`
- **Alertmanager**: `localhost:9093`

## Environment Variables

- `C3_VERSION`: Control Center version (default: `2.0.0`)

## Usage Examples

```bash
# Start with default version (2.0.0)
docker-compose up -d

# Start with version 2.1.0
C3_VERSION=2.1.0 docker-compose up -d
```

## Documentation

Refer to the [Quick Start for Confluent Platform](https://docs.confluent.io/platform/current/get-started/platform-quickstart.html) for steps to run this example.

## Flink

The Flink Job Manager is available at [http://localhost:9081](http://localhost:9081)  
Launch the Flink SQL CLI by executing `docker exec -it flink-sql-client sql-client.sh` from the command line.
