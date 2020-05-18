#!/bin/bash -x
#	./app/Shell/deploy-config.sh
#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
set +x && test "$debug" = true && set -x 				;
#########################################################################
test -n "$debug"	|| exit 100					;
test -n "$repository"	|| exit 100					;
test -n "$username"	|| exit 100					;
#########################################################################
folders=" configs secrets " 						;
#########################################################################
uuid=$( uuidgen )							;
git clone https://github.com/$username/$repository $uuid		;
for folder in $folders 							;
do 									\
  sudo cp --recursive --verbose $uuid/$folder /run 	 		;
done 									;
sudo rm --recursive --force $uuid 		 			;
#########################################################################
