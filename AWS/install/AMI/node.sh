#!/bin/sh -x
#	./install/AMI/node.sh
#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
set +x 	&& test "$debug" = true	&& set -x				;
#########################################################################
test -n "$debug" 		&& export debug=$debug || exit 100	;
#########################################################################
yum update -y								;
amazon-linux-extras install docker -y					;
systemctl enable docker							;
systemctl start docker							;
while true								;
do 									\
  service docker status | grep running -q && break			;
  sleep 10								;
done									;
#########################################################################
