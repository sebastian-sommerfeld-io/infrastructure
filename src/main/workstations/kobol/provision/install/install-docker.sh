#!/bin/bash
# @file install-docker.sh
# @brief Install docker and docker-compose.
#
# @description The script installs docker and docker-compose.
#
# ==== Arguments
#
# The script does not accept any parameters.


echo -e "$LOG_INFO Install docker"
sudo apt-get install -y docker.io
sudo apt-get install -y docker-compose
#sudo groupadd docker
sudo usermod -aG docker "$USER"
#newgrp docker
echo -e "$LOG_DONE Installed docker"
