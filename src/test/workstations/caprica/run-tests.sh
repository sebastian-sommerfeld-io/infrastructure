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


BOX_IP=""

case $HOSTNAME in
  ("caprica") echo -e "$LOG_INFO Run tests on machine '$HOSTNAME'";;
  ("kobol")   echo -e "$LOG_INFO Run tests on machine '$HOSTNAME'";;
  (*)         echo -e "$LOG_ERROR Script not running on expected machine!!!" && exit;;
esac


# @description Step 1: Validate the Vagrantfile and InSpec profile and prepare startup.
function prepare() {
  echo -e "$LOG_INFO Validate Vagrantfile"
  vagrant validate

  echo -e "$LOG_INFO Validate inspec profile"
  docker run -it --rm \
    --volume "$(pwd):$(pwd)" \
    --workdir "$(pwd)" \
    chef/inspec:latest check inspec-profiles/caprica-test --chef-license=accept
  
  echo -e "$LOG_INFO Validate inspec profile"
  docker run -it --rm \
    --volume "$(pwd):$(pwd)" \
    --workdir "$(pwd)" \
    chef/inspec:latest check inspec-profiles/baseline --chef-license=accept
}


# @description Step 2: Startup and provision the Vagrantbox (provisioning is a Vagrant feature). Show the SSH config of
# the Vagrantbox as well.
function startup() {
  echo && docker run --rm mwendler/figlet:latest "Startup" && echo

  echo -e "$LOG_INFO Create and startup Vagrantbox"
  vagrant up

  echo -e "$LOG_INFO SSH config for this Vagrantbox"
  vagrant ssh-config

  echo -e "$LOG_INFO Read IP address from vagrantbox"
  tmp=$(vagrant ssh -c "hostname -I | cut -d' ' -f2" 2>/dev/null)
  BOX_IP=$(echo "$tmp" | sed 's/\r$//') # remove \r from end of string
  echo -e "$LOG_INFO IP = $P$BOX_IP$D"
}


# @description Step 3: Print some information about the virtual environment.
function info() {
  echo && docker run --rm mwendler/figlet:latest "Info" && echo

  echo -e "$LOG_INFO Show remote user"
  echo -e "$P$(vagrant ssh -c 'whoami')$D"
}


# @description Step 4: Validate the installation by running Chef InSpec tests.
function validate() {
  echo && docker run --rm mwendler/figlet:latest "Validate" && echo

  echo -e "$LOG_INFO Run inspec profile"
  docker run -it --rm \
    --volume "$HOME/.ssh:/root/.ssh:ro" \
    --volume "$SSH_AUTH_SOCK:$SSH_AUTH_SOCK" \
    --volume "$(pwd):$(pwd)" \
    --workdir "$(pwd)" \
    --network host \
    chef/inspec:latest exec inspec-profiles/caprica-test --target="ssh://starbuck@$BOX_IP" --key-files="/root/.ssh/id_rsa" --chef-license=accept

  echo -e "$LOG_INFO Run inspec profile"
  docker run -it --rm \
    --volume "$HOME/.ssh:/root/.ssh:ro" \
    --volume "$SSH_AUTH_SOCK:$SSH_AUTH_SOCK" \
    --volume "$(pwd):$(pwd)" \
    --workdir "$(pwd)" \
    --network host \
    chef/inspec:latest exec inspec-profiles/baseline --target="ssh://starbuck@$BOX_IP" --key-files="/root/.ssh/id_rsa" --chef-license=accept

  # echo -e "$LOG_INFO Run inspec linux baseline"
  # docker run -it --rm \
  #   --volume "$HOME/.ssh:/root/.ssh:ro" \
  #   --volume "$SSH_AUTH_SOCK:$SSH_AUTH_SOCK" \
  #   --volume "$(pwd):$(pwd)" \
  #   --workdir "$(pwd)" \
  #   --network host \
  #   chef/inspec:latest exec https://github.com/dev-sec/linux-baseline --target="ssh://starbuck@$BOX_IP" --key-files="/root/.ssh/id_rsa" --chef-license=accept
}


# @description Step 5: Run tests to check the correct setup of the Vagrantbox.
function test() {
  echo && docker run --rm mwendler/figlet:latest "Test" && echo
  echo -e "$LOG_INFO Test Docker installation"
  echo -e "$P"
  vagrant ssh -c "docker run --rm hello-world:latest"
  echo -e "$D"

  echo -e "$LOG_INFO Test git: clone repository from github via SSH"
  echo -e "$P"
  vagrant ssh -c "(cd repos && git clone https://github.com/sebastian-sommerfeld-io/playgrounds.git)"
  echo -e "$D"
}


# @description Step 6: Shutdown and destroy the Vagrantbox and cleanup the local filesystem.
function shutdown() {
  echo && docker run --rm mwendler/figlet:latest "Shutdown" && echo

  echo -e "$LOG_INFO Shutdown Vagrantbox"
  vagrant halt

  echo -e "$LOG_INFO Remove Vagrantbox and cleanup filesystem"
  vagrant destroy -f
  rm -rf .vagrant
  rm -rf ./*.log
}


echo -e "$LOG_INFO Run tests from $P$(pwd)$D"
prepare
startup
info
validate
test
shutdown
