#!/bin/bash
# @file install-raspi-imager.sh
# @brief Install Raspi Imager.
#
# @description The script installs Raspi Imager.
#
# ==== Arguments
#
# The script does not accept any parameters.


echo -e "$LOG_INFO Install Raspi Imager"
curl -L https://downloads.raspberrypi.org/imager/imager_latest_amd64.deb --output raspi-imager.deb
sudo apt-get install -y ./raspi-imager.deb
rm raspi-imager.deb
echo -e "$LOG_DONE Installed Raspi Imager"
