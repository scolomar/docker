#!/bin/bash
#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
#########################################################################
#set -x									;
pwd=$( dirname $( readlink -f $0 ) )					;
source $pwd/../../common/functions.sh					;
#########################################################################
test -z "$stack"							\
	&& echo PLEASE DEFINE THE VALUE FOR stack			\
	&& exit 1							\
									;
#########################################################################
calico=https://docs.projectcalico.org/v3.14/manifests			;
yum=https://packages.cloud.google.com/yum				;
ip=10.168.1.100								;
kube=kube-apiserver.sebastian-colomar.com				;
#########################################################################
command="								\
	repo=/etc/yum.repos.d/kubernetes.repo				;
	test -f $repo && rm -f $repo					;
	echo								\
		'[kubernetes]'						\
			| sudo tee --append $repo			\
									;
	echo								\
		name=Kubernetes						\
			| sudo tee --append $repo			\
									;
	echo								\
		baseurl=$yum/repos/kubernetes-el7-'$basearch'		\
			| sudo tee --append $repo			\
									;
	echo								\
		enabled=1						\
			| sudo tee --append $repo			\
									;
	echo								\
		gpgcheck=1						\
			| sudo tee --append $repo			\
									;
	echo								\
		repo_gpgcheck=1						\
			| sudo tee --append $repo			\
									;
	echo								\
		gpgkey=$yum/doc/yum-key.gpg				\
		$yum/doc/rpm-package-key.gpg				\
			| sudo tee --append $repo			\
									;
	echo								\
		exclude=kubelet kubeadm kubectl				\
			| sudo tee --append $repo			\
									;
	sudo yum install						\
		-y							\
		--disableexcludes=kubernetes				\
		kubelet kubeadm kubectl					\
									;
	sudo systemctl enable --now kubelet				;
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
command="								\
	sudo systemctl is-enabled kubelet				\
		| grep enabled						\
									;
"									;
targets="InstanceManager1"						;
for target in $targets							;
do									\
	send_list_command "$command" "$target" "$stack"			\
									;
done									;
#########################################################################
command="								\
	echo $ip $kube							\
		| sudo tee --append /etc/hosts				\
									;
"									;
targets="								\
	InstanceManager1						\
	InstanceManager2						\
	InstanceManager3						\
"									;
for target in $targets							;
do									\
	send_command "$command" "$target" "$stack"			\
									;
done									;
#########################################################################
command="								\
	sudo kubeadm init						\
		--upload-certs						\
		--control-plane-endpoint=\"$kube\"			\
		--pod-network-cidr=192.168.0.0/16			\
		--ignore-preflight-errors=all				\
			| tee $HOME/kubernetes.log-install		\
									;
	mkdir -p $HOME/.kube						;
	sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config		;
	sudo chown $(id -u):$(id -g) $HOME/.kube/config			;
	echo								\
		'source <(kubectl completion bash)'			\
			| tee --append \$HOME/.bashrc			\
									;
	kubectl apply --filename					\
		$calico/calico.yaml					\
									;
"									;
targets="InstanceManager1"						;
for target in $targets							;
do									\
	send_command "$command" "$target" "$stack"			\
									;
done									;
#########################################################################
command="								\
	kubectl get node						\
		| grep Ready						\
									;
"									;
targets="InstanceManager1"						;
for target in $targets							;
do									\
	send_list_command "$command" "$target" "$stack"			\
									;
done									;
#########################################################################
command="								\
	grep								\
		--max-count 1						\
		'kubeadm join'						\
		\$HOME/kubernetes.log-install				\
									;
"									;
targets="InstanceManager1"						;
for target in $targets							;
do									\
	send_list_command "$command" "$target" "$stack"			\
									;
done									;
token_token="$output"							;
#########################################################################
command="								\
	grep								\
		--max-count 1						\
		discovery-token-ca-cert-hash				\
		\$HOME/kubernetes.log-install				\
									;
"									;
targets="InstanceManager1"						;
for target in $targets							;
do									\
	send_list_command "$command" "$target" "$stack"			\
									;
done									;
token_discovery="$output"						;
#########################################################################
command="								\
	grep								\
		--max-count 1						\
		certificate-key						\
		\$HOME/kubernetes.log-install				\
									;
"									;
targets="InstanceManager1"						;
for target in $targets							;
do									\
	send_list_command "$command" "$target" "$stack"			\
									;
done									;
token_certificate="$output"						;
#########################################################################
command="								\
	sudo								\
		$token_token						\
		$token_discovery					\
		$token_certificate					\
		--ignore-preflight-errors=all				\
									;
	mkdir -p \$HOME/.kube						;
	sudo cp /etc/kubernetes/admin.conf \$HOME/.kube/config		;
	sudo chown \$(id -u):\$(id -g) \$HOME/.kube/config		;
	echo								\
		'source <(kubectl completion bash)'			\
			| tee --append \$HOME/.bashrc			\
									;
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
command="								\
	sudo								\
		$token_token						\
		$token_discovery					\
		--ignore-preflight-errors=all				\
									;
"									;
targets="InstanceWorker1 InstanceWorker2 InstanceWorker3"		;
for target in $targets							;
do									\
	send_command "$command" "$target" "$stack"			\
									;
done									;
#########################################################################
command="								\
	kubectl get node						\
		| grep Ready						\
									;
"									;
targets="								\
	InstanceManager2						\
	InstanceManager3						\
"									;
for target in $targets							;
do									\
	send_list_command "$command" "$target" "$stack"			\
									;
done									;
#########################################################################
command="								\
	sudo sed --in-place /$kube/d /etc/hosts				\
									;
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
command="								\
	kubectl get node						\
		| grep Ready						\
									;
"									;
targets="								\
	InstanceManager2						\
	InstanceManager3						\
"									;
for target in $targets							;
do									\
	send_list_command "$command" "$target" "$stack"			\
									;
done									;
#########################################################################
