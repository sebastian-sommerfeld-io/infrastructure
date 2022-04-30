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


echo -e "$LOG_INFO Purge any previous vagrant installation"
sudo apt-get purge -y vagrant
sudo dpkg --remove vagrant

echo -e "$LOG_INFO Install vagrant"
#curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
#sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
#sudo apt-get update
#sudo apt-get install -y vagrant

#curl https://releases.hashicorp.com/vagrant/2.2.19/vagrant_2.2.19_i686.deb --output vagrant.deb
curl https://releases.hashicorp.com/vagrant/2.2.19/vagrant_2.2.19_x86_64.deb --output vagrant.deb
sudo dpkg -i vagrant.deb
rm vagrant.deb

echo -e "$LOG_INFO $(vagrant --version)"

echo -e "$LOG_INFO Install vagrant plugins"
vagrant plugin install vagrant-cachier
vagrant plugin install vagrant-vbguest
vagrant plugin install vagrant-docker-compose

#echo -e "$LOG_INFO Install packer"
#sudo apt-get install -y packer
#echo -e "$LOG_DONE Installed vagrant"
