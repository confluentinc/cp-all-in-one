![image](../images/confluent-logo-300-2.png)
  
# Documentation

Securing your Apache Kafka cluster can involve various security features.
For an example that shows security features in action, see [cp-demo](https://docs.confluent.io/platform/current/tutorials/cp-demo/docs/index.html?utm_source=github&utm_medium=demo&utm_campaign=ch.examples_type.community_content.cp-all-in-one).

## OAuth
[confluent-server-oauth](confluent-server-oauth/README.md) demonstrates how to configure OAuth in Confluent Server.
Right now, this example only supports confluent server (Kafka and MDS) and does not support components Confluent Control Center.

Other components such as Confluent Control Center, Connect, and Schema Registry still requires LDAP for authentication.
