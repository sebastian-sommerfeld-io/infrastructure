#!/bin/bash
# @file stop.sh
# @brief Stop the Docker Compose ops stack.
#
# @description The script stops the Docker Compose ops stack.
#
# ==== Arguments
#
# The script does not accept any parameters.


echo -e "$LOG_INFO Shutdown ops stack"
docker-compose down -v
