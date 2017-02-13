#!/usr/bin/env bash

# Docker image basename (on dockerhub)
DOCKER_IMAGE_BASENAME="thomasglachant/docker"

###############
# SCRIPT VARS #
###############
GLOBAL_START_TIMESTAMP=$(date +'%s') # Start timestamp
SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" # Script absolute path
COMMAND_STDOUT="/dev/stdout" # Classical output
COMMAND_STDERR="/dev/stderr" # Error output
ERRORS= # errors messages

#############
#    HELP   #
#############
if [[ $1 == "help" ]]; then
printf "This script will build docker images.

Arguments :
  help         Print this
  --with-push  Push images to dockerhub (you need to login with \"docker login\")
  -q           Quiet mode

Example :
  ./build-all-images.sh --with-push
"
exit 0;
fi

#############
# ARGUMENTS #
#############
WITH_PUSH=  # Push images to dockerhub
VERBOSE=1    # Enable verbose mode

# Read arguments form command line
for ARG in $@; do
	if [[ $ARG == "--with-push" ]] ; then
		WITH_PUSH=1
	elif [[ $ARG == "-q" ]] ; then
		VERBOSE=
	else 
		printf "Error : Unknown argument \"$ARG\".\n"
		exit 3;
	fi
done

# If with_push is true : check if user logged in docker
if [[ ${WITH_PUSH} ]] && [[ `docker info | grep "Username" | wc -l` -ne 1 ]] ; then
	printf "Error : You must be connected to docker to push images.\nYou can use \"docker login\" command for login.\n"
	exit 2;
fi

# Quiet mode : redirect output to null
if [[ ! "${VERBOSE}" ]]; then
	COMMAND_STDOUT="/dev/null"
	COMMAND_STDERR="/dev/null"
fi

##############
#    BUILD   #
##############
# For every dockerfile in the repository
for DOCKERFILE in `find ${SCRIPTPATH} -type f -name "Dockerfile"`; do
	JOB_START_TIMESTAMP=$(date +'%s') # Job's start timestamp
	JOB_ERRORS= # reset job error var

	# Get relative path for the dockerfile's folder
	DOCKERFILE_PATH="${DOCKERFILE:`echo $SCRIPTPATH|wc -c`:$((`echo $DOCKERFILE|wc -c`-`echo $SCRIPTPATH|wc -c`-`echo /Dockerfile|wc -c`))}"
	
	# Read app informations for dockerfile location
	APP=`echo $DOCKERFILE_PATH | cut -d"/" -f1`
	APP_VERSION=`echo $DOCKERFILE_PATH | cut -d"/" -f2`
	APP_VARIANT=`echo $DOCKERFILE_PATH | cut -d"/" -f3`
	TAG="${APP}${APP_VERSION:+$APP_VERSION}${APP_VARIANT:+-$APP_VARIANT}"
	IMAGE="${DOCKER_IMAGE_BASENAME}:${TAG}"

	# Build image
	printf "Build \"${TAG}\" ... ${VERBOSE:+\n}"
	docker build -t ${IMAGE} ${DOCKERFILE_PATH} >> ${COMMAND_STDOUT} 2>> ${COMMAND_STDERR}

	# if build works
	if [[ $? -eq 0 ]] ; then
		# Push image (if required)
		if [[ "${WITH_PUSH}" ]] ; then
			docker push ${IMAGE} >> ${COMMAND_STDOUT} 2>> ${COMMAND_STDERR}

			if [[ $? -ne 0 ]]; then
				JOB_ERRORS="${JOB_ERRORS:+$JOB_ERRORS, }push error\n"
			fi
		fi

	# if build failed
	else
		# add error message
		JOB_ERRORS="${JOB_ERRORS:+$JOB_ERRORS, }build error\n"
	fi

	if [[ "${JOB_ERRORS}" ]]; then
		printf "KO\n"
		ERRORS="${ERRORS}- \"${TAG}\" : ${JOB_ERRORS}"
	else
		printf "${VERBOSE:+Build }OK ($(($(date +'%s') - ${JOB_START_TIMESTAMP})) seconds)\n"
	fi
done

############
#  Summary #
############
printf "\nExecuted in $(($(date +'%s') - $GLOBAL_START_TIMESTAMP)) seconds\n"
if [[ "${ERRORS}" ]] ; then
	printf "\nScript returns errors : \n${ERRORS}"
	# An error as occured : return error code
	exit 1
fi

# All is allright
exit 0
