#!/bin/bash

#set -x

pwd=$( dirname $( readlink -f $0 ) ) ;

test -z "$stack" && echo PLEASE DEFINE THE VALUE FOR stack && exit 1 ;

source $pwd/../../common/functions.sh

command=" \
 sudo yum update -y \
 && sudo amazon-linux-extras install docker -y \
 && sudo systemctl enable docker \
 && sudo systemctl start docker \
 && sudo docker swarm init \
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
