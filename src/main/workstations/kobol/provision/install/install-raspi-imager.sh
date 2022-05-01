#!/bin/bash
# @file install-raspi-imager.sh
# @brief Install Raspi Imager.
#
# @description The script installs Raspberry Pi Imager.
#
# ==== Arguments
#
# The script does not accept any parameters.


echo -e "$LOG_INFO Install Raspi Imager"
sudo apt-get update
sudo apt-get install -y rpi-imager
echo -e "$LOG_DONE Installed Raspi Imager"
