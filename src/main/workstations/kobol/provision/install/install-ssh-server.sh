#!/bin/bash
# @file install-ssh-server.sh
# @brief Install and start SSH server.
#
# @description The script installs and starts a SSH server.
#
# ==== Arguments
#
# The script does not accept any parameters.


echo -e "$LOG_INFO Install and start SSH server"
sudo apt-get -y update
sudo apt-get install -y openssh-server
sudo ufw allow ssh # if the firewall is enabled on your system open the ssh port
sudo systemctl enable --now ssh
echo -e "$LOG_INFO Installed and started SSH server"
