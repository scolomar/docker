Run the following commands to deploy a Kubernetes cluster consisting of three managers and three workers spread on three different Availability Zones:

```BASH

# SET THE VARIABLE NAME OF THE STACK CREATED IN CLOUDFORMATION
stack=mystack	 						;

# OTHER VARIABLES
raw=raw.githubusercontent.com					;
folder=secobau/docker/master/AWS/install/Kubernetes		;
file=cluster.sh							;

# TO CREATE THE CLUSTER
export stack=$stack                                    		\
  && curl -O https://$raw/$folder/$file				\
  && chmod +x $file						\
  && nohup ./$file &						\
  && rm --force $file 						\
  								;


```

Now you are ready to deploy your application.
