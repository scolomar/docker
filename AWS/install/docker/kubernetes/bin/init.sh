#!/bin/bash -x
#	./install/docker/kubernetes/bin/init.sh
#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
set +x && test "$debug" = true && set -x				;
#########################################################################
test -n "$AWS"			|| exit 100				;
test -n "$debug"		|| exit 100				;
test -n "$domain"		|| exit 100				;
test -n "$HostedZoneName"	|| exit 100				;
test -n "$stack"		|| exit 100				;
#########################################################################
export=" 								\
  export debug=$debug 							\
"									;
log=/root/kubernetes-install.log                              		;
path=$AWS/install/docker/kubernetes/bin					;
sleep=10								;
#########################################################################
export=" 								\
  $export								\
  && 									\
  export AWS=$AWS							\
  && 									\
  export domain=$domain							\
"									;
file=kube-install.sh							;
targets="								\
	InstanceManager1						\
	InstanceManager2						\
	InstanceManager3						\
	InstanceWorker1							\
	InstanceWorker2							\
	InstanceWorker3							\
"									;
send_remote_file $domain "$export" $file $path $sleep $stack "$targets"	;
#########################################################################
export=" 								\
  $export								\
  && 									\
  export HostedZoneName=$HostedZoneName					\
  && 									\
  export log=$log							\
"									;
file=leader.sh								;
targets="								\
	InstanceManager1						\
"									;
send_remote_file $domain "$export" $file $path $sleep $stack "$targets"	;
#########################################################################
file=kube-wait.sh							;
send_remote_file $domain "$export" $file $path $sleep $stack "$targets"	;
#########################################################################
command="								\
	grep --max-count 1						\
		certificate-key						\
		$log							\
"									;
token_certificate=$(							\
  encode_string "							\
    $(									\
      send_wait_targets "$command" $sleep $stack "$targets"		\
    )									\
  "									;	
)									;
#########################################################################
command="								\
	grep --max-count 1						\
		discovery-token-ca-cert-hash				\
		$log							\
"									;
token_discovery=$(							\
  encode_string "							\
    $(									\
      send_wait_targets "$command" $sleep $stack "$targets"		\
    )									\
  "									;	
)									;
#########################################################################
command="								\
	grep --max-count 1						\
		kubeadm.*join						\
		$log							\
"									;
token_token=$(								\
  encode_string "							\
    $(									\
      send_wait_targets "$command" $sleep $stack "$targets"		\
    )									\
  "									;	
)									;
#########################################################################
export=" 								\
  $export								\
  &&									\
  export token_certificate=$token_certificate				\
  &&									\
  export token_discovery=$token_discovery				\
  &&									\
  export token_token=$token_token					\
"									;
file=manager.sh								;
targets="								\
	InstanceManager2						\
	InstanceManager3						\
"									;
send_remote_file $domain "$export" $file $path $sleep $stack "$targets"	;
#########################################################################
unset token_certificate							;
#########################################################################
export=" 								\
  $export								\
"									;
file=worker.sh								;
targets="								\
	InstanceWorker1							\
	InstanceWorker2							\
	InstanceWorker3							\
"									;
send_remote_file $domain "$export" $file $path $sleep $stack "$targets"	;
#########################################################################
