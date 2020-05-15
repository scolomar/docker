#!/bin/bash -x
#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
set +x && test "$debug" = true && set -x				;
#########################################################################
export debug=$debug							;
export stack=$stack							;
#########################################################################
domain=raw.githubusercontent.com                                        ;
#########################################################################
path=secobau/docker/master/AWS/common                                   ;
file=functions.sh                                                       ;
pwd=$PWD && mkdir --parents $path && cd $path                           ;
curl -O https://$domain/$path/$file                                     ;
source ./$file                                                          ;
cd $PWD && rm --recursive --force $path                                 ;
#########################################################################
command=" sudo service docker status | grep running --quiet && echo OK ";
targets=" InstanceManager1 " 						;
for target in $targets 							;
do									\
  echo "Waiting for $target to complete ..."				;
  output="$(								\
    send_list_command "$command" "$stack" "$target"			\
  )"									;
  echo $output								;
done 									;
#########################################################################
command=" sudo docker swarm init | grep token --max-count 1 " 		;
targets=" InstanceManager1 " 						;
for target in $targets 							;
do									\
  echo "Waiting for $target to complete ..."				;
  output="$(								\
    send_list_command "$command" "$stack" "$target"			\
  )"									;
done 									;
token_worker=" $output "						;
#########################################################################
command=" sudo docker swarm join-token manager | grep token " 		;
targets=" InstanceManager1 " 						;
for target in $targets 							;
do									\
  echo "Waiting for $target to complete ..."				;
  output="$(								\
    send_list_command "$command" "$stack" "$target"			\
  )"									;
  echo $output								;
done 									;
token_manager=" $output "						;
#########################################################################
command=" sudo service docker status | grep running -q && echo OK "	;
targets=" InstanceManager2 InstanceManager3 " 				;
for target in $targets 							;
do									\
  echo "Waiting for $target to complete ..."				;
  output="$(								\
    send_list_command "$command" "$stack" "$target"			\
  )"									;
  echo $output								;
done 									;
#########################################################################
command=" sudo $token_manager " 					;
targets=" InstanceManager2 InstanceManager3 " 				;
for target in $targets 							;
do 									\
  echo "Waiting for $target to complete ..."				;
  output="$(								\
    send_list_command "$command" "$stack" "$target"			\
  )"									;
  echo $output								;
done									;
#########################################################################
command=" sudo service docker status | grep running -q && echo OK "	;
targets=" InstanceWorker1 InstanceWorker2 InstanceWorker3 " 		;
for target in $targets 							;
do									\
  echo "Waiting for $target to complete ..."				;
  output="$(								\
    send_list_command "$command" "$stack" "$target"			\
  )"									;
  echo $output								;
done 									;
#########################################################################
command=" sudo $token_worker " 						;
targets=" InstanceWorker1 InstanceWorker2 InstanceWorker3 " 		;
for target in $targets 							;
do 									\
  echo "Waiting for $target to complete ..."				;
  output="$(								\
    send_list_command "$command" "$stack" "$target"			\
  )"									;
  echo $output								;
done 									;
#########################################################################
