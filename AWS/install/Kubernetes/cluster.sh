#!/bin/bash -x
#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
set +x && test "$debug" = true && set -x				;
#########################################################################
test -n "$debug"		|| exit 100				;
test -n "$stack"		|| exit 100				;
test -n "$HostedZoneName"	|| exit 100				;
#########################################################################
domain=raw.githubusercontent.com                                        ;
export=" 								\
  export debug=$debug 							\
"									;
log=/etc/kubernetes/kubernetes-install.log                              ;
path=secobau/docker/master/AWS/install/Kubernetes			;
#########################################################################
file=kube-install.sh							;
targets="								\
	InstanceManager1						\
	InstanceManager2						\
	InstanceManager3						\
	InstanceWorker1							\
	InstanceWorker2							\
	InstanceWorker3							\
"									;
send_remote_file $domain "$export" $file $path $stack "$targets"	;
#########################################################################
export=" 								\
  $export								\
  && 									\
  export log=$log							\
"									;
file=leader.sh								;
targets="								\
	InstanceManager1						\
"									;
send_remote_file $domain "$export" $file $path $stack "$targets"	;
#########################################################################
file=kube-wait.sh							;
send_remote_file $domain "$export" $file $path $stack "$targets"	;
#########################################################################
command="								\
	grep --max-count 1						\
		certificate-key						\
		$log							\
"									;
output="								\
  $(									\
    send_wait_targets "$command" $stack "$targets"			\
  )									\
"									;	
token_certificate=$(							\
  encode_string "$output"						\
)									;
#########################################################################
command="								\
	grep --max-count 1						\
		discovery-token-ca-cert-hash				\
		$log							\
"									;
output="								\
  $(									\
    send_wait_targets "$command" $stack "$targets"			\
  )									\
"									;	
token_discovery=$(							\
  encode_string "$output"						\
)									;
#########################################################################
command="								\
	grep --max-count 1						\
		kubeadm.*join						\
		$log							\
"									;
output="								\
  $(									\
    send_wait_targets "$command" $stack "$targets"			\
  )									\
"									;	
token_token=$(								\
  encode_string "$output"						\
)									;
#########################################################################
export=" 								\
  $export								\
  && 									\
  export HostedZoneName=$HostedZoneName					\
  &&									\
  export token_discovery=$token_discovery				\
  &&									\
  export token_token=$token_token					\
"									;
file=worker.sh								;
targets="								\
	InstanceWorker1							\
	InstanceWorker2							\
	InstanceWorker3							\
"									;
send_remote_file $domain "$export" $file $path $stack "$targets"	;
#########################################################################
export=" 								\
  $export								\
  &&									\
  export token_certificate=$token_certificate				\
"									;
file=manager.sh								;
targets="								\
	InstanceManager2						\
	InstanceManager3						\
"									;
send_remote_file $domain "$export" $file $path $stack "$targets"	;
#########################################################################
