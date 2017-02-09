#!/bin/sh
set -e

if [ $PHP_XDEBUG_ENABLED -eq 1 ] ; then sed -e "s/\;zend_extension/zend_extension/" -i /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini ; else sed -e "s/^zend_extension/\;zend_extension/" -i /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini ; fi
echo 'xdebug.default_enable = '"$PHP_XDEBUG_ENABLED"'' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
echo 'xdebug.remote_enable = '"$PHP_XDEBUG_ENABLED"'' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
echo 'xdebug.remote_host = '"$PHP_XDEBUG_HOST"'' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
echo 'xdebug.remote_port = '"$PHP_XDEBUG_PORT"'' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
echo 'xdebug.remote_handler = dbgp' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
echo 'xdebug.remote_autostart = '"$PHP_XDEBUG_ENABLED"'' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
echo 'xdebug.max_nesting_level = '"$PHP_XDEBUG_MAX_NESTING_LEVEL"'' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
echo 'xdebug.idekey = '"$PHP_XDEBUG_IDEKEY"'' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

exec "docker-php-entrypoint $@"