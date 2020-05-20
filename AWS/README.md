This project will allow you to deploy a containerized application in AWS on a production-grade highly available and secure infrastructure consisting of private and public subnets, NAT gateways, security groups and application load balancers in order to ensure the isolation and resilience of the different components.

The following script will first create the infrastructure and then deploy your application. You need to run the following commands from a terminal in a Cloud9 environment with enough privileges.
You may also configure the variables so as to customize the setup:

```BASH 

#########################################################################
apps=" app1 app2 app3 "                                                 ;
apps=" aws2cloud aws2prem "						;
debug=false                                                     	;
debug=true                                                     		;
deploy=latest                                                   	;
deploy=release                                                   	;
HostedZoneName=example.com                                  	 	;
HostedZoneName=sebastian-colomar.com                                   	;
# Identifier is the ID of the certificate in case you are using HTTPS	#
Identifier=c3f3310b-f4ed-4874-8849-bd5c2cfe001f                         ;
TypeManager=t3a.nano                                                    ;
TypeWorker=t3a.nano                                                     ;
KeyName=mySSHpublicKey							;
KeyName=proxy2aws							;
mode=Kubernetes                                                       	;
mode=Swarm                                                       	;
RecordSetName1=service-1                                   		;
RecordSetName1=aws2cloud                                   		;
RecordSetName2=service-2                                   		;
RecordSetName2=aws2prem                                   		;
RecordSetName3=service-3                                   		;
repository=myproject							;
repository=proxy2aws							;
stack=mystack                                                     	;
stack=proxy2aws                                                     	;
username=johndoe							;
username=secobau							;
#########################################################################
export apps								;
export AWS=secobau/docker/master/AWS					;
export debug								;
export deploy								;
export domain=raw.githubusercontent.com					;
export HostedZoneName							;
export Identifier							;
export TypeManager							;
export TypeWorker							;
export KeyName								;
export mode								;
export RecordSetName1							;
export RecordSetName2							;
export RecordSetName3							;
export repository							;
export stack								;
export username								;
#########################################################################
path=$AWS								;
file=init.sh								;
date=$( date +%F_%H%M )							;
mkdir $date								;
cd $date								;
curl --remote-name https://$domain/$path/$file				;
chmod +x ./$file							;
nohup ./$file								&
#########################################################################


```

