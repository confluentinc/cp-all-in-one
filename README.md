![image](images/confluent-logo-300-2.png)
  
* [Build Your Own](#build-your-own)
* [Additional Resources](#additional-resources)

# Build Your Own

We have several resources that launch Apache Kafka® and Confluent Platform with no pre-configured connectors, data sources, topics, schemas, etc.
This is useful if you want to build your own custom demo or test environment.
Using these as a foundation, you can add any connectors or applications.

* [cp-all-in-one](cp-all-in-one/README.md): This Docker Compose file launches all services in Confluent Platform, and runs them in containers in your local host.
* [cp-all-in-one-community](cp-all-in-one-community/README.md): This Docker Compose file launches only the community services in Confluent Platform, and runs them in containers in your local host.
* [cp-all-in-one-cloud](cp-all-in-one-cloud/README.md): Use this with your existing Confluent Cloud instance. This Docker Compose file launches all services in Confluent Platform (except for the Kafka brokers), runs them in containers in your local host, and automatically configures them to connect to Confluent Cloud.

# Additional Resources

* [confluentinc/examples](https://github.com/confluentinc/examples): curated list of end-to-end demos that showcase Apache Kafka® event stream processing on the Confluent Platform, an event stream processing platform that enables you to process, organize, and manage massive amounts of streaming data across cloud, on-prem, and serverless deployments.
* [Confluent CLI](https://docs.confluent.io/current/cli/index.html?utm_source=github&utm_medium=demo&utm_campaign=ch.cp-all-in-one_type.community_content.top): For local, non-Docker installs of Confluent Platform. Using this CLI, you can launch all services in Confluent Platform with just one command `confluent local start`, and they will all run on your local host.
* [Generate test data](https://www.confluent.io/blog/easy-ways-generate-test-data-kafka?utm_source=github&utm_medium=demo&utm_campaign=ch.cp-all-in-one_type.community_content.top): "Hello, World!" for launching Confluent Platform, plus different ways to generate more interesting test data for your topics
* [Documentation for Getting Started](https://docs.confluent.io/current/getting-started.html?utm_source=github&utm_medium=demo&utm_campaign=ch.cp-all-in-one_type.community_content.top)
