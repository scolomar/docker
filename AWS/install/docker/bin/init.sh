#!/bin/bash -x
#	./install/docker/bin/init.sh
#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
set +x && test "$debug" = true && set -x				;
#########################################################################
test -n "$AWS"	                && export AWS            || exit 100    ;
test -n "$debug"                && export debug          || exit 100    ;
test -n "$domain" 		&& export domain         || exit 100    ;
test -n "$HostedZoneName"	&& export HostedZoneName || exit 100    ;
test -n "$mode"                 && export mode           || exit 100    ;       
test -n "$stack"                && export stack          || exit 100    ;       
#########################################################################
file=functions.sh                                                       ;
path=$AWS/common                                 			;
uuid=$( uuidgen )							;
curl --output $uuid https://$domain/$path/$file                         ;
source ./$uuid                                                          ;
rm --force ./$uuid							;
#########################################################################
export -f encode_string							;
export -f exec_remote_file						;
export -f send_command							;
export -f send_list_command						;
export -f send_remote_file						;
export -f send_wait_targets						;
export -f service_wait_targets						;
#########################################################################
file=init.sh                                               		;
path=$AWS/install/docker/$mode/bin					;
exec_remote_file $domain $file $path					;
#########################################################################
