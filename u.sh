#!/bin/bash

source build/envsetup.sh
config_value=$(head -n 1 docker/config)
lunch $config_value
emulator "$@"
