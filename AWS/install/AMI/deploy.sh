#!/bin/bash -x
#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
set +x && test "$debug" = true && set -x				;
#########################################################################
export debug=$debug							;
export HostedZoneName=$HostedZoneName					;
export Identifier=$Identifier						;
export mode=$mode							;
export RecordSetName1=$RecordSetName1					;
export RecordSetName2=$RecordSetName2					;
export RecordSetName3=$RecordSetName3					;
export s3domain=$s3domain						;
export stack=$stack							;
#########################################################################
test $mode = Kubernetes && size=small || size=nano			;
caps=CAPABILITY_IAM                                                     ;
template=https://$s3domain/cloudformation-https.yaml       		;
aws cloudformation create-stack 					\
  --capabilities 							\
    $caps 								\
  --parameters 								\
    ParameterKey=InstanceManagerInstanceType,ParameterValue=t3a.$size 	\
    ParameterKey=InstanceWorkerInstanceType,ParameterValue=t3a.nano 	\
    ParameterKey=HostedZoneName,ParameterValue=$HostedZoneName		\
    ParameterKey=Identifier,ParameterValue=$Identifier			\
    ParameterKey=RecordSetName1,ParameterValue=$RecordSetName1		\
    ParameterKey=RecordSetName2,ParameterValue=$RecordSetName2		\
    ParameterKey=RecordSetName3,ParameterValue=$RecordSetName3		\
  --stack-name 								\
    $stack 								\
  --template-url 						 	\
    $template 								\
  --output 								\
    text 								\
									;
#########################################################################
while true 								;
do 									\
  output=$( 								\
    aws cloudformation describe-stacks 					\
      --query 								\
        "Stacks[].StackStatus" 						\
      --output 								\
        text 								\
      --stack-name 							\
        $stack 								\
  ) 									;
  echo $output | grep CREATE_COMPLETE && break 				;
  sleep 10 								;
done									;
echo $output								;
#########################################################################
