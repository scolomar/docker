#!/bin/sh -x
################################################################################
##	Copyright (C) 2020	  Alejandro Colomar Andrés		      ##
##	Copyright (C) 2020	  Sebastian Francisco Colomar Bauza	      ##
##	SPDX-License-Identifier:  GPL-2.0-only				      ##
################################################################################
##
## Prepare the repo for release
## ============================
##
##  - Remove the files that shouldn't go into the release
##  - Update version numbers
##
################################################################################


################################################################################
##	functions							      ##
################################################################################
update_version()
{
	local	version=$1

	sed "/docker_branch=/s/master/v$version/"			\
			-i AWS/app/README.md				\
			-i AWS/install/AMI/README.md			\
			-i AWS/install/docker/README.md			\
			-i AWS/README.md				\
			-i README-test.md
}


################################################################################
##	main								      ##
################################################################################
main()
{
	local	version=$1

	update_version	${version}
}


################################################################################
##	run								      ##
################################################################################
main	$1


################################################################################
##	end of file							      ##
################################################################################
