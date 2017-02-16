#!/usr/bin/env bash
set -xe

# Configure
/bin/bash docker-php-configure

# Infinite loop
/bin/bash -c "trap : TERM INT; sleep infinity & wait"
