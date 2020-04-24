#!/bin/bash

#set -x

pwd=$( dirname $( readlink -f $0 ) ) ;

test -z "$stack" && echo PLEASE DEFINE THE VALUE FOR stack && exit 1 ;

source $pwd/../../common/functions.sh

######################################
ip=$( ip route | awk /default/'{ print $9 }' ) \
&& echo $ip k8smaster | sudo tee -a /etc/hosts
sudo kubeadm init --control-plane-endpoint=k8smaster --pod-network-cidr=192.168.0.0/16 \
  --ignore-preflight-errors=all | tee --append kubernetes.out

LOAD_BALANCER_DNS=kube-apiserver.sebastian-colomar.com
LOAD_BALANCER_PORT=6443
nc -w10 -v $LOAD_BALANCER_DNS $LOAD_BALANCER_PORT
sudo kubeadm --v=5 init --control-plane-endpoint "$LOAD_BALANCER_DNS:$LOAD_BALANCER_PORT" \
  --pod-network-cidr=192.168.0.0/16 --ignore-preflight-errors=all --upload-certs 
#########################################


command=" \
  echo deb http://apt.kubernetes.io/ kubernetes-xenial main \
    | sudo tee -a /etc/apt/sources.list.d/kubernetes.list \
  && curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg \
    | sudo apt-key add - \
  && sudo apt-get update \
  && sudo apt-get install -y docker.io \
  && sudo systemctl enable docker \
  && sudo apt-get install -y kubelet kubeadm kubectl \
  " ;
targets=" \
  InstanceManager1 \
  InstanceManager2 \
  InstanceManager3 \
  InstanceWorker1 \
  InstanceWorker2 \
  InstanceWorker3 \
  " ;
for target in $targets ; do
  send_command "$command" "$target" "$stack" ;
done ;

command=" sudo docker swarm init | grep token --max-count 1 " ;
targets=" InstanceManager1 " ;
for target in $targets ; do
  send_list_command "$command" "$target" "$stack" ;
done ;
token_worker=" $output ";

command=" sudo docker swarm join-token manager | grep token " ;
targets=" InstanceManager1 " ;
for target in $targets ; do
  send_list_command "$command" "$target" "$stack" ;
done ;
token_manager=" $output ";

command=" sudo $token_manager " ;
targets=" InstanceManager2 InstanceManager3 " ;
for target in $targets ; do
  send_command "$command" "$target" "$stack" ;
done ;

command=" sudo $token_worker " ;
targets=" InstanceWorker1 InstanceWorker2 InstanceWorker3 " ;
for target in $targets ; do
  send_command "$command" "$target" "$stack" ;
done ;
