#!/bin/bash
# @file install-java.sh
# @brief Install OpenJDK 16 and download JDK 17 and extract into ``$HOME/work/tools/sdk-and-runtime``.
#
# @description The script installs OpenJDK 16 and downloads JDK 17 and extract into ``$HOME/work/tools/sdk-and-runtime``.
#
# ==== Arguments
#
# The script does not accept any parameters.


echo -e "$LOG_INFO Install java"
sudo apt-get install -y openjdk-16-jre
echo -e "$LOG_DONE Installed java"
