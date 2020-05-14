#!/bin/bash
#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
export debug								;
export stack								;
#########################################################################
set +x && test "$debug" = true && set -x				;
#########################################################################
test -z "$stack" && echo PLEASE DEFINE THE VALUE FOR stack && exit 1 	;
#########################################################################
pwd=$( dirname $( readlink -f $0 ) ) 					;
source $pwd/../../common/functions.sh					;
#########################################################################
command=" sudo docker swarm init | grep token --max-count 1 " 		;
targets=" InstanceManager1 " 						;
for target in $targets 							;
do									\
  echo "Waiting for $target to complete ..."				;
  output="$(								\
    send_list_command "$command" "$target" "$stack"			\
  )"									;
  echo $output								;
done 									;
token_worker=" $output "						;
#########################################################################
command=" sudo docker swarm join-token manager | grep token " 		;
targets=" InstanceManager1 " 						;
for target in $targets 							;
do									\
  echo "Waiting for $target to complete ..."				;
  output="$(								\
    send_list_command "$command" "$target" "$stack"			\
  )"									;
  echo $output								;
done 									;
token_manager=" $output "						;
#########################################################################
command=" sudo $token_manager " 					;
targets=" InstanceManager2 InstanceManager3 " 				;
for target in $targets 							;
do 									\
  echo "Waiting for $target to complete ..."				;
  output="$(								\
    send_list_command "$command" "$target" "$stack"			\
  )"									;
  echo $output								;
done									;
#########################################################################
command=" sudo $token_worker " 						;
targets=" InstanceWorker1 InstanceWorker2 InstanceWorker3 " 		;
for target in $targets 							;
do 									\
  echo "Waiting for $target to complete ..."				;
  output="$(								\
    send_list_command "$command" "$target" "$stack"			\
  )"									;
  echo $output								;
done 									;
#########################################################################
