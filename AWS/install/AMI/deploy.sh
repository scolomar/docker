#!/bin/bash
#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
export debug								;
export deploy								;
export s3domain								;
export HostedZoneName							;
export Identifier							;
export mode								;
export RecordSetName1							;
export RecordSetName2							;
export RecordSetName3							;
export stack								;
#########################################################################
set +x && test "$debug" = true && set -x				;
#########################################################################
test $mode = Kubernetes && size=small || size=nano			;
caps=CAPABILITY_IAM                                                     ;
template=https://$s3domain/cloudformation-https.yaml       		;
CommandId=$(								\
  aws cloudformation create-stack 					\
    --capabilities 							\
      $caps 								\
    --parameters 							\
      ParameterKey=InstanceManagerInstanceType,ParameterValue=t3a.$size \
      ParameterKey=InstanceWorkerInstanceType,ParameterValue=t3a.nano 	\
      ParameterKey=HostedZoneName,ParameterValue=$HostedZoneName	\
      ParameterKey=Identifier,ParameterValue=$Identifier		\
      ParameterKey=RecordSetName1,ParameterValue=$RecordSetName1	\
      ParameterKey=RecordSetName2,ParameterValue=$RecordSetName2	\
      ParameterKey=RecordSetName3,ParameterValue=$RecordSetName3	\
    --query 								\
      "Command.CommandId" 						\
    --stack-name 							\
      $stack 								\
    --template-url 						 	\
      $template 							\
    --output 								\
      text 								\
)									;
#########################################################################
while true 								;
do 									\
  output=$( 								\
    aws ssm list-command-invocations 					\
      --command-id 							\
        $CommandId 							\
      --query 								\
        "CommandInvocations[].CommandPlugins[].Output" 			\
      --details 							\
      --output 								\
        text 								\
  ) 									;
  echo $output | grep [a-zA-Z0-9] --quiet && break 			;
  sleep 								\
    10									;
done									;
echo $output								;
#########################################################################
