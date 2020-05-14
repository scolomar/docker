#!/bin/bash

set -x

pwd=$( dirname $( readlink -f $0 ) ) ;

test -z "$stack" && echo PLEASE DEFINE THE VALUE FOR stack && exit 1 ;

source $pwd/../common/functions.sh

command=' sudo docker stack rm php ' ;
targets=" InstanceManager1 " ;
for target in $targets ; do
 send_command "$command" "$stack" "$target" ;
done ;

command=' sudo docker stack rm dockercoins ' ;
targets=" InstanceManager1 " ;
for target in $targets ; do
 send_command "$command" "$stack" "$target" ;
done ;
