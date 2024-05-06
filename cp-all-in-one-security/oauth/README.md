# OAuth in Kafka and Metadata Service (RBAC Server)

## Overview

OAuth 2.0 is an open standard to obtain limited access to an account without
exposing user credentials. Example OAuth 2.0 providers include [Keycloak](https://www.keycloak.org/) and [Okta](https://www.okta.com/).
This Docker Compose setup provides a container-based experience for getting started with Confluent
Platform's OAuth support.
This creates a CP setup (without Ksql) operating seamlessly *
*without** LDAP.

## Getting Started

To initialise the environment use the provided start script, execute the following command:

```bash
./start.sh
```

This will:

1. Start a Keycloak server on port 8080. This acts as the OAuth identity provider.
2. Run Confluent Server with Role-based access control (RBAC).
3. Create a new listener `EXTERNAL` for SASL/OAuthBearer in Confluent Server.
4. Configure Confluent Server to connect to local Keycloak identity provider.
5. Configure Schema registry, Connect and Control Center to work on OAuth.
6. Datagen source connector plugin is added in Connect.

Add tokens to environment variable. these will be valid for 1 hour, post that these commands need to be run again. :-

```shell
export SUPER_USER_ACCESS_TOKEN=$(curl -s \
  -d "client_id=superuser_client_app" \
  -d "client_secret=superuser_client_app_secret" \
  -d "grant_type=client_credentials" \
  http://keycloak:8080/realms/cp/protocol/openid-connect/token | jq -r .access_token)
```

```shell
export SCHEMA_REGISTRY_ACCESS_TOKEN=$(curl -s \
  -d "client_id=sr_client_app" \
  -d "client_secret=sr_client_app_secret" \
  -d "grant_type=client_credentials" \
  http://keycloak:8080/realms/cp/protocol/openid-connect/token | jq -r .access_token)
```

```shell
export CONNECT_ACCESS_TOKEN=$(curl -s \
  -d "client_id=connect_client_app" \
  -d "client_secret=connect_client_app_secret" \
  -d "grant_type=client_credentials" \
  http://keycloak:8080/realms/cp/protocol/openid-connect/token | jq -r .access_token)
```


**_NOTE:_**
Add keycloak, broker, schema-registry pointing to localhost to local dns resolver.

## RBAC using OAuth

1. Get the Kafka cluster ID from the `CLUSTER_ID` environment variable defined in the `docker-compose.yml` file, or via the following GET REST request: http://localhost:8091/v1/metadata/id

2. Get an access token from Keycloak passing the client credentials of super user client app. The client credentials are base64 encoded `client_id:client_secret` and is configured in `keycloak-realm-export.json`.

    ```shell
    curl -X POST \
       -H "Authorization: Basic c3VwZXJ1c2VyX2NsaWVudF9hcHA6c3VwZXJ1c2VyX2NsaWVudF9hcHBfc2VjcmV0" \
       -H "Content-Type: application/x-www-form-urlencoded" \
       -d "grant_type=client_credentials" \
       http://keycloak:8080/realms/cp/protocol/openid-connect/token
    ```

3. Grant access to other client apps or users by assigning roles to them.
   For example, granting access to client app `client_app1` over topic `test` of Kafka cluster `vHCgQyIrRHG8Jv27qI2h3Q`, replace `<access-token>` with token obtained above:

    ```shell
    curl -v \
      -H "Authorization: Bearer $SUPER_USER_ACCESS_TOKEN" \
      -H "Content-Type: application/json" \
      -H "Accept: application/json" \
      -X POST 'http://localhost:8091/security/1.0/principals/User:client_app1/roles/ResourceOwner/bindings' \
      -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"test", "patternType":"LITERAL"}]}'
    ```

   Also assign access to a consumer group.
   ```shell
    curl -v \
      -H "Authorization: Bearer $SUPER_USER_ACCESS_TOKEN" \
      -H "Content-Type: application/json" \
      -H "Accept: application/json" \
      -X POST 'http://localhost:8091/security/1.0/principals/User:client_app1/roles/ResourceOwner/bindings' \
      -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Group", "name":"console-consumer-group", "patternType":"LITERAL"}]}'
    ```

## Produce and Consume to Kafka using OAuth

1. Create a client configuration file `client.properties` that uses OAuth:

    ```properties
    sasl.mechanism=OAUTHBEARER
    security.protocol=SASL_PLAINTEXT
    group.id=console-consumer-group
    sasl.login.callback.handler.class=org.apache.kafka.common.security.oauthbearer.secured.OAuthBearerLoginCallbackHandler
    sasl.oauthbearer.token.endpoint.url=http://localhost:8080/realms/cp/protocol/openid-connect/token
    sasl.jaas.config=org.apache.kafka.common.security.oauthbearer.OAuthBearerLoginModule required \
      clientId="client_app1" \
      clientSecret="client_app1_secret";
    ```

2. Usage for above config in kafka console producer :
   ```bash
   ./bin/kafka-console-producer \
     --bootstrap-server localhost:9095 \
     --topic test \
     --producer.config client.properties
   ```
   > Note: The above command will fail with error ```org.apache.kafka.common.errors.TopicAuthorizationException: Not authorized to access topics: [test]``` if you have not granted access to the client app `client_app1` over topic `test` as done in previous section.

3. Usage for above config in kafka console consumer:
   ```shell
   ./bin/kafka-console-consumer \
     --bootstrap-server localhost:9095 \
     --topic test \
     --consumer.config client.properties
   ```

## Schema Registry RBAC using OAuth

All of the endpoints are accessible using only OAuth token.

List available schemas on the cluster:

```curl -H "Authorization: Bearer $SCHEMA_REGISTRY_ACCESS_TOKEN" http://localhost:8081/schemas/types```

### Produce and Consume using schema registry

1. Grant access to schema registry user to the resources needed for producing and consuming from kafka.
  
   For example, granting access to client app `client_app1` over subject `test_topic` , topic `test_topic` of Kafka cluster `vHCgQyIrRHG8Jv27qI2h3Q` on schema registry `schema-registry`:
    
    ```shell
    curl -v \
      -H "Authorization: Bearer $SUPER_USER_ACCESS_TOKEN" \
      -H "Content-Type: application/json" \
      -H "Accept: application/json" \
      -X POST 'http://localhost:8091/security/1.0/principals/User:client_app1/roles/ResourceOwner/bindings' \
      -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q", "schema-registry-cluster":"schema-registry"}}, "resourcePatterns":[{"resourceType":"Subject", "name":"test_topic", "patternType":"PREFIXED"}]}'
    ```

    ```shell
    curl -v \
      -H "Authorization: Bearer $SUPER_USER_ACCESS_TOKEN" \
      -H "Content-Type: application/json" \
      -H "Accept: application/json" \
      -X POST 'http://localhost:8091/security/1.0/principals/User:client_app1/roles/ResourceOwner/bindings' \
      -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"test_topic", "patternType":"PREFIXED"}]}'
    ```

   Also assign access to a consumer group.
   ```shell
    curl -v \
      -H "Authorization: Bearer $SUPER_USER_ACCESS_TOKEN" \
      -H "Content-Type: application/json" \
      -H "Accept: application/json" \
      -X POST 'http://localhost:8091/security/1.0/principals/User:client_app1/roles/ResourceOwner/bindings' \
      -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Group", "name":"console-consumer-group", "patternType":"LITERAL"}]}'

2. Use kafka-avro-console-producer to produce to a kafka topic using schema validation:

    ```shell 
    kafka-avro-console-producer --bootstrap-server localhost:9095 --property bearer.auth.credentials.source=OAUTHBEARER --property bearer.auth.issuer.endpoint.url=http://keycloak:8080/realms/cp/protocol/openid-connect/token --property bearer.auth.client.id=client_app1 --property bearer.auth.client.secret=client_app1_secret  --producer.config <client properties> --topic test_topic --property value.schema='{"type":"record","name":"Transaction","fields":[{"name":"id","type":"string"},{"name": "amount", "type": "double"}]}'
    ```

    Where we are:-
    - Passing schema registry client OAuth configs using bearer prefix.
    - Passing kafka client related configs using producer.config.


3. Use kafka-avro-console-consumer to consume from the topic:

    ```shell
    kafka-avro-console-consumer --bootstrap-server localhost:9095 --property bearer.auth.credentials.source=OAUTHBEARER --property bearer.auth.issuer.endpoint.url=http://keycloak:8080/realms/cp/protocol/openid-connect/token --property bearer.auth.client.id=client_app1 --property bearer.auth.client.secret=client_app1_secret   --topic test_topic --from-beginning --property print.key=true --consumer.config <client properties>
    ```


## Connect RBAC using OAuth

All of the endpoints are accessible using only OAuth token.

List available connectors:

```curl -H "Authorization: Bearer $CONNECT_ACCESS_TOKEN" http://localhost:8083/connector-plugins/```

### Connector example using OAuth

1. Create datagen source Connector :
    
    ```shell
    curl --location 'localhost:8083/connectors' \
    --header 'Content-Type: application/json' \
      --header "Authorization: Bearer $CONNECT_ACCESS_TOKEN" \
    --data '{
    "name": "datagen-source-connector",
    "config": {
        "connector.class": "io.confluent.kafka.connect.datagen.DatagenConnector",
        "tasks.max": "10",
        "kafka.topic": "test-topic",
        "quickstart": "users",
        "producer.override.sasl.oauthbearer.token.endpoint.url": "http://keycloak:8080/realms/cp/protocol/openid-connect/token",
        "producer.override.sasl.jaas.config": "org.apache.kafka.common.security.oauthbearer.OAuthBearerLoginModule required clientId=\"connect_client_app\" clientSecret=\"connect_client_app_secret\";"
      }
    }'
    ```

2. Login to Control center to validate messages being produced to topic `test_topic`, use credentials `c3user` and `c3user` to login to C3 using SSO. 


