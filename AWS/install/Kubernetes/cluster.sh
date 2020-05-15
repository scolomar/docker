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
command="								\
	export debug=$debug						\
	&&								\
	curl -o /$file https://$domain/$path/$file			\
	&&								\
	chmod +x /$file							\
	&&								\
	/$file								\
		2>&1							\
	|								\
		sudo tee /$file.log					\
"									;
targets="								\
	InstanceManager1						\
	InstanceManager2						\
	InstanceManager3						\
	InstanceWorker1							\
	InstanceWorker2							\
	InstanceWorker3							\
"									;
for target in $targets							;
do									\
	send_command "$command" "$stack" "$target"			\
									;
done									;
#########################################################################
file=leader.sh								;
command="								\
	export debug=$debug						\
	&&								\
	export log=$log							\
	&&								\
	curl -o /$file https://$domain/$path/$file			\
	&&								\
	chmod +x /$file							\
	&&								\
	/$file								\
		2>&1							\
	|								\
		sudo tee /$file.log					\
"									;
targets="								\
	InstanceManager1						\
"									;
for target in $targets							;
do									\
	send_command "$command" "$stack" "$target"			\
									;
done									;
#########################################################################
file=kube-wait.sh							;
command="								\
	export debug=$debug						\
	&&								\
	export log=$log							\
	&&								\
	curl -o /$file https://$domain/$path/$file			\
	&&								\
	chmod +x /$file							\
	&&								\
	/$file								\
		2>&1							\
	|								\
		sudo tee /$file.log					\
"									;
targets="								\
	InstanceManager1						\
"									;
for target in $targets							;
do									\
	echo "Waiting for $target to complete ..."			;
	output="$(							\
		send_list_command "$command" "$stack" "$target"		\
	)"								\
									;
done									;
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
file=manager.sh								;
command="								\
	export debug=$debug						\
	&&								\
	export log=$log							\
	&&								\
	export token_certificate=$token_certificate			\
	&&								\
	export token_discovery=$token_discovery				\
	&&								\
	export token_token=$token_token					\
	&&								\
	curl -o /$file https://$domain/$path/$file			\
	&&								\
	chmod +x /$file							\
	&&								\
	/$file								\
		2>&1							\
	|								\
		sudo tee /$file.log					\
"									;
targets="								\
	InstanceManager2						\
	InstanceManager3						\
"									;
for target in $targets							;
do									\
	send_list_command "$command" "$stack" "$target"			\
									;
done									;
#########################################################################
file=worker.sh								;
command="								\
	export debug=$debug						\
	&&								\
	export log=$log							\
	&&								\
	export token_discovery=$token_discovery				\
	&&								\
	export token_token=$token_token					\
	&&								\
	curl -o /$file https://$domain/$path/$file			\
	&&								\
	chmod +x /$file							\
	&&								\
	/$file								\
		2>&1							\
	|								\
		sudo tee /$file.log					\
"									;
targets="								\
	InstanceWorker1							\
	InstanceWorker2							\
	InstanceWorker3							\
"									;
for target in $targets							;
do									\
	send_list_command "$command" "$stack" "$target"			\
									;
done									;
#########################################################################
