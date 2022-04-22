#!/bin/bash
# @file install-virtualbox.sh
# @brief Install virtualbox.
#
# @description The script installs virtualbox and sets the default machine folder to ``$HOME/work/virtualbox-machines``.
#
# ==== Arguments
#
# The script does not accept any parameters.


VM_DIR="$HOME/virtualmachines"

echo -e "$LOG_INFO Install virtualbox"
sudo apt-get install -y virtualbox virtualbox-qt virtualbox-dkms

echo -e "$LOG_INFO Set default machine folder for Virtualbox VMs to $VM_DIR"
vboxmanage setproperty machinefolder "$VM_DIR"
vboxmanage list systemproperties | grep folder

echo -e "$LOG_DONE Installed virtualbox"
