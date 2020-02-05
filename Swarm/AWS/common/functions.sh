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
