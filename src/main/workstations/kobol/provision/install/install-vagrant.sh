#!/bin/bash
# @file install-vagrant.sh
# @brief Install Vagrant with plugins and Packer.
#
# @description The script installs link:https://www.vagrantup.com[Vagrant] with plugins and link:https://www.packer.io[Packer].
#
# * Plugin: link:https://github.com/fgrehm/vagrant-cachier[vagrant-cachier]
# * Plugin: link:https://github.com/dotless-de/vagrant-vbguest[vagrant-vbguest]
#
# Packer is used to create identical machine images for multiple platforms from single source configuration.
#
# ==== Arguments
#
# The script does not accept any parameters.


echo -e "$LOG_INFO Install vagrant"
sudo apt-get install -y vagrant

echo -e "$LOG_INFO Install vagrant plugins"
vagrant plugin install vagrant-cachier
vagrant plugin install vagrant-vbguest
vagrant plugin install vagrant-docker-compose

echo -e "$LOG_INFO Install packer"
sudo apt-get install -y packer
echo -e "$LOG_DONE Installed vagrant"
