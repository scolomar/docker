#!/bin/bash -x
#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
set +x && test "$debug" = true && set -x				;
#########################################################################
test -n "$debug"	|| exit 100					;
test -n "$stack"	|| exit 100					;
#########################################################################
service=docker								;
#########################################################################
targets=" InstanceManager1 " 						;
#########################################################################
output="								\
  $(									\
    service_wait_targets $service $stack "$targets"			\
  )									\
"									;	
echo $output
#########################################################################
command=" 								\
  sudo docker swarm init 2> /dev/null | grep token --max-count 1 	\
" 									;
output="								\
  $(									\
    send_wait_targets "$command" $stack "$targets"			\
  )									\
"									;	
token_worker="$output"							;
echo $output
#########################################################################
command=" 								\
  sudo docker swarm join-token manager 2> /dev/null | grep token 	\
" 									;
output="								\
  $(									\
    send_wait_targets "$command" $stack "$targets"			\
  )									\
"									;	
token_manager="$output"							;
echo $output
#########################################################################
targets=" InstanceManager2 InstanceManager3 " 				;
#########################################################################
output="								\
  $(									\
    service_wait_targets $service $stack "$targets"			\
  )									\
"									;	
echo $output
#########################################################################
command=" sudo $token_manager 2> /dev/null " 				;
output="								\
  $(									\
    send_wait_targets "$command" $stack "$targets"			\
  )									\
"									;	
echo $output
#########################################################################
targets=" InstanceWorker1 InstanceWorker2 InstanceWorker3 " 		;
#########################################################################
output="								\
  $(									\
    service_wait_targets $service $stack "$targets"			\
  )									\
"									;	
echo $output
#########################################################################
command=" sudo $token_worker 2> /dev/null " 				;
output="								\
  $(									\
    send_wait_targets "$command" $stack "$targets"			\
  )									\
"									;	
echo $output
#########################################################################
