#!/usr/bin/env bash
set -xe

# Configure
/bin/bash docker-php-configure

# Give rights for cache & logs (sf1 & sf2 & sf3)
if [ -d cache ]; then chmod -R 777 cache; fi
if [ -d app/cache ]; then chmod -R 777 app/cache; fi
if [ -d var/cache ]; then chmod -R 777 var/cache; fi
if [ -d log ]; then chmod -R 777 log; fi
if [ -d app/logs ]; then chmod -R 777 app/logs; fi
if [ -d var/logs ]; then chmod -R 777 var/logs; fi

# Launch
if [ "$#" -ge 1 ]; then
    exec "$@"
else
    # Infinite loop
    /bin/bash -c "trap : TERM INT; sleep infinity & wait"
fi

