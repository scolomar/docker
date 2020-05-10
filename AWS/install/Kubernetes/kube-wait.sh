#!/bin/bash
#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
export debug=$debug							;
#########################################################################
set +x && test "$debug" = true && set -x				;
#########################################################################
USER=ssm-user
HOME=/home/$USER
while true								;
do									\
	sleep								\
		3							\
									;
	test								\
		-f							\
			$HOME/.kube/config				\
	&&								\
	break								\
									;
done									;	
#########################################################################
while true								;
do									\
	sleep								\
		3							\
									;
sudo --user $USER --login \
	kubectl get node						\
	|								\
		grep Ready						\
		&&							\
		break							\
									;
done									;
echo $( sudo --user $USER --shell kubectl get node 2>&1 )
#########################################################################
echo ready								;
#########################################################################
