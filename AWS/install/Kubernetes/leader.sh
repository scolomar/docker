#!/bin/bash
#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
export debug=$debug							;
export log=$log								;
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
	|								\
		sudo tee --append $log					\
									;
#########################################################################
USER=ssm-user								;
HOME=/home/$USER							;
mkdir -p $HOME/.kube							;
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config			;
sudo chown $USER:$USER $HOME/.kube/config				;
echo									\
	'source <(kubectl completion bash)'				\
	|								\
		tee --append $HOME/.bashrc				\
									;
#########################################################################
sudo --user ssm-user --shell						\
	kubectl apply							\
		--filename						\
			$calico/calico.yaml				\
	|								\
		sudo tee --append $log					\
									;
#########################################################################
