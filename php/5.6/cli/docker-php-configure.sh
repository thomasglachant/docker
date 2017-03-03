#!/bin/sh
set -xe

export DOCKER_BRIDGE_IP=$(ip ro | grep default | cut -d' ' -f 3)

# Xdebug
if [ ${PHP_XDEBUG_ENABLED} -eq 1 ] ; then
if [ ! ${PHP_XDEBUG_HOST} ]; then
    PHP_XDEBUG_HOST=${DOCKER_BRIDGE_IP}
fi
printf "
zend_extension=xdebug.so
xdebug.default_enable = $PHP_XDEBUG_ENABLED\n
xdebug.remote_enable = $PHP_XDEBUG_ENABLED\n
xdebug.remote_host = $PHP_XDEBUG_HOST\n
xdebug.remote_port = $PHP_XDEBUG_PORT\n
xdebug.remote_handler = dbgp\n
xdebug.remote_autostart = $PHP_XDEBUG_ENABLED\n
xdebug.max_nesting_level = $PHP_XDEBUG_MAX_NESTING_LEVEL\n
xdebug.idekey = $PHP_XDEBUG_IDEKEY
" > /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
else
printf "
;zend_extension=xdebug.so
" > /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
fi
