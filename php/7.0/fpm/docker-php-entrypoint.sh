#!/bin/sh
set -xe

# Configure
/bin/bash docker-php-configure

# Give rights for cache & logs (sf1 & sf2 & sf3)
chown -R www-data var app/cache app/logs cache log || true

# Launch php fpm
exec php-fpm
