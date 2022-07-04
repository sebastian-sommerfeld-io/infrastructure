#!/bin/bash
# @file run-tests.sh
# @brief Test the setup for machine "caprica" inside Vagrantbox "caprica-test".
#
# @description This script tests the setup for the machine "caprica". To test the setup and provisioning steps, this
# script creates and starts the Vagrantbox "caprica-test" and runs all scripts and playbooks inside this Vagrantbox.
#
# IMPORTANT: This script must run on a physical machine directly. Running inside a Vagrantbox does not work because the
# Vagrantboxes don't come with VirtualBox and Vagrant (which are needed because the ansible playbook is tested inside a
# Vagrantbox).
#
# ==== Arguments
#
# The script does not accept any parameters.


case $HOSTNAME in
  ("caprica") echo -e "$LOG_INFO Run tests on machine '$HOSTNAME'";;
  ("kobol")   echo -e "$LOG_INFO Run tests on machine '$HOSTNAME'";;
  (*)         echo -e "$LOG_ERROR Script not running on expected machine!!!" && exit;;
esac


# @description Step 1: Validate the Vagrantfile and prepare the Vagrantbox startup.
function prepare() {
  echo -e "$LOG_INFO Validate Vagrantfile"
  vagrant validate
}


# @description Step 2: Startup and provision the Vagrantbox (provisioning is a Vagrant feature). Show the SSH config of
# the Vagrantbox as well.
function startup() {
  echo && docker run --rm mwendler/figlet:latest "Startup" && echo

  echo -e "$LOG_INFO Create and startup Vagrantbox"
  vagrant up

  echo -e "$LOG_INFO S config for this Vagrantbox"
  vagrant ssh-config
}


# @description Step 3: Validate the installation by running Chef InSpec tests.
function validate() {
  echo && docker run --rm mwendler/figlet:latest "Validate" && echo
  # todo ... chef inspec -> validate same stuff as with real caprica machine
}


# @description Step 4: Run tests to check the correct setup of the Vagrantbox.
function test() {
  echo && docker run --rm mwendler/figlet:latest "Test" && echo
  echo -e "$LOG_INFO Test Docker installation"
  echo -e "$P"
  vagrant ssh -c "docker run --rm hello-world:latest"
  echo -e "$D"

  echo -e "$LOG_INFO Test git: clone repository from github via SSH"
  echo -e "$P"
  vagrant ssh -c "(cd repos && git clone https://github.com/sebastian-sommerfeld-io/playgrounds.git)" # todo ... clone via ssh
  echo -e "$D"

  echo -e "$LOG_INFO Test Virtualbox and Vagrant"
  echo -e "$P"
  vagrant ssh -c "vagrant --version"
  vagrant ssh -c "vboxmanage --version"
  vagrant ssh -c "vboxmanage list systemproperties | grep folder"
  echo -e "$D"
}


# @description Step 5: Shutdown and destroy the Vagrantbox and cleanup the local filesystem.
function shutdown() {
  echo && docker run --rm mwendler/figlet:latest "Shutdown" && echo

  echo -e "$LOG_INFO Shutdown Vagrantbox"
  vagrant halt

  echo -e "$LOG_INFO Remove Vagrantbox and cleanup filesystem"
  vagrant destroy -f
  rm -rf .vagrant
  rm -rf ./*.log
}


echo -e "$LOG_INFO Run tests for$P caprica-test$D"
prepare
startup
validate
test
#shutdown
