#!/bin/bash
#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
export debug=$debug							;
set +x && test "$debug" = true && set -x				;
echo PWD=$PWD
echo USER=$USER
#########################################################################
docker=raw.githubusercontent.com/secobau/docker				;
folder=master/AWS/install/Kubernetes/etc/yum.repos.d			;
file=kubernetes.repo							;
repos=etc/yum.repos.d							;
#########################################################################
remote=https://$docker/$folder/$file					;
wget $remote && sudo mv $file /$repos					;
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
