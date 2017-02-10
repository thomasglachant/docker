#!/usr/bin/env bash

# Script directory
dir=$(cd -P -- "$(dirname -- "$0")" && pwd -P)/$1

# Version dir does not exist
if [[ ! -d $dir ]]; then
	printf "Error : Version \"$version\" does not exist\n";
	exit -1;
fi

# Go to dir
cd "$dir/$version"

printf "============================\n==> Start build \"$version\" <==\n============================\n";

# Build image
docker build -t thomasglachant/docker-php:php$version .

# get build return code 
BUILD_SUCCESS=$?

printf "============================\n==> End build \"$version\" <==\n============================\n\n\n";

# if build fail : exit
if [[ $BUILD_SUCCESS -ne 0 ]] ; then
	printf "Error : Unable to build version \"$version\"\n";
	exit -1;
fi