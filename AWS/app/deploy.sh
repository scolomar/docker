#!/bin/bash

set -x

pwd=$( dirname $( readlink -f $0 ) ) ;

test -z "$stack" && echo PLEASE DEFINE THE VALUE FOR stack && exit 1 ;

source $pwd/../common/functions.sh

command=" git clone https://github.com/secobau/docker.git docker-secobau " ;
targets=" InstanceManager1 " ;
for target in $targets ; do
 send_command "$command" "$target" "$stack" ;
done ;

command=" sudo docker stack deploy --compose-file docker-secobau/Swarm/AWS/app/php.yml php " ;
targets=" InstanceManager1 " ;
for target in $targets ; do
 send_command "$command" "$target" "$stack" ;
done ;

command=" sudo docker stack deploy --compose-file docker-secobau/Swarm/AWS/app/dockercoins.yml dockercoins " ;
targets=" InstanceManager1 " ;
for target in $targets ; do
 send_command "$command" "$target" "$stack" ;
done ;

command=" sudo rm --recursive --force docker-secobau " ;
targets=" InstanceManager1 " ;
for target in $targets ; do
 send_command "$command" "$target" "$stack" ;
done ;
