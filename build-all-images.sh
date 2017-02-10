#!/usr/bin/env bash

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# For all versions : launch build
for VERSION in `ls ${basedir}`; do
	# Version directory
	VERSION_DIR=${SCRIPTPATH}/${VERSION}

	# Explore only directories so exit if not directory
	if [[ ! -d $VERSION_DIR ]]; then
		break;
	fi

	for VARIANT in `ls ${VERSION_DIR}`; do
		# Variant directory
		VARIANT_DIR=${VERSION_DIR}/${VARIANT}
		
		# If the directory does not contain a docker file : exit
		if [[ ! -d ${VARIANT_DIR} ]] || [[ ! -f ${VARIANT_DIR}/Dockerfile ]]; then
			break
		fi

		printf "============================\n==> Start build \"$VERSION-${VARIANT}\" <==\n============================\n";

		# Build image
		docker build -t thomasglachant/docker-php:php${VERSION}-${VARIANT} ${VARIANT_DIR}

		# get build return code 
		BUILD_SUCCESS=$?

		printf "============================\n==> End build \"$VERSION-${VARIANT}\" <==\n============================\n\n";

		# if build fail : exit
		if [[ ${BUILD_SUCCESS} -ne 0 ]] ; then
			printf "Error : Unable to build version \"${VERSION}-${VARIANT}\"\n";
			exit -1;
		fi
	done
done