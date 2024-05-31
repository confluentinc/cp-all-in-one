# OAuth in Kafka and Metadata Service (RBAC Server)

## Overview

OAuth 2.0 is an open standard to obtain limited access to an account without
exposing user credentials. Example OAuth 2.0 providers include [Keycloak](https://www.keycloak.org/) and [Okta](https://www.okta.com/).
This Docker Compose setup provides a container-based experience for getting started with Confluent
Platform's OAuth support.
This creates a CP setup (without Ksql) operating seamlessly *
*without** LDAP.

## Getting Started

**_NOTE:_**

If you are running the example here on your laptop, you should add the services in local dns.
```shell
sudo vi /etc/hsots
``` 
Add below lines at the end of the file
```shell
127.0.0.1       keycloak
127.0.0.1       broker
127.0.0.1       schema-registry
127.0.0.1       connect
127.0.0.1       contorl-center
```
Save the file and close it.


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


   
## Produce and Consume to Kafka using OAuth from Broker

   ```bash
   docker exec -it broker /bin/bash
   
   kafka-console-producer \
     --bootstrap-server broker:9095 \
     --topic test \
     --producer.config /etc/confluent/configs/client_app1.properties
   
   kafka-console-consumer \
     --bootstrap-server broker:9095 \
     --topic test \
     --consumer.config /etc/confluent/configs/client_app1.properties
   ```

## Schema Registry RBAC using OAuth

All of the endpoints are accessible using only OAuth token.

List available schemas on the cluster: The `$SCHEMA_REGISTRY_ACCESS_TOKEN` would be available in the current shell. If It's not available or is expired please look into to helper/functions.sh to get token retrieval command  

```curl -H "Authorization: Bearer $SCHEMA_REGISTRY_ACCESS_TOKEN" http://localhost:8081/schemas/types```

### Produce and Consume using schema registry

1. Grant access to schema registry user to the resources needed for producing and consuming from kafka.
  
   For example, granting access to client app `client_app1` over subject `test_topic` , topic `test_topic` of Kafka cluster `vHCgQyIrRHG8Jv27qI2h3Q` on schema registry `schema-registry`:
    
2. Use kafka-avro-console-producer to produce to a kafka topic using schema validation:

    ```shell
    docker exec -it schema-registry /bin/bash 
    kafka-avro-console-producer --bootstrap-server broker:9095 --property bearer.auth.credentials.source=OAUTHBEARER --property bearer.auth.issuer.endpoint.url=http://keycloak:8080/realms/cp/protocol/openid-connect/token --property bearer.auth.client.id=client_app1 --property bearer.auth.client.secret=client_app1_secret  --producer.config /etc/confluent/configs/client_app1.properties --topic test_topic --property value.schema='{"type":"record","name":"Transaction","fields":[{"name":"id","type":"string"},{"name": "amount", "type": "double"}]}'
    ```
    Where we are:-
    - Passing schema registry client OAuth configs using bearer prefix.
    - Passing kafka client related configs using producer.config.
    
    The producer will wait at the command prompt for data to be supplied. You can provide json strings in separate lines
    
    ```
    {"id": "1", "amount": 101}
    {"id": "2", "amount": 102}
    ```

3. Use kafka-avro-console-consumer to consume from the topic:

    ```shell
    kafka-avro-console-consumer --bootstrap-server broker:9095 --property bearer.auth.credentials.source=OAUTHBEARER --property bearer.auth.issuer.endpoint.url=http://keycloak:8080/realms/cp/protocol/openid-connect/token --property bearer.auth.client.id=client_app1 --property bearer.auth.client.secret=client_app1_secret   --topic test_topic --from-beginning --property print.key=true --consumer.config /etc/confluent/configs/client_app1.properties
    ```


## Connect RBAC using OAuth

All of the endpoints are accessible using only OAuth token.

List available connectors:

```curl -H "Authorization: Bearer $CONNECT_ACCESS_TOKEN" http://localhost:8083/connector-plugins/```

### Connector example using OAuth

1. Create datagen source Connector :
   Login to connect  
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


