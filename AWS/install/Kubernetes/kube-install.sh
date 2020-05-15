#!/bin/bash -x
#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
set +x && test "$debug" = true && set -x				;
#########################################################################
domain=raw.githubusercontent.com                                        ;
file=kubernetes.repo							;
repos=etc/yum.repos.d							;
#########################################################################
path=secobau/docker/master/AWS/install/Kubernetes/$repos		;
pwd=$PWD && mkdir --parents $path && cd $path                           ;
curl -O https://$domain/$path/$file                                     ;
sudo mv $file /$repos							;
cd $pwd && rm --recursive --force $path                                 ;
#########################################################################
sudo yum install							\
	--assumeyes							\
	--disableexcludes=kubernetes					\
	kubelet								\
	kubeadm								\
	kubectl								\
									;
sudo systemctl enable							\
	--now								\
	kubelet								\
									;
#########################################################################
