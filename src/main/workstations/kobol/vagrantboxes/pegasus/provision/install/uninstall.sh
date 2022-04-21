#!/bin/bash
# @file uninstall.sh
# @brief Uninstall some software shipped with the Base-Vagrantbox.
#
# @description The script uninstalls some software shipped with the Base-Vagrantbox (Ubuntu).
#
# IMPORTANT: DON'T RUN THIS SCRIPT DIRECTLY - Script is invoked by Vagrant during link:https://www.vagrantup.com/docs/provisioning[provisioning].
#
# ==== Arguments
#
# The script does not accept any parameters.


echo "[INFO] Uninstall"
sudo apt-get purge -y git
sudo apt-get -y clean
sudo apt-get -y autoremove

echo "[DONE] Finished uninstall"
