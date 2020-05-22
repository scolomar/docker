This project will allow you to deploy a production-grade highly available and secure infrastructure consisting of private and public subnets, NAT gateways, security groups and application load balancers in order to ensure the isolation and resilience of the different components.

The following script will first create the infrastructure in AWS. You need to run the following commands from a terminal in a Cloud9 environment with enough privileges.
You may also configure the variables so as to customize the setup:

```BASH 

#########################################################################
debug=false                                                     	;
debug=true                                                     		;
docker_branch=v3.1							;
HostedZoneName=example.com                                  	 	;
HostedZoneName=sebastian-colomar.com                                   	;
# Identifier is the ID of the certificate in case you are using HTTPS	#
Identifier=c3f3310b-f4ed-4874-8849-bd5c2cfe001f                         ;
KeyName=mySSHpublicKey							;
KeyName=proxy2aws							;
mode=kubernetes                                                       	;
RecordSetName1=service-1                                   		;
RecordSetName1=aws2cloud                                   		;
RecordSetName2=service-2                                   		;
RecordSetName2=aws2prem                                   		;
RecordSetName3=service-3                                   		;
stack=mystack                                                     	;
stack=proxy2aws                                                     	;
TypeManager=t3a.nano                                                    ;
TypeWorker=t3a.nano                                                     ;
#########################################################################
export AWS=secobau/docker/$docker_branch/AWS                            ;
export debug								;
export domain=raw.githubusercontent.com                                 ;
export HostedZoneName							;
export Identifier							;
export KeyName								;
export RecordSetName1							;
export RecordSetName2							;
export RecordSetName3							;
export stack								;
export TypeManager							;
export TypeWorker							;
#########################################################################
path=$AWS/install/AMI/bin						;
file=init.sh								;
date=$( date +%F_%H%M )							;
mkdir $date								;
cd $date								;
curl --remote-name https://$domain/$path/$file				;
chmod +x ./$file							;
nohup ./$file								&
#########################################################################


```


You can optionally remove the AWS infrastructure created in CloudFormation otherwise you might be charged for any created object:


```BASH


#########################################################################
## TO REMOVE THE CLOUDFORMATION STACK                           	#
aws cloudformation delete-stack --stack-name $stack             	;
#########################################################################


```


