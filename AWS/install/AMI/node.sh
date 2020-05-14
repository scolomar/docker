#!/bin/sh -x
#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
export debug=$debug							;
#########################################################################
set +x && test "$debug" = true && set -x				;
#########################################################################
sudo yum update -y							;
sudo amazon-linux-extras install docker -y				;
sudo systemctl enable docker						;
sudo systemctl start docker						;
while true								;
do 									\
  sudo service docker status | grep running -q && break			;
  sleep 10								;
done									;
#########################################################################
