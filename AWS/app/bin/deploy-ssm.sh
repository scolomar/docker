#!/bin/bash -x
#	./app/bin/deploy-ssm.sh
#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
set +x && test "$debug" = true && set -x 				;
#########################################################################
test -n "$apps"		|| exit 100					;
test -n "$branch"	|| exit 100					;
test -n "$debug"	|| exit 100					;
test -n "$deploy"	|| exit 100					;
test -n "$deploy_file"	|| exit 100					;
test -n "$deploy_path"	|| exit 100					;
test -n "$domain"	|| exit 100					;
test -n "$mode"		|| exit 100					;
test -n "$repository"	|| exit 100					;
test -n "$stack"	|| exit 100					;
test -n "$username"	|| exit 100					;
#########################################################################
apps=$(									\
  encode_string "$apps"							\
)									;
export=" 								\
  export debug=$debug 							\
"									;
file=$deploy_file							;
path=$deploy_path							;
targets=" 								\
  InstanceManager1 							\
"			 						;
#########################################################################
sleep=10								;
#########################################################################
export=" 								\
  $export 								\
  &&									\
  export apps=$apps							\
  &&									\
  export branch=$branch							\
  &&									\
  export deploy=$deploy							\
  &&									\
  export domain=$domain							\
  &&									\
  export mode=$mode							\
  &&									\
  export repository=$repository						\
  &&									\
  export username=$username						\
"									;
send_remote_file $domain "$export" $file $path $sleep $stack "$targets" ;
#########################################################################
