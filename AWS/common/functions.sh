#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
function encode_string {						\
  local string="$1"							;
  echo -n $string                                                 	\
  |     	                                                        \
    sed 's/\\/ /'                                           		\
    |                                                       		\
      base64                                          			\
        --wrap 0                                			\
									;
}									;
#########################################################################
function exec_remote_file {						\
  local domain=$1							;
  local file=$2								;
  local path=$3								;
  local uuid=$( uuidgen )						;
  curl -o $uuid https://$domain/$path/$file                             ;
  chmod +x ./$uuid                                                      ;
  ./$uuid                                                               ;
  rm --force ./$uuid		                              		;
}									;
#########################################################################
function send_command {							\
  local command="$1" 							;
  local stack="$2" 							;
  local target="$3" 							;
  local CommandId=$( 							\
    aws ssm send-command 						\
      --document-name "AWS-RunShellScript" 				\
      --parameters commands="$command" 					\
      --targets 							\
        Key=tag:"aws:cloudformation:stack-name",Values="$stack" 	\
        Key=tag:"aws:cloudformation:logical-id",Values="$target" 	\
      --query "Command.CommandId" 					\
      --output text 							\
  ) 									;
  echo $CommandId							;
}									;
#########################################################################
function send_list_command {						\
  local command="$1" 							;
  local stack=$2 							;
  local target=$3 							;
  local CommandId=$( 							\
    send_command "$command" $stack $target				\
  ) 									;
  while true 								;
  do									\
    local output=$( 							\
      aws ssm list-command-invocations 					\
        --command-id $CommandId 					\
        --query "CommandInvocations[].CommandPlugins[].Output" 		\
        --details 							\
        --output text 							\
    ) 									;
    echo $output | grep -vi ERROR | grep [a-zA-Z0-9] && break 		;
    sleep 10								;
  done 									;
}									;
#########################################################################
function send_remote_file {						\
  local domain=$1							;
  local export="$2"							;
  local file=$3								;
  local path=$4								;
  local stack=$5							;
  local targets="$6"							;
  local command="							\
    $export								\
    &&									\
    curl -o /$file https://$domain/$path/$file                          \
    &&                                                              	\
    chmod +x /$file                                                 	\
    &&                                                              	\
    /$file                                                          	\
      2>&1                                                    		\
    |                                                               	\
      sudo tee /$file.log                                     		\
  "									;
  for target in $targets                                                ;
  do                                                                    \
    local CommandId="							\
      $(								\
        send_command "$command" "$stack" "$target"			\
      )									\
    "									;
  done                                                                  ;
}									;
#########################################################################
function send_wait_targets {						\
  local command="$1"							;
  local stack=$2							;
  local targets="$3"							;
  for target in $targets                                                ;
  do                                                                    \
        send_list_command "$command" $stack $target                   	\
    									;
  done                                                                  ;
}									;
#########################################################################
function service_wait_targets {						\
  local service=$1							;
  local stack=$2							;
  local targets="$3"							;
  command="                                                             \
    sudo service $service status 2> /dev/null | grep running		\
  "                                                                     ;
  local output="							\
    $(									\
      send_wait_targets "$command" $stack "$targets"                    \
    )									\
  "									;
}									;
#########################################################################
