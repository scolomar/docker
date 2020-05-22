#!/bin/bash -x
#	./bin/init.sh
#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
set +x && test "$debug" = true && set -x				;
#########################################################################
test -n "$apps"	                && export apps           || exit 100    ;
test -n "$AWS"	                && export AWS            || exit 100    ;
test -n "$branch"               && export branch         || exit 100    ;
test -n "$debug"                && export debug          || exit 100    ;
test -n "$deploy" 		&& export deploy	 || exit 100	;
test -n "$domain" 		&& export domain	 || exit 100	;
test -n "$HostedZoneName"       && export HostedZoneName || exit 100    ;
test -n "$Identifier"           && export Identifier	 || exit 100    ; 
test -n "$TypeManager"		&& export TypeManager	 || exit 100 	;
test -n "$TypeWorker"		&& export TypeWorker	 || exit 100 	;
test -n "$KeyName"	        && export KeyName	 || exit 100    ; 
test -n "$mode"                 && export mode		 || exit 100    ;
test -n "$RecordSetName1"       && export RecordSetName1 || exit 100    ;
test -n "$RecordSetName2"       && export RecordSetName2 || exit 100    ;
test -n "$RecordSetName3"       && export RecordSetName3 || exit 100    ;
test -n "$repository"           && export repository  	 || exit 100    ;
test -n "$stack"                && export stack		 || exit 100    ;
test -n "$username"             && export username	 || exit 100    ;
#########################################################################
file=functions.sh                                                       ;
path=$AWS/common                                 			;
uuid=$( uuidgen )							;
#########################################################################
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
path=$AWS/install/AMI/bin						;
#########################################################################
output="								\
  $(									\
    exec_remote_file $domain $file $path				;
  )									\
"									;
echo $output
#########################################################################
file=init.sh                                               		;
path=$AWS/install/docker/$mode/bin					;
#########################################################################
output="								\
  $(									\
    exec_remote_file $domain $file $path				;
  )									\
"									;
echo $output
#########################################################################
file=init.sh                                               		;
path=$AWS/app/bin							;
#########################################################################
output="								\
  $(									\
    exec_remote_file $domain $file $path				;
  )									\
"									;
echo $output
#########################################################################
