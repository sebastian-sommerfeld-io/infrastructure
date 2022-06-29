#!/bin/bash
# @file install-ansible.sh
# @brief Install ansible.
#
# @description The script installs ansible.
#
# ==== Arguments
#
# The script does not accept any parameters.


echo -e "$LOG_INFO Install ansible"
sudo apt-get update
sudo apt-get install -y ansible

