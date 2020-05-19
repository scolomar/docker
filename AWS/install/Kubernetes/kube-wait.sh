#!/bin/bash -x
#	./install/Kubernetes/kube-wait.sh
#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
set +x && test "$debug" = true && set -x				;
#########################################################################
test -n "$debug"                || exit 100                             ;
#########################################################################
kubeconfig=/etc/kubernetes/admin.conf                   		;
#########################################################################
USER=ssm-user								;
HOME=/home/$USER							;
while true								;
do									\
  test -f $HOME/.kube/config						\
  &&									\
  break									\
									;
done									;	
#########################################################################
while true								;
do									\
  kubectl get node							\
    --kubeconfig $kubeconfig						\
  |									\
    grep Ready								\
    |									\
      grep --invert-match NotReady					\
      &&								\
      break								\
									;
done									;
#########################################################################
sed --in-place /kube/d /etc/hosts                                     	;
#########################################################################
