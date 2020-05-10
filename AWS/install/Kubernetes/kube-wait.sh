#!/bin/bash
#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
export debug=$debug							;
#########################################################################
set +x && test "$debug" = true && set -x				;
#########################################################################
USER=ssm-user								;
HOME=/home/$USER							;
while true								;
do									\
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
	sudo --user $USER --login					\
		kubectl get node					\
		|							\
			grep						\
				Ready					\
			|						\
				grep					\
					--invert-match			\
						NotReady		\
				&&					\
				break					\
									;
done									;
#########################################################################
