#!/bin/bash
#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
export debug=$debug							;
export log=$log								;
export token_discovery=$token_discovery                                 ;
export token_token=$token_token                                         ;
#########################################################################
token_discovery="$( echo $token_discovery | base64 -d )"             	;
token_token="$( echo $token_token | base64 -d )"             		;
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
sudo									\
	$token_token                                            	\
	$token_discovery                                        	\
	--ignore-preflight-errors					\
		all							\
	|								\
		sudo tee $log						\
									;
#########################################################################
