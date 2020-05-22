#!/bin/bash -x
#	./install/docker/kubernetes/bin/worker.sh
#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
set +x && test "$debug" = true && set -x				;
#########################################################################
test -n "$debug"                || exit 100                             ;
test -n "$HostedZoneName"       || exit 100                             ;
test -n "$log"                	|| exit 100                             ;
test -n "$token_discovery"      || exit 100                             ;
test -n "$token_token"          || exit 100                             ;
#########################################################################
kube=kube-apiserver.$HostedZoneName					;
#########################################################################
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
echo $ip $kube | tee --append /etc/hosts                           	;
#########################################################################
while true								;
do									\
        systemctl							\
		is-enabled						\
			kubelet                               		\
	|								\
		grep enabled                                          	\
		&& break						\
                                                                        ;
done									;	
#########################################################################
$token_token                                            		\
	$token_discovery                                        	\
	--ignore-preflight-errors					\
		all							\
	2>&1								\
	|								\
		tee $log						\
									;
#########################################################################
