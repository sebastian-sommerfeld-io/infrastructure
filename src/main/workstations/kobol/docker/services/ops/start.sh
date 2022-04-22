#!/bin/bash
# @file start.sh
# @brief Start the Docker Compose ops stack.
#
# @description The script starts the Docker Compose ops stack.
#
# ==== Arguments
#
# The script does not accept any parameters.


echo -e "$LOG_INFO Startup ops stack"
docker-compose up -d
