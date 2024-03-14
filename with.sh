#!/bin/bash

source build/envsetup.sh
config_value=$(head -n 1 config)
lunch $config_value
m
