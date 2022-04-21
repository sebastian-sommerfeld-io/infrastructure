#!/bin/bash
# @file java.sh
# @brief Install Java.
#
# @description The script installs Java.
#
# IMPORTANT: DON'T RUN THIS SCRIPT DIRECTLY - Script is invoked by Vagrant during link:https://www.vagrantup.com/docs/provisioning[provisioning].
#
# ==== Arguments
#
# The script does not accept any parameters.


echo "[INFO] Install Java"
sudo apt-get install -y openjdk-17-jdk
echo "[DONE] Installed Java"
