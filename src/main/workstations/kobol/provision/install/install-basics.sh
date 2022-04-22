#!/bin/bash
# @file install-basic-tools.sh
# @brief Install basic tools.
#
# @description The script installs basic software tools.
#
# * curl
# * htop
# * ncdu
# * neofetch
# * net-tools
# * tilix
# * v4l-utils -> list webcams via `v4l2-ctl --list-devices`
#
# ==== Arguments
#
# The script does not accept any parameters.


echo -e "$LOG_INFO Allow apt to use a repository over HTTPS"
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
echo -e "$LOG_DONE Installed prerequisites"

echo -e "$LOG_INFO Install basic tools"
sudo apt-get install -y ncdu
sudo apt-get install -y htop
sudo apt-get install -y curl
sudo apt-get install -y neofetch
sudo apt-get install -y net-tools
sudo apt-get install -y v4l-utils # list webcams via `v4l2-ctl --list-devices`
sudo apt-get install -y tilix
echo -e "$LOG_DONE Installed basic tools"
