#!/bin/bash
# @file ssh-keys.sh
# @brief Provisioning script for Vagrantbox pegasus.
#
# @description The scripts create some ssh-keys to use with Vagrantbox ``pegasus`` for user ``vagrant``
#
# IMPORTANT: DON'T RUN THIS SCRIPT DIRECTLY - Script is invoked by Vagrant during link:https://www.vagrantup.com/docs/provisioning[provisioning].
#
# ==== Arguments
#
# The script does not accept any parameters.

DIR="/home/vagrant/.ssh"
KEY="id_rsa"

echo "[INFO] Create $DIR/$KEY"
ssh-keygen -m PEM -t rsa -b 4096 -N "" -C "sebastian@sommerfeld.io" -f "$DIR/$KEY"
echo "[DONE] Finished ssh key setup"
