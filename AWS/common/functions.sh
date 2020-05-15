#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
function exec_remote_file_targets {					\
  local domain=$1							;
  local file=$2								;
  local path=$3								;
  local stack=$4							;
  local targets="$5"							;
  local command="							\
    curl -O https://$domain/$path/$file					\
    &&									\
    chmod +x ./$file							\
    &&									\
    ./$file								\
    &&									\
    rm --force ./$file							\
  "									;
  for target in $targets                                                ;
  do                                                                    \
    send_command "$command" "$stack" "$target"                          ;
  done                                                                  ;
}									;
#########################################################################
function exec_remote_file {						\
  local domain=$1							;
  local file=$2								;
  local path=$3								;
  local pwd=$PWD && mkdir --parents $path && cd $path                   ;
  curl -O https://$domain/$path/$file                                   ;
  chmod +x ./$file                                                      ;
  ./$file                                                               ;
  cd $pwd && rm --recursive --force $path                               ;
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
    echo $output | grep [a-zA-Z0-9] --quiet && break 			;
    sleep 10								;
  done 									;
  echo $output								;
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
