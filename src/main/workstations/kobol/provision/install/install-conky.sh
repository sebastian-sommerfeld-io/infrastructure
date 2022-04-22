#!/bin/bash
# @file install-conky.sh
# @brief Install conky.
#
# @description The script installs conky.
#
# ==== Arguments
#
# The script does not accept any parameters.

echo -e "$LOG_INFO Install conky"
sudo apt-get install -y conky-all
echo -e "$LOG_DONE Installed conky"
