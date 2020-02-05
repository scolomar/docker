#!/bin/bash

test -n "$stack" || exit 1 ;

function send_list_command {
 local command="$1" ;
 local target="$2" ;
 local stack="$3" ;
 local CommandId=$( aws ssm send-command --document-name "AWS-RunShellScript" --parameters commands="$command" --targets Key=tag:"aws:cloudformation:stack-name",Values="$stack" Key=tag:"aws:cloudformation:logical-id",Values="$target" --query "Command.CommandId" --output text ) ;
 while true ; do
  output=$( aws ssm list-command-invocations --command-id $CommandId --query "CommandInvocations[].CommandPlugins[].Output" --details --output text ) ;
  echo $output | grep [a-zA-Z0-9] --quiet && break ;
 done ;
}
 
function send_command {
 local command="$1" ;
 local target="$2" ;
 local stack="$3" ;
 local CommandId=$( aws ssm send-command --document-name "AWS-RunShellScript" --parameters commands="$command" --targets Key=tag:"aws:cloudformation:stack-name",Values="$stack" Key=tag:"aws:cloudformation:logical-id",Values="$target" --query "Command.CommandId" --output text ) ;
}

command=" sudo docker swarm join-token manager | grep token " ;
targets=" InstanceManager1 " ;
for target in $targets ; do
 send_list_command "$command" "$target" "$stack" ;
done ;
token_manager=" $output ";

command=" sudo $token_manager " ;
targets=" InstanceManager2 InstanceManager3 " ;
for target in $targets ; do
 send_command "$command" "$target" "$stack" ;
done ;

command=" sudo docker swarm join-token worker | grep token " ;
targets=" InstanceManager1 " ;
for target in $targets ; do
 send_list_command "$command" "$target" "$stack" ;
done ;
token_worker=" $output ";

command=" sudo $token_worker " ;
targets=" InstanceWorker1 InstanceWorker2 InstanceWorker3 " ;
for target in $targets ; do
 send_command "$command" "$target" "$stack" ;
done ;
