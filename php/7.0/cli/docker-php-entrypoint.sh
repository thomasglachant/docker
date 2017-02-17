#!/usr/bin/env bash
set -xe

# Configure
/bin/bash docker-php-configure

# Give rights for cache & logs (sf1 & sf2)
if [ -d cache ]; then rm -rf cache/*; chmod -R 777 cache; fi
if [ -d app/cache ]; then rm -rf app/cache/*; chmod -R 777 app/cache; fi
if [ -d log ]; then chmod -R 777 log; fi
if [ -d app/logs ]; then chmod -R 777 app/logs; fi

# Infinite loop
/bin/bash -c "trap : TERM INT; sleep infinity & wait"
