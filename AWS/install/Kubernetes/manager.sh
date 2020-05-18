#!/bin/bash -x
#	./install/Kubernetes/manager.sh
#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
set +x && test "$debug" = true && set -x				;
#########################################################################
test -n "$debug"                || exit 100                             ;
test -n "$HostedZoneName"       || exit 100                             ;
test -n "$log"                  || exit 100                             ;
test -n "$token_certificate"    || exit 100                             ;
test -n "$token_discovery"      || exit 100                             ;
test -n "$token_token"       	|| exit 100                             ;
#########################################################################
ip=10.168.1.100                                                         ;
kube=kube-apiserver.$HostedZoneName					;
#########################################################################
token_certificate="$(							\
	echo								\
		$token_certificate					\
	|								\
		base64							\
			--decode					\
)"							         	;
token_discovery="$(							\
	echo								\
		$token_discovery					\
	|								\
		base64							\
			--decode					\
)"							         	;
token_token="$(								\
	echo								\
		$token_token						\
	|								\
		base64							\
			--decode					\
)"							         	;
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
	$token_certificate                                      	\
	--ignore-preflight-errors					\
		all							\
	2>&1								\
	|								\
		sudo tee $log						\
									;
#########################################################################
userID=1001                                                             ;
USER=ssm-user                                                           ;
HOME=/home/$USER                                                        ;
mkdir -p $HOME/.kube                                                    ;
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config                   ;
sudo chown -R $userID:$userID $HOME                                     ;
echo                                                                    \
        'source <(kubectl completion bash)'                             \
        |                                                               \
                tee --append $HOME/.bashrc                              \
                                                                        ;
#########################################################################
sed --in-place /$kube/d /etc/hosts                                      ;
#########################################################################
