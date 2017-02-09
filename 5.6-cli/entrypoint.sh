#!/usr/bin/env bash

# Infinite loop
/bin/bash -c "trap : TERM INT; sleep infinity & wait"