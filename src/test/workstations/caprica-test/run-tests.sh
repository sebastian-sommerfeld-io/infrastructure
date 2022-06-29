#!/bin/bash
# @file run-tests.sh
# @brief Test the setup for machine "caprica" inside Vagrantbox "caprica-test".
#
# @description This script tests the setup for the machine "caprica". To test the setup and provisioning steps, this
# script creates and starts the Vagrantbox "caprica-test" and runs all scripts and playbooks inside this Vagrantbox.
#
# IMPORTANT: This script must run on a physical machine directly. Running inside a Vagrantbox does not work because the
# Vagrantboxes don't come with VirtualBox and Vagrant (which are nedded because ansible playbook is tested inside a
# Vagrantbox).
#
# ==== Arguments
#
# The script does not accept any parameters.


case $HOSTNAME in
  ("caprica") echo -e "$LOG_INFO Run tests on machine '$HOSTNAME'";;
  ("kobol")   echo -e "$LOG_INFO Run tests on machine '$HOSTNAME'";;
  (*)         echo -e "$LOG_ERROR Script not running on expected machine!!! Run on 'kobol' only!!!" && exit;;
esac


echo -e "$LOG_INFO Run tests for$P caprica-test$D"
echo && docker run --rm mwendler/figlet:latest "Test: Provisioning" && echo

echo -e "$LOG_INFO Create and startup Vagrantbox"
vagrant up

echo && docker run --rm mwendler/figlet:latest "Validate" && echo

echo -e "$LOG_INFO Test Docker installation"
echo -e "$P"
vagrant ssh -c "docker run --rm hello-world:latest"
echo -e "$D"

# todo ... chef inspec -> validate same stuff as with real caprica machine

echo && docker run --rm mwendler/figlet:latest "Shutdown" && echo

echo -e "$LOG_INFO Shutdown Vagrantbox"
vagrant halt

echo -e "$LOG_INFO Remove Vagrantbox and cleanup filesystem"
vagrant destroy -f
rm -rf .vagrant
