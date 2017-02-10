#!/usr/bin/env bash

# Go to script directory
dir=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
cd $dir

# For all versions : launch build
for version in 5.6-cli 5.6-fpm 7-cli 7-fpm; do
	# launch build
	bash $dir/build-image.sh $version

	# if build fail : exit
	if [[ $BUILD_SUCCESS -ne 0 ]] ; then
		printf "Error : Unable to build version \"$version\"\n";
		exit -1;
	fi
done