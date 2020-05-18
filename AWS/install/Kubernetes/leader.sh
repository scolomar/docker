#!/bin/bash -x
#	./install/Kubernetes/leader.sh
#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
set +x && test "$debug" = true && set -x				;
#########################################################################
calico=https://docs.projectcalico.org/v3.14/manifests			;
cidr=192.168.0.0/16							;
ip=10.168.1.100                                                         ;
kube=kube-apiserver.sebastian-colomar.com                               ;
#########################################################################
while true								;
do									\
        sudo systemctl							\
		is-enabled						\
			kubelet                               		\
	|								\
		grep enabled                                          	\
		&& break						\
                                                                        ;
done									;	
#########################################################################
echo $ip $kube | sudo tee --append /etc/hosts                           ;
sudo kubeadm init							\
	--upload-certs							\
	--control-plane-endpoint					\
		"$kube"							\
	--pod-network-cidr						\
		$cidr							\
	--ignore-preflight-errors					\
		all							\
	2>&1								\
	|								\
		sudo tee --append $log					\
									;
#########################################################################
sudo kubectl apply							\
	--filename							\
		$calico/calico.yaml					\
	--kubeconfig							\
		/etc/kubernetes/admin.conf				\
	2>&1								\
	|								\
		sudo tee --append $log					\
									;
#########################################################################
userID=1001								;
USER=ssm-user								;
HOME=/home/$USER							;
mkdir -p $HOME/.kube							;
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config			;
sudo chown -R $userID:$userID $HOME					;
echo									\
	'source <(kubectl completion bash)'				\
	|								\
		tee --append $HOME/.bashrc				\
									;
#########################################################################
