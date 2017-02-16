#!/bin/sh
set -xe

# Configure
/bin/bash docker-php-configure

# Launch
# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php-fpm "$@"
fi

exec "$@"
