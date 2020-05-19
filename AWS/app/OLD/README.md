Once you have setup 

The proxy service is deployed in AWS on a production-grade highly available and secure infrastructure consisting of private and public subnets, NAT gateways, security groups and application load balancers in order to ensure the isolation and resilience of the different components.

You can set up your infrastructure in AWS running the following commands from a terminal in a Cloud9 environment with enough privileges.
You may also configure the variables so as to customize the setup:

```BASH 

#########################################################################
debug=false                                                     	;
debug=true                                                     		;
deploy=latest                                                   	;
deploy=release                                                   	;
HostedZoneName=example.com                                  	 	;
HostedZoneName=sebastian-colomar.com                                   	;
# Identifier is the ID of the certificate in case you are using HTTPS	#
Identifier=c3f3310b-f4ed-4874-8849-bd5c2cfe001f                         ;
mode=Kubernetes                                                       	;
mode=Swarm                                                       	;
RecordSetName1=service-1                                   		;
RecordSetName2=service-2                                   		;
RecordSetName3=service-3                                   		;
stack=$mode                                                     	;
#########################################################################
export debug								;
export deploy								;
export HostedZoneName							;
export Identifier							;
export mode								;
export RecordSetName1							;
export RecordSetName2							;
export RecordSetName3							;
export stack								;
#########################################################################
domain=raw.githubusercontent.com					;
path=secobau/proxy2aws/master/Shell					;
file=init.sh								;
date=$( date +%F_%H%M )							;
mkdir $date								;
cd $date								;
curl --remote-name https://$domain/$path/$file				;
chmod +x ./$file							;
nohup ./$file								&
#########################################################################


```

