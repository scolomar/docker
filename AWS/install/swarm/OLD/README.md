Run the following commands to deploy a Swarm cluster consisting of three managers and three workers spread on three different Availability Zones:

```BASH

# SET THE VARIABLE NAME OF THE STACK CREATED IN CLOUDFORMATION
#debug=true	 						;
#stack=docker	 						;

# TO CREATE THE CLUSTER
rm -rf docker 							;
export debug=$debug stack=$stack 				\
  && git clone https://github.com/secobau/docker.git   		\
  && chmod +x docker/AWS/install/Swarm/cluster.sh 		\
  && ./docker/AWS/install/Swarm/cluster.sh        		\
  && rm -rf docker 						;


```

Now you are ready to deploy your application.
