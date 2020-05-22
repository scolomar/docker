#!/bin/bash
###############################################################################
##       Copyright (C) 2020        Sebastian Francisco Colomar Bauza         ##
##       Copyright (C) 2020        Alejandro Colomar Andrés                  ##
##       SPDX-License-Identifier:  GPL-2.0-only                              ##
###############################################################################


## The docker-compose file has to be in this route:
## /etc/docker/${mode}/${deploy}/<docker-compose>

## The init script is in this route:
## https://${domain}/${path}/${fname}
## == https://${domain}/secobau/docker/${docker_branch}/AWS/${fname}


################################################################################
##	variables							      ##
################################################################################
apps=" <docker-compose> "
branch=<git-branch>		# Current branch or tag
debug=<debug>			# values: true, false
deploy=<deploy>
docker_branch=<secobau/docker branch>
HostedZoneName=<example.com>
## Identifier is the ID of the certificate in case you are using HTTPS
Identifier=<xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx>
KeyName=<mySSHpublicKey>
mode=<mode>			# values: kubernetes, swarm
RecordSetName1=<service-1>	# subdomain 1
RecordSetName2=<service-2>
RecordSetName3=<service-3>
repository=<github-repository>
stack=<stack>
TypeManager=<type>			# t3a.nano
TypeWorker=<type>			# t3a.nano
username=<github-username>


################################################################################
##	export								      ##
################################################################################
export apps
export AWS=secobau/docker/${docker_branch}/AWS
export branch
export debug
export deploy
export domain=raw.githubusercontent.com
export HostedZoneName
export Identifier
export KeyName
export mode
export RecordSetName1
export RecordSetName2
export RecordSetName3
export repository
export stack
export TypeManager
export TypeWorker
export username


################################################################################
##	run								      ##
################################################################################
path=${AWS}/bin
fname=init.sh
date=$( date +%F_%H%M )
mkdir	${date}
cd	${date}
curl --remote-name https://${domain}/${path}/${fname}
chmod +x ./${fname}
nohup	./${fname} &


################################################################################
##	end of file							      ##
################################################################################
