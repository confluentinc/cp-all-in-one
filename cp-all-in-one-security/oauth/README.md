# OAuth in Kafka and Metadata Service (RBAC Server)

## Overview

OAuth 2.0 is an open standard to obtain limited access to an account without
exposing user credentials. Example OAuth 2.0 providers include [Keycloak](https://www.keycloak.org/) and [Okta](https://www.okta.com/).
This Docker Compose setup provides a container-based experience for getting started with Confluent
Platform's OAuth support.
This creates a minimal CP setup (consisting only of the broker and MDS) operating seamlessly *
*without** LDAP.

## Getting Started

To run the Docker Compose setup, execute the following command:

```bash
docker compose up -d
```

This will:

1. Start a Keycloak server on port 8080. This acts as the OAuth identity provider.
2. Run Confluent Server with Role-based access control (RBAC).
3. Create a new listener `EXTERNAL` for SASL/OAuthBearer in Confluent Server.
4. Configure Confluent Server to connect to local Keycloak identity provider.

## RBAC using OAuth

1. Get the Kafka cluster ID from the `CLUSTER_ID` environment variable defined in the `docker-compose.yml` file, or via the following GET REST request: http://localhost:8091/v1/metadata/id

2. Get an access token from Keycloak passing the client credentials of super user client app. The client credentials are base64 encoded `client_id:client_secret` and is configured in `keycloak-realm-export.json`.

    ```shell
    curl -X POST \
       -H "Authorization: Basic c3VwZXJ1c2VyX2NsaWVudF9hcHA6c3VwZXJ1c2VyX2NsaWVudF9hcHBfc2VjcmV0" \
       -H "Content-Type: application/x-www-form-urlencoded" \
       -d "grant_type=client_credentials" \
       http://localhost:8080/realms/cp/protocol/openid-connect/token
    ```

3. Grant access to other client apps or users by assigning roles to them.
   For example, granting access to client app `client_app1` over topic `test` of Kafka cluster `vHCgQyIrRHG8Jv27qI2h3Q`, replace `<access-token>` with token obtained above:

    ```shell
    curl -v \
      -H "Authorization: Bearer <access-token>" \
      -H "Content-Type: application/json" \
      -H "Accept: application/json" \
      -X POST 'http://localhost:8091/security/1.0/principals/User:client_app1/roles/ResourceOwner/bindings' \
      -d '{"scope":{"clusters":{"kafka-cluster":"vHCgQyIrRHG8Jv27qI2h3Q"}}, "resourcePatterns":[{"resourceType":"Topic", "name":"test", "patternType":"LITERAL"}]}'
    ```

   Also assign access to a consumer group.
   ```shell
    curl -v \
      -H "Authorization: Bearer <access-token>" \
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
