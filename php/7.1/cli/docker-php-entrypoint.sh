#!/usr/bin/env bash
set -xe

# Configure
/bin/bash docker-php-configure

# Give rights for cache & logs (sf1 & sf2 & sf3)
chown -R www-data:www-data var var/cache var/logs var/sessions app/cache app/logs cache log || true

# Launch
if [ "$#" -ge 1 ]; then
    exec "$@"
else
    # Infinite loop
    /bin/bash -c "trap : TERM INT; sleep infinity & wait"
fi

