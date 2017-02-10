#!/usr/bin/env bash

# Go to script directory
basedir=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

# For all versions : launch build
for VERSION in `ls ${basedir}`; do
	# Script directory
	VERSION_DIR=${basedir}/${VERSION}

	# Version directory does not exist
	if [[ ! -d $VERSION_DIR ]]; then
		printf "Error : Version \"$VERSION\" does not exist\n";
		exit -1;
	fi

	# Go to dir
	cd ${VERSION_DIR}

	printf "============================\n==> Start build \"$VERSION\" <==\n============================\n";

	# Build image
	docker build -t thomasglachant/docker-php:php${VERSION} .

	# get build return code 
	BUILD_SUCCESS=$?

	printf "============================\n==> End build \"$VERSION\" <==\n============================\n\n";

	# if build fail : exit
	if [[ ${BUILD_SUCCESS} -ne 0 ]] ; then
		printf "Error : Unable to build version \"${VERSION}\"\n";
		exit -1;
	fi
done