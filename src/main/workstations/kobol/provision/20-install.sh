#!/bin/bash
# @file 20-install.sh
# @brief Install software and tools and remove some unnecessary applications that are shipped with
# ubuntu.
#
# @description The script installs software and tools and removes some unnecessary applications that are shipped with
# ubuntu. The actual installations are delegated to dedicated install scripts. This script provides a way to install
# all packages in the correct order.
#
# ==== Arguments
#
# The script does not accept any parameters.


bash install/update-upgrade.sh
bash install/install-basics.sh
bash install/install-conky.sh
bash install/install-desktop-software.sh
bash install/install-docker.sh
bash install/install-etcher.sh
bash install/install-git.sh
bash install/install-java.sh
bash install/install-postman.sh
bash install/install-raspi-imager.sh
bash install/install-slack.sh
bash install/install-ssh-server.sh
bash install/install-sublime.sh
bash install/install-virtualbox.sh
bash install/install-vagrant.sh
bash install/remove-software.sh

echo -e "$LOG_DONE Software installations finished"
echo -e "$LOG_WARN Docker privileges become effective after restart!"
