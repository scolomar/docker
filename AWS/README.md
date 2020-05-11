This project will deploy in AWS a production-grade highly available and secure infrastructure consisting of private and public subnets, NAT gateways, security groups and application load balancers in order to ensure the isolation and resilience of the different components.

Before creating the infrastructure you will need a Hosted Zone in AWS Route53:

```bash

# TO LIST THE EXISTING HOSTED ZONES
aws route53 list-hosted-zones --output text 		;


```

In case you want to use HTTPS then you will also need a previously provisioned AWS Certificate:

```bash

# TO LIST THE EXISTING CERTIFICATES IN CASE YOU NEED HTTPS
aws acm list-certificates --output text 		;


```

The template will create 6 EC2 machines spread on 3 different Availability Zones with Docker-CE installed, 3 Private and Public Subnets, 3 NAT Gateways, 3 Security Groups, 3 Application Load Balancers and the necessary Routes, Roles and attachments to ensure the isolation of the EC2 machines and the security and resilience of the whole infrastructure.

The reason to have 3 Application Load Balancers is to make it available for 3 different internet service applications. The access from internet to the applications will be through the ALB onto the standard ports (HTTP/HTTPS).

The EC2 machines do not have any open port accessible from outside.

We will use AWS Systems Manager to connect and maintain the EC2 machines without the need of any bastion or breaking the isolation.

Here follow the links to the CloudFormation templates that define the infrastructure (you can choose to use HTTP, HTTPS or a mix of both):
* https://github.com/secobau/docker/tree/master/AWS/install/AMI/CloudFormation

In order to deploy the infrastructure in AWS you can use a Cloud9 instance running the following commands:

```bash

#export debug=false									;
export debug=true									;
export stack=mystack									;

caps=CAPABILITY_IAM									;
template=https://docker-aws.s3.ap-south-1.amazonaws.com/cloudformation-https.yaml	;

aws cloudformation create-stack								\
 	--stack-name									\
 		$stack									\
 	--template-url									\
 		$template								\
 	--capabilities									\
 		$caps									\
 											;


```

You might need the following documentation if you want to connect to the machines via SSH (but it is not necessary in principle):
* https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-getting-started-enable-ssh-connections.html
* https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html#install-plugin-linux

Once you have created a cluster of machines with Docker installed then you need to choose an orchestrator. Please follow the links below to set up the orchestrator of your choice: 
* Kubernetes: https://github.com/secobau/docker/tree/master/AWS/install/Kubernetes
* Swarm: https://github.com/secobau/docker/tree/master/AWS/install/Swarm
