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
export=" export debug=$debug "						;
log=/etc/kubernetes/kubernetes-install.log                              ;
#########################################################################
file=functions.sh                                                       ;
path=secobau/docker/master/AWS/common                                   ;
pwd=$PWD && mkdir --parents $path && cd $path                           ;
curl -O https://$domain/$path/$file                                     ;
source ./$file                                                          ;
cd $pwd && rm --recursive --force $path                                 ;
#########################################################################
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
exec_remote_file_targets $domain "$export" $file $path $stack "$targets";
#########################################################################
export=" $export							\
  && export log=$log							\
"									;
file=leader.sh								;
targets="								\
	InstanceManager1						\
"									;
exec_remote_file_targets $domain "$export" $file $path $stack "$targets";
#########################################################################
file=kube-wait.sh							;
targets="								\
	InstanceManager1						\
"									;
exec_remote_file_targets $domain "$export" $file $path $stack "$targets";
#########################################################################
command="								\
	grep								\
		--max-count						\
			1						\
		certificate-key						\
		$log							\
"									;
targets="InstanceManager1"						;
for target in $targets							;
do									\
	echo "Waiting for $target to complete ..."			;
	output="$(							\
		send_list_command "$command" "$stack" "$target"		\
	)"								\
									;
done									;
token_certificate=$(							\
	echo -n $output							\
	|								\
		sed 's/\\/ /'						\
		|							\
			base64						\
				--wrap				 	\
					0				\
)									;
#########################################################################
command="								\
	grep								\
		--max-count						\
			1						\
		discovery-token-ca-cert-hash				\
		$log							\
"									;
targets="InstanceManager1"						;
for target in $targets							;
do									\
	echo "Waiting for $target to complete ..."			;
	output="$(							\
		send_list_command "$command" "$stack" "$target"		\
	)"								\
									;
done									;
token_discovery=$(							\
	echo -n $output							\
	|								\
		sed 's/\\/ /'						\
		|							\
			base64						\
				--wrap				 	\
					0				\
)									;
#########################################################################
command="								\
	grep								\
		--max-count						\
			1						\
		kubeadm.*join						\
		$log							\
"									;
targets="InstanceManager1"						;
for target in $targets							;
do									\
	echo "Waiting for $target to complete ..."			;
	output="$(							\
		send_list_command "$command" "$stack" "$target"		\
	)"								\
									;
done									;
token_token=$(								\
	echo -n $output							\
	|								\
		sed 's/\\/ /'						\
		|							\
			base64						\
				--wrap				 	\
					0				\
)									;
#########################################################################
file=worker.sh								;
export=" $export							\
  &&									\
  export token_discovery=$token_discovery				\
  &&									\
  export token_token=$token_token					\
"									;
targets="								\
	InstanceWorker1							\
	InstanceWorker2							\
	InstanceWorker3							\
"									;
exec_remote_file_targets $domain "$export" $file $path $stack "$targets";
#########################################################################
export=" $export							\
  &&									\
  export token_certificate=$token_certificate				\
"									;
file=manager.sh								;
targets="								\
	InstanceManager2						\
	InstanceManager3						\
"									;
exec_remote_file_targets $domain "$export" $file $path $stack "$targets";
#########################################################################
