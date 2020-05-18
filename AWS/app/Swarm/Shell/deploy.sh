#!/bin/bash -x
#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
set +x && test "$debug" = true && set -x 				;
#########################################################################
echo apps=$apps
test -n "$apps"		|| exit 100					;
test -n "$apps"		|| exit 100					;
test -n "$debug"	|| exit 100					;
test -n "$deploy"	|| exit 100					;
test -n "$domain"	|| exit 100					;
test -n "$mode"		|| exit 100					;
test -n "$repository"	|| exit 100					;
test -n "$username"	|| exit 100					;
#########################################################################
path=$username/$repository/master/$mode/$deploy				;
#########################################################################
for app in $apps							;
do 									\
  for file in $app.yaml $app-BLUE.yaml					;
  do									\
    uuid=$( uuidgen )							;
    curl --output $uuid https://$domain/$path/$file           		;
    sudo docker stack deploy --compose-file $uuid $app 			;
    rm --force $uuid							;
  done									;
done									;
#########################################################################
