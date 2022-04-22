#!/bin/bash
# @file update-upgrade.sh
# @brief Update apt repository cache and upgrade packages.
#
# @description The script updates apt repository cache and upgrades packages.
#
# ==== Arguments
#
# The script does not accept any parameters.


echo -e "$LOG_INFO Run update + upgrade"
sudo apt-get -y update
sudo apt-get -y upgrade
echo -e "$LOG_DONE Finished update + upgrade"
