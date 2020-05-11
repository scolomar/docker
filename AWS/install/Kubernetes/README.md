Run the following commands to deploy a Kubernetes cluster consisting of three managers and three workers spread on three different Availability Zones:

```BASH

# SET THE VARIABLE NAME OF THE STACK CREATED IN CLOUDFORMATION
stack=mystack	 						;

# TO CREATE THE CLUSTER
rm -rf docker 							;
export stack=$stack                                    		\
  && git clone https://github.com/secobau/docker.git   		\
  && chmod +x docker/AWS/install/Kubernetes/cluster.sh 		\
  && ./docker/AWS/install/Kubernetes/cluster.sh        		\
  && rm -rf docker 						;


```

Now you are ready to deploy your application.
