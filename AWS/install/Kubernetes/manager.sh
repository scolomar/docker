#!/bin/bash
#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
export debug=$debug							;
export log=$log								;
export token_certificate=$token_certificate                             ;
export token_discovery=$token_discovery                                 ;
export token_token=$token_token                                         ;
#########################################################################
su ssm-user								;
#########################################################################
set +x && test "$debug" = true && set -x				;
#########################################################################
ip=10.168.1.100                                                         ;
kube=kube-apiserver.sebastian-colomar.com                               ;
#########################################################################
echo $ip $kube | sudo tee --append /etc/hosts                           ;
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
mkdir -p $HOME/.kube							;
sudo									\
	$token_token                                            	\
	$token_discovery                                        	\
	$token_certificate                                      	\
	--ignore-preflight-errors					\
		all							\
	|								\
		sudo tee $log						\
									;
#########################################################################
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config			;
sudo chown $(id -u):$(id -g) $HOME/.kube/config				;
#########################################################################
echo									\
	'source <(kubectl completion bash)'				\
	|								\
		tee --append $HOME/.bashrc				\
									;
#########################################################################
