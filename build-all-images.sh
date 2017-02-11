#!/usr/bin/env bash

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ERRORED=0
SUMMARY=""

GLOBAL_START=$(date +'%s')

for DOCKERFILE in `find $SCRIPTPATH -type f -name "Dockerfile"`; do
	DOCKERFILE_START=$(date +'%s')

	# Get relative path for the dockerfile's folder
	DOCKERFILE_PATH=${DOCKERFILE:`echo $SCRIPTPATH|wc -c`:$((`echo $DOCKERFILE|wc -c`-`echo $SCRIPTPATH|wc -c`-`echo /Dockerfile|wc -c`))}
	
	APP=`echo $DOCKERFILE_PATH | cut -d"/" -f1`
	APP_VERSION=`echo $DOCKERFILE_PATH | cut -d"/" -f2`
	APP_VARIANT=`echo $DOCKERFILE_PATH | cut -d"/" -f3`

	IMAGE="thomasglachant/docker:${APP}${APP_VERSION:+$APP_VERSION}${APP_VARIANT:+-$APP_VARIANT}"

	printf "\n============================\n${IMAGE}\n============================\n";

	# Build image
	docker build -t ${IMAGE} ${DOCKERFILE_PATH}

	# test build return code to check if build failed
	if [[ $? -eq 0 ]] ; then
		SUMMARY="${SUMMARY}${IMAGE} : OK ($(($(date +'%s') - $DOCKERFILE_START)) seconds)\n";
	# if build failed
	else
		ERRORED=1
		SUMMARY="${SUMMARY}${IMAGE} : Error !\n";
	fi
done

# Display summary
printf "\n\nSUMMARY\n=======\n$SUMMARY\nTotal : $(($(date +'%s') - $GLOBAL_START)) seconds\n"

# An error as occured : return error code
if [[ ${ERRORED} -eq 1 ]]; then
	exit 1
fi

# No error 
exit 0
