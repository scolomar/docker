#!/bin/bash -x
#	./app/Swarm/Shell/deploy.sh
#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
set +x && test "$debug" = true && set -x 				;
#########################################################################
test -n "$apps"		|| exit 100					;
test -n "$debug"	|| exit 100					;
test -n "$deploy"	|| exit 100					;
test -n "$domain"	|| exit 100					;
test -n "$mode"		|| exit 100					;
test -n "$repository"	|| exit 100					;
test -n "$username"	|| exit 100					;
#########################################################################
apps="									\
  $(                                                   			\
    echo								\
      $apps                                      			\
    |                                                               	\
      base64                                                  		\
        --decode                                        		\
  )									\
"                                                                      	;
path=$username/$repository/master/$mode/$deploy				;
#########################################################################
for app in $apps							;
do 									\
  for name in $app $app-BLUE						;
  do									\
    uuid=$( uuidgen )							;
    curl --output $uuid https://$domain/$path/$name.yaml       		;
    sudo docker stack deploy --compose-file $uuid $app 			;
    rm --force $uuid							;
  done									;
done									;
#########################################################################
