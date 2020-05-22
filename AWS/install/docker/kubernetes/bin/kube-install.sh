#!/bin/bash -x
#	./install/docker/kubernetes/bin/kube-install.sh
#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
set +x && test "$debug" = true && set -x				;
#########################################################################
test -n "$AWS" 		        || exit 100                             ;        
test -n "$debug" 		|| exit 100                             ;        
test -n "$domain"               || exit 100                             ;        
#########################################################################
file=kubernetes.repo							;
repos=yum.repos.d							;
#########################################################################
path=$AWS/install/docker/kubernetes/etc/$repos					;
uuid=$( uuidgen )							;
curl --output $uuid https://$domain/$path/$file                         ;
mv $uuid /etc/$repos/$file						;
#########################################################################
yum install								\
	--assumeyes							\
	--disableexcludes=kubernetes					\
	kubelet								\
	kubeadm								\
	kubectl								\
									;
systemctl enable							\
	--now								\
	kubelet								\
									;
#########################################################################
