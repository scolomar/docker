#!/bin/bash

set -x

pwd=$( dirname $( readlink -f $0 ) ) ;

test -z "$stack" && echo PLEASE DEFINE THE VALUE FOR stack && exit 1 ;

source $pwd/../common/functions.sh

command=' cd \&\& git clone https://github.com/secobau/docker.git ' ;
targets=" InstanceManager1 " ;
for target in $targets ; do
 send_command "$command" "$target" "$stack" ;
done ;

command=' cd \&\& sudo docker stack deploy -c docker/Swarm/AWS/app/php.yml php ' ;
targets=" InstanceManager1 " ;
for target in $targets ; do
 send_command "$command" "$target" "$stack" ;
done ;

command=' cd \&\& sudo docker stack deploy -c docker/Swarm/AWS/app/dockercoins.yml dockercoins ' ;
targets=" InstanceManager1 " ;
for target in $targets ; do
 send_command "$command" "$target" "$stack" ;
done ;
