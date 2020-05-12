![image](images/confluent-logo-300-2.png)
  
* [Build Your Own](#build-your-own)
* [Additional Resources](#additional-resources)

# Build Your Own

We have several resources that launch Apache Kafka® and Confluent Platform with no pre-configured connectors, data sources, topics, schemas, etc.
This is useful if you want to build your own custom demo or test environment.
Using these as a foundation, you can add any connectors or applications.

* [cp-all-in-one](cp-all-in-one/README.md): This Docker Compose file launches all services in Confluent Platform, and runs them in containers in your local host.

<p align="center">
<a href="cp-all-in-one"><img src="images/cp-all-in-one.png" width="400"></a>
</p>

* [cp-all-in-one-community](cp-all-in-one-community/README.md): This Docker Compose file launches only the community services in Confluent Platform, and runs them in containers in your local host.

<p align="center">
<a href="cp-all-in-one-community"><img src="images/cp-all-in-one-community.png" width="400"></a>
</p>

* [cp-all-in-one-cloud](cp-all-in-one-cloud/README.md): Use this with your existing Confluent Cloud instance. This Docker Compose file launches all services in Confluent Platform (except for the Kafka brokers), runs them in containers in your local host, and automatically configures them to connect to Confluent Cloud.

<p align="center">
<a href="cp-all-in-one-cloud"><img src="images/cp-all-in-one-cloud.png" width="600"></a>
</p>



# Additional Resources

* [confluentinc/examples](https://github.com/confluentinc/examples): curated list of end-to-end demos that showcase Apache Kafka® event stream processing on the Confluent Platform, an event stream processing platform that enables you to process, organize, and manage massive amounts of streaming data across cloud, on-prem, and serverless deployments.

<p align="center">
<a href="http://www.youtube.com/watch?v=muQBd6gry0U" target="_blank"><img src="https://github.com/confluentinc/examples/blob/latest/images/examples-video-thumbnail.jpg" width="360" height="270" border="10" /></a>
</p>

* [cloud-stack](https://github.com/confluentinc/examples/blob/latest/ccloud/ccloud-stack/README.md): creates a stack of fully managed services in Confluent Cloud. It is a quick way to create fully managed components in Confluent Cloud, along with a service account, credentials, and ACLs, which you can then use for learning and building other demos.

<p align="center">
<a href="https://github.com/confluentinc/examples/blob/latest/ccloud/ccloud-stack/README.md"><img src="images/cloud-stack.png" width="400"></a>
</p>

* [Confluent CLI](https://docs.confluent.io/current/cli/index.html?utm_source=github&utm_medium=demo&utm_campaign=ch.cp-all-in-one_type.community_content.top): For local, non-Docker installs of Confluent Platform. Using this CLI, you can launch all services in Confluent Platform with just one command `confluent local start`, and they will all run on your local host.
* [Generate test data](https://www.confluent.io/blog/easy-ways-generate-test-data-kafka?utm_source=github&utm_medium=demo&utm_campaign=ch.cp-all-in-one_type.community_content.top): "Hello, World!" for launching Confluent Platform, plus different ways to generate more interesting test data for your topics
* [Documentation for Getting Started](https://docs.confluent.io/current/getting-started.html?utm_source=github&utm_medium=demo&utm_campaign=ch.cp-all-in-one_type.community_content.top)
