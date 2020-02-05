#!/bin/bash

set -x

pwd=$( dirname $( readlink -f $0 ) ) ;

test -z "$stack" && echo PLEASE DEFINE THE VALUE FOR stack && exit 1 ;

source $pwd/../common/functions.sh

command="git clone https://github.com/secobau/ucp.git && sudo docker stack deploy -c ucp/aws/php.yml php && sudo docker stack deploy -c ucp/aws/dockercoins.yml dockercoins" ;
targets=" InstanceManager1 " ;
for target in $targets ; do
 send_list_command "$command" "$target" "$stack" ;
done ;
