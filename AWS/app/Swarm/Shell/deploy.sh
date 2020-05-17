#!/bin/bash -x
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
test -n "$repository"	|| exit 100					;
test -n "$username"	|| exit 100					;
#########################################################################
path=$username/$repository/master/$mode/$deploy				;
#########################################################################
for app in $apps							;
do 									\
  for file in $app.yaml $app-BLUE.yaml					;
  do									\
    folder=/root/$( uuidgen )						;
    curl --output $folder/$file https://$domain/$path/$file           	;
    sudo docker stack deploy --compose-file $folder/$file $app 		;
    rm --force $folder/$file						;
  done									;
done									;
#########################################################################
