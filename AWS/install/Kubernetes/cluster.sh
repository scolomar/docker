#!/bin/bash
#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
export debug=$debug							;
export stack=$stack							;
#########################################################################
set +x && test "$debug" = true && set -x				;
#########################################################################
pwd=$( dirname $( readlink -f $0 ) )					;
source $pwd/../../common/functions.sh					;
#########################################################################
test -z "$stack"							\
	&& echo PLEASE DEFINE THE VALUE FOR stack			\
	&& exit 1							\
									;
#########################################################################
calico=https://docs.projectcalico.org/v3.14/manifests			;
kube=kube-apiserver.sebastian-colomar.com				;
#########################################################################
docker=raw.githubusercontent.com/secobau/docker				;
folder=master/AWS/install/Kubernetes					;
log=/etc/kubernetes/kubernetes-install.log                              ;
#########################################################################
file=kube-install.sh							;
remote=https://$docker/$folder/$file					;
command="								\
	export debug=$debug						\
	&&								\
	curl -o /$file $remote						\
	&&								\
	chmod +x /$file							\
	&&								\
	/$file								\
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
	send_command "$command" "$target" "$stack"			\
									;
done									;
#########################################################################
file=leader.sh								;
remote=https://$docker/$folder/$file					;
command="								\
	export debug=$debug						\
	&&								\
	export log=$log							\
	&&								\
	curl -o /$file $remote						\
	&&								\
	chmod +x /$file							\
	&&								\
	/$file								\
	|								\
		sudo tee /$file.log					\
"									;
targets="								\
	InstanceManager1						\
"									;
for target in $targets							;
do									\
	send_command "$command" "$target" "$stack"			\
									;
done									;
#########################################################################
file=kube-wait.sh							;
remote=https://$docker/$folder/$file					;
command="								\
	export debug=$debug						\
	&&								\
	export log=$log							\
	&&								\
	curl -o /$file $remote						\
	&&								\
	chmod +x /$file							\
	&&								\
	/$file								\
	|								\
		sudo tee /$file.log					\
"									;
targets="								\
	InstanceManager1						\
"									;
for target in $targets							;
do									\
	output="$(							\
		send_list_command "$command" "$target" "$stack"		\
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
	send_list_command "$command" "$target" "$stack"			\
									;
done									;
token_certificate=$( echo -n $output | base64 )				;
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
	send_list_command "$command" "$target" "$stack"			\
									;
done									;
token_discovery=$( echo -n $output | base64 )				;
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
	send_list_command "$command" "$target" "$stack"			\
									;
done									;
token_token=$( echo -n $output | base64 )				;
#########################################################################
file=manager.sh								;
remote=https://$docker/$folder/$file					;
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
	curl -o /$file $remote						\
	&&								\
	chmod +x /$file							\
	&&								\
	/$file								\
	|								\
		sudo tee /$file.log					\
"									;
targets="								\
	InstanceManager2						\
	InstanceManager3						\
"									;
for target in $targets							;
do									\
	send_command "$command" "$target" "$stack"			\
									;
done									;
#########################################################################
file=worker.sh								;
remote=https://$docker/$folder/$file					;
command="								\
	export debug=$debug						\
	&&								\
	export log=$log							\
	&&								\
	export token_discovery=$token_discovery				\
	&&								\
	export token_token=$token_token					\
	&&								\
	curl -o /$file $remote						\
	&&								\
	chmod +x /$file							\
	&&								\
	/$file								\
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
	send_command "$command" "$target" "$stack"			\
									;
done									;
#########################################################################
