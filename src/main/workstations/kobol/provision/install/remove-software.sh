#!/bin/bash
# @file remove-software.sh
# @brief Remove some unnecessary applications that are shipped with ubuntu.
#
# @description The script remove some unnecessary applications that are shipped with ubuntu.
#
# * thunderbird
# * rhythmbox
# * libreoffice
# * totem
# * apache2
# * remmina
#
# ==== Arguments
#
# The script does not accept any parameters.


echo -e "$LOG_INFO Uninstall obsolete software"
sudo apt-get purge -y thunderbird
sudo apt-get purge -y rhythmbox
sudo apt-get purge -y libreoffice*
sudo apt-get purge -y totem*
sudo apt-get purge -y apache2*
sudo apt-get purge -y remmina*
sudo apt-get -y clean
sudo apt-get -y autoremove
echo -e "$LOG_DONE Uninstalled obsolete software"
