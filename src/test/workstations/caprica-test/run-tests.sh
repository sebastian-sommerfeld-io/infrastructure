#!/bin/bash
# @file run-tests.sh
# @brief Test the setup for machine "caprica" inside Vagrantbox "caprica-test".
#
# @description This script tests the setup for the machine "caprica". To test the setup and provisioning steps, this
# script creates and starts the Vagrantbox "caprica-test" and runs all scripts and playbooks inside this Vagrantbox.
#
# ==== Arguments
#
# The script does not accept any parameters.


echo && docker run --rm mwendler/figlet:latest "Test: Provisioning" && echo

echo -e "$LOG_INFO Create and startup Vagrantbox"
vagrant up

echo -e "$LOG_INFO Shutdown Vagrantbox"
vagrant halt

echo -e "$LOG_INFO Remove Vagrantbox and  cleanup filesystem"
vagrant destroy -f
rm -rf .vagrant
