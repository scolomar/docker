#!/bin/bash -x
#	./install/AMI/bin/init.sh
#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
set +x && test "$debug" = true && set -x				;
#########################################################################
test -n "$debug" 		|| exit 100				;
test -n "$HostedZoneName" 	|| exit 100                             ;
test -n "$Identifier" 		|| exit 100                             ;
test -n "$KeyName" 		|| exit 100                             ;
test -n "$RecordSetName1" 	|| exit 100                             ;
test -n "$RecordSetName2" 	|| exit 100                             ;
test -n "$RecordSetName3" 	|| exit 100                             ;
test -n "$stack" 		|| exit 100                             ;
test -n "$TypeManager"      	|| exit 100    				;
test -n "$TypeWorker"      	|| exit 100    				;
#########################################################################
caps=CAPABILITY_IAM                                                     ;
s3domain=docker-aws.s3.ap-south-1.amazonaws.com				;
#########################################################################
template=https://$s3domain/cloudformation-https.yaml       		;
#########################################################################
aws cloudformation create-stack 					\
  --capabilities 							\
    $caps 								\
  --parameters 								\
    ParameterKey=InstanceManagerInstanceType,ParameterValue=$TypeManager\
    ParameterKey=InstanceWorkerInstanceType,ParameterValue=$TypeWorker  \
    ParameterKey=HostedZoneName,ParameterValue=$HostedZoneName		\
    ParameterKey=Identifier,ParameterValue=$Identifier			\
    ParameterKey=KeyName,ParameterValue=$KeyName			\
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
  aws cloudformation describe-stacks 					\
    --query 								\
      "Stacks[].StackStatus" 						\
    --output 								\
      text 								\
    --stack-name 							\
      $stack 								\
  | 									\
    grep CREATE_COMPLETE && break 					;
  sleep 100 								;
done									;
#########################################################################
