#!/bin/bash -x
#	./app/Kubernetes/Shell/deploy.sh
#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
set +x && test "$debug" = true && set -x 				;
#########################################################################
test -n "$apps"		|| exit 100					;
test -n "$debug"        || exit 100                                     ;
test -n "$deploy"       || exit 100                                     ;
test -n "$domain"       || exit 100                                     ;
test -n "$repository"	|| exit 100					;
test -n "$username"	|| exit 100					;
#########################################################################
apps="                                                                  \
  $(                                                                    \
    echo                                                                \
      $apps                                                             \
    |                                                                   \
      base64                                                            \
        --decode                                                        \
  )                                                                     \
"                                                                       ;
kubeconfig=" --kubeconfig /etc/kubernetes/admin.conf "			;
path=$username/$repository/master/$mode/$deploy				;
#########################################################################
for config in $( find /run/configs -type f )				;
do									\
  file=$( basename $config )						;
  kubectl create configmap $file --from-file $config $kubeconfig	; 
  rm --force $config							; 
done									;
#########################################################################
for secret in $( find /run/secrets -type f )				;
do									\
  file=$( basename $secret )						;
  kubectl create secret generic $file --from-file $secret $kubeconfig	;	
  rm --force $secret							; 
done									;
#########################################################################
for app in $apps							;
do 									\
  for name in $app $app-BLUE    					;
  do									\
    uuid=$( uuidgen )							;
    curl --output $uuid https://$domain/$path/$name.yaml       		;
    kubectl apply --filename $uuid $kubeconfig				;
    rm --force $uuid							;
  done									;
done									;
#########################################################################
