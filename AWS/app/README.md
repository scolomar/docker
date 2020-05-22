This project will allow you to deploy a containerized application in AWS on a production-grade highly available and secure infrastructure consisting of private and public subnets, NAT gateways, security groups and application load balancers in order to ensure the isolation and resilience of the different components.

The following script will deploy your application in a previously created cluster. You need to run the following commands from a terminal in a Cloud9 environment with enough privileges.
You may also configure the variables so as to customize the setup:

```BASH 

#########################################################################
apps=" app1.yml app2.yml app3.yml "                                     ;
apps=" aws2cloud.yaml aws2prem.yaml "					;
debug=false                                                     	;
debug=true                                                     		;
deploy=latest                                                   	;
deploy=release                                                   	;
docker_branch=master							;
mode=kubernetes                                                       	;
mode=swarm                                                       	;
repository=myproject							;
repository=proxy2aws							;
stack=mystack                                                     	;
stack=proxy2aws                                                     	;
username=johndoe							;
username=secobau							;
#########################################################################
export apps								;
export AWS=secobau/docker/$docker_branch/AWS				;
export debug								;
export deploy								;
export domain=raw.githubusercontent.com					;
export mode								;
export repository							;
export stack								;
export username								;
#########################################################################
path=$AWS/app/bin							;
file=init.sh								;
date=$( date +%F_%H%M )							;
mkdir $date								;
cd $date								;
curl --remote-name https://$domain/$path/$file				;
chmod +x ./$file							;
nohup ./$file								&
#########################################################################


```


