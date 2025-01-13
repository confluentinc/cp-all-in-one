# OAuth in Confluent Platform

## Overview

OAuth 2.0 is an open standard to obtain limited access to an account without
exposing user credentials. Example OAuth 2.0 providers include [Keycloak](https://www.keycloak.org/) and [Okta](https://www.okta.com/).
This Docker Compose setup provides a container-based experience for getting started with Confluent
Platform's OAuth support.
This creates a Confluent Platform setup (without ksqlDB) with users configured in the Keycloak identity provider (IDP).

## Getting Started

### Prerequisites

* [`jq`](https://github.com/jqlang/jq/wiki/Installation), which is used to process JSON responses throughout this example

### Update the local DNS
**_NOTE:_**
Add the container names in your local DNS for ease of usages of commands described in this document.

Edit the `/etc/hosts` file which will require elevated privileges. E.g., to edit with `vi` on a `sudo`-enabled system:

```shell
sudo vi /etc/hosts
``` 

Add these lines at the end of the file:

```shell
127.0.0.1       keycloak
127.0.0.1       broker
127.0.0.1       schema-registry
127.0.0.1       connect
127.0.0.1       ksqldb-server
127.0.0.1       control-center
```

If you are using IPv6, you might need to add these additional lines:

```shell
::1       keycloak
::1       broker
::1       schema-registry
::1       connect
::1       ksqldb-server
::1       control-center
```

Save the file and close it.

### Start the environment

To initialise the environment, use the provided start script:

```shell
./start.sh
```

If you want to run the local Confluent Platform cluster with Okta serving as the identity provider, you can use the below command.
Please note, you need to create a file `/helper/idp_config-okta.sh` with the Okta configurations.

```shell
./start.sh okta
```

This will:

1. Start a Keycloak server on port 8080. This acts as the OAuth identity provider.
2. Run Confluent Server with Role-based access control (RBAC).
3. Create a new listener `EXTERNAL` for SASL/OAuthBearer in Confluent Server.
4. Configure Confluent Server to connect to local Keycloak identity provider.
5. Configure Schema Registry, Connect, ksqlDB and Control Center to authenticate via OAuth.
6. Datagen source connector plugin is added in Connect.
7. Configure Control Center to talk to MDS, Schema Registry, ksqlDB and Connect.
8. Configure Prometheus and Grafana for metrics visualization
9. Adds some access tokens to environment variable. These will be valid for 1 hour, after which the token access commands need to be run again.

If you need access tokens for the vaious service users for testing, please have a look at the `helper/set_user_tokens.sh`. It will acquire tokens for you. Just source it:

```shell
source helper/set_user_tokens.sh
```
   
### Produce and Consume to Kafka using OAuth from Broker

```shell
   docker compose exec broker kafka-console-producer \
     --bootstrap-server broker:9095 \
     --topic test \
     --producer.config /etc/confluent/configs/client.properties
   
   docker compose exec broker kafka-console-consumer \
     --bootstrap-server broker:9095 \
     --topic test \
     --consumer.config /etc/confluent/configs/client.properties
   ```

### Schema Registry RBAC using OAuth

All Schema Registry endpoints should be accessible with OAuth token.

List available schemas on the cluster: The `$SCHEMA_REGISTRY_ACCESS_TOKEN` would be available in the current shell. If it's not available or is expired please rerun the command below.  
<details open>
  <summary>Get Schema Registry client access token</summary> 

```shell
export SCHEMA_REGISTRY_ACCESS_TOKEN=$(curl -s\
    -d "client_id=sr_client_app" \
    -d "client_secret=sr_client_app_secret" \
    -d "grant_type=client_credentials" \
    http://keycloak:8080/realms/cp/protocol/openid-connect/token | jq -r .access_token)
```
</details>

#### Ensure the token is valid
This should return the available schema types

```curl -H "Authorization: Bearer $SCHEMA_REGISTRY_ACCESS_TOKEN" http://localhost:8081/schemas/types```

#### Produce and Consume using Schema Registry

2. Use `kafka-avro-console-producer` to produce to a Kafka topic using Schema ID Validation:
The required client config file is already mounted to the containers.

```shell
docker exec -it schema-registry /bin/bash
```

```shell
 kafka-avro-console-producer \
  --bootstrap-server broker:9095 \
  --property bearer.auth.credentials.source=OAUTHBEARER \
  --property bearer.auth.issuer.endpoint.url=http://keycloak:8080/realms/cp/protocol/openid-connect/token \
  --property bearer.auth.client.id=client_app1 \
  --property bearer.auth.client.secret=client_app1_secret \
  --producer.config /etc/confluent/configs/client.properties \
  --topic test-topic \
  --property value.schema='{"type":"record","name":"Transaction","fields":[{"name":"id","type":"string"},{"name": "amount", "type": "double"}]}'

```

Here we are:

* Passing Schema Registry client OAuth configs using bearer prefix.
* Passing Kafka client related configs using `producer.config`.

The producer will wait at the command prompt for data to be supplied. You can provide JSON strings in separate lines

   ```json
   {"id": "1", "amount": 101}
   {"id": "2", "amount": 102}
   ```

3. Use `kafka-avro-console-consumer` to consume from the topic:

    ```console
    kafka-avro-console-consumer \
   --bootstrap-server broker:9095 \
   --property bearer.auth.credentials.source=OAUTHBEARER \
   --property bearer.auth.issuer.endpoint.url=http://keycloak:8080/realms/cp/protocol/openid-connect/token \
   --property bearer.auth.client.id=client_app1 \
   --property bearer.auth.client.secret=client_app1_secret \
   --topic test-topic \
   --from-beginning \
   --property print.key=true \
   --consumer.config /etc/confluent/configs/client.properties
    ```

### Connect RBAC using OAuth

All the endpoints are accessible using OAuth token.

<details open>
  <summary>Get Client App access token</summary> 

```shell
export CLIENT_APP_ACCESS_TOKEN=$(curl -s \
      -d "client_id=$CLIENT_APP_ID" \
      -d "client_secret=$CLIENT_APP_SECRET" \
      -d "grant_type=client_credentials" \
      $IDP_TOKEN_ENDPOINT | jq -r .access_token)
```
</details>

#### List available connectors:

```curl -H "Authorization: Bearer $CLIENT_APP_ACCESS_TOKEN" http://localhost:8083/connector-plugins/```

### Connector example using OAuth

1. Create datagen source Connector :

```shell
    curl --location 'localhost:8083/connectors' \
    --header 'Content-Type: application/json' \
      --header "Authorization: Bearer $CLIENT_APP_ACCESS_TOKEN" \
    --data '{
    "name": "datagen-source-connector",
    "config": {
        "connector.class": "io.confluent.kafka.connect.datagen.DatagenConnector",
        "tasks.max": "10",
        "kafka.topic": "test-topic-datagen",
        "quickstart": "users",
        "producer.override.sasl.oauthbearer.token.endpoint.url": "http://keycloak:8080/realms/cp/protocol/openid-connect/token",
        "producer.override.sasl.jaas.config": "org.apache.kafka.common.security.oauthbearer.OAuthBearerLoginModule required clientId=\"connect_client_app\" clientSecret=\"connect_client_app_secret\";"
      }
    }'
```

2. Login to Confluent Control Center to validate messages being produced to topic `test-topic-datagen`, use credentials `c3superuser` and `c3superuser` to login to C3 using SSO.
3. Alternatively, you can start a consumer in the broker container to see the messages getting produced
```shell
docker exec -it broker /bin/bash
```
```console
kafka-console-consumer \
--bootstrap-server broker:9095 \
--topic test-topic-datagen \
--consumer.config /etc/confluent/configs/client.properties
```
You should be able to see messages like: 
```
Struct{registertime=1491524107119,userid=User_3,regionid=Region_3,gender=MALE}
Struct{registertime=1492050173164,userid=User_6,regionid=Region_9,gender=MALE}
Struct{registertime=1508229967208,userid=User_8,regionid=Region_3,gender=MALE}
```

### ksqlDB RBAC using OAuth
All the endpoints are accessible using OAuth token

<details open>
  <summary>Get Client App access token</summary> 

```shell
export KSQL_ACCESS_TOKEN=$(curl -s \
   -d "client_id=ksql_client_app" \
   -d "client_secret=ksql_client_app_secret" \
   -d "grant_type=client_credentials" \
   http://keycloak:8080/realms/cp/protocol/openid-connect/token | jq -r .access_token)
```

</details>

#### Ensure token is valid and the ksqlDB service is running fine

```shell
curl --http1.1 \
     -X "GET" "http://ksqldb-server:8088/info" \
     -H "Accept: application/vnd.ksql.v1+json" \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer $KSQL_ACCESS_TOKEN" | jq
```

The output should include the `KsqlServerInfo` object, which should include the version, Kafka cluster ID, ksql service ID, and server status. For example:

```shell
{
  "KsqlServerInfo": {
    "version": "7.8.0-0",
    "kafkaClusterId": "vHCgQyIrRHG8Jv27qI2h3Q",
    "ksqlServiceId": "ksql-cluster",
    "serverStatus": "RUNNING"
  }
}
```

#### Execute ksqlDB commands

1. Creating a stream

```shell
curl --http1.1 \
     -X "POST" "http://ksqldb-server:8088/ksql" \
     -H "Accept: application/vnd.ksql.v1+json" \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer $KSQL_ACCESS_TOKEN" \
     -d $'{
  "ksql": "CREATE STREAM ABC (ORDER_ID BIGINT, PRODUCT_ID STRING, USER_ID STRING) WITH (KAFKA_TOPIC='\''orders'\'', KEY_FORMAT='\''KAFKA'\'', PARTITIONS=2, VALUE_FORMAT='\''JSON'\'');",
  "streamsProperties": {}
}' | jq
```

The JSON output should include the `ABC` stream

2. Executing `LIST STREAMS;`

```shell
curl --http1.1 \
     -X "POST" "http://ksqldb-server:8088/ksql" \
     -H "Accept: application/vnd.ksql.v1+json" \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer $KSQL_ACCESS_TOKEN" \
     -d $'{
  "ksql": "LIST STREAMS;",
  "streamsProperties": {}
}' | jq
```
The JSON output should list all the streams, the `KSQL_PROCESSING_LOG` and `ABC` streams in this case.

3. Executing a Query

```shell
curl --http1.1 \
  -X "POST" "http://ksqldb-server:8088/query" \
  -H "Accept: application/vnd.ksql.v1+json" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $KSQL_ACCESS_TOKEN" \
  -d $'{
    "ksql": "SELECT * FROM ABC;",
    "streamsProperties": {}
}' | jq
```

The JSON output should include the message `Query Completed`.


### SSO login in C3
You can use any user defined in the IDP to do interactive login to Confluent Control Center. Users part of group "g1" would get a permission of superuser.
In Keycloak you can use below configured users.  

```shell
c3user:c3user
c3superuser:c3superuser
```

`c3superuser` is a superuser who can assign role bindings to other users
`c3user` doesn't have any role bindings. This user can authenticate with IDP but will not have access to any cluster by default. The idea is to demo onboarding experience for a user or group.

Keycloak UI can be accessed at http://localhost:8080 (admin/admin)

### SSO login in CLI 

1. [Download](https://docs.confluent.io/confluent-cli/current/install.html) the CLI binary that supports CLI SSO login for Confluent Platform.
2. You can enable CLI SSO in the CLI context, or by simply exporting it 

```
export CONFLUENT_PLATFORM_SSO=true
```
You can use any user defined in IDP to do interactive login to Confluent Control Center. Users part of group "g1" would get a permission of superuser.
In Keycloak you can use below configured users.

```shell
c3user:c3user
c3superuser:c3superuser
```

You can try to login by specifying your MDS URL for CP cluster

```
$PATH_TO_CLI_BINARY/confluent login --url http://localhost:8091
```

If you need to logout completely for testing, you need to logout from the `cp` realm in keycloak by pointing your browser to `http://keycloak:8080/realms/cp/account/` and pressing `Sign Out`.

#### Firefox: Special settings for testing SSO via SOCKS proxy

Firefox needs some special settings in `about:config` if you run your demo on a separate machine (e.g. a virtual machine) and use a SOCKS proxy (e.g. via SSH dynamic port forwarding) to connect to the resources from your developer machine.
Setting the following values makes sure that the secure cookies used by Confluent Control Center and Keycloak can be used as intended:

* `network.proxy.allow_hijacking_localhost`: `true` (this allows connections to `localhost` to be be forwarded through the SOCKS proxy)
* `network.proxy.testing_localhost_is_secure_when_hijacked`: `true` (this makes sure firefox considers these forwarded connections `secure`, otherwise secure cookies will not be accepted for host such as `keycloak` even if these point to a local IP such as 127.0.0.1)

### Visualize metrics with Prometheus and Grafana

This setup includes Prometheus and Grafana to visualize metrics.
Grafana can be accessed via http://localhost:3000 using the `admin:admin` credentials.
From menu select "Authentication Dashboard"
JMX exporter configs are present [here](./metrics/exporter.yml), which can tweaked as per your liking.

### Troubleshooting

* At times, the broker takes more than expected time (60 seconds) to completely start. If it fails, please re-run the startup scrip. The steps are idempotent, and not going to do any disruptive change.
When done playing around shut down the containers

* Get the logs of a service

```shell 
broker logs -f <container name>
```

* Remove a single container. This will remove container and all logs. This will not delete the cached image

```shell
 docker rm $(docker stop broker)

```

* Remove all containers

```shell
 docker rm $(docker stop $(docker ps -aq))

```

### Bring Down the Cluster

You can use the provided shell script to bring down the cluster and delete the temporary resources (e.g. SSL certificates)

```shell
./stop.sh
```

You can also use `docker compose` directly (which leave the temp files in place):

```shell
 docker compose down
```

As a final step, if you are not going to use this example any time soon, you can remove the entries from `/etc/hosts`.
