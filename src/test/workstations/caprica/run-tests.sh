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
BOX_USER="seb"

case $HOSTNAME in
  ("caprica") echo -e "$LOG_INFO Run tests on machine '$HOSTNAME'";;
  ("kobol")   echo -e "$LOG_INFO Run tests on machine '$HOSTNAME'";;
  (*)         echo -e "$LOG_ERROR Script not running on expected machine!!!" && exit;;
esac


# @description Utility function to wrap inspec in Docker container. Calling this function avoids multiple ``docker run``
# commands. The container uses the SSH setup and the git installation from the host.
function inspec() {
  if [ "$1" == "check" ]; then
    docker run -it --rm \
      --volume "$(pwd):$(pwd)" \
      --workdir "$(pwd)" \
      chef/inspec:latest "$@" --chef-license=accept
  else
    docker run -it --rm \
      --volume "$HOME/.ssh:/root/.ssh:ro" \
      --volume "$SSH_AUTH_SOCK:$SSH_AUTH_SOCK" \
      --volume "$(pwd):$(pwd)" \
      --workdir "$(pwd)" \
      --network host \
      chef/inspec:latest "$@" --target=ssh://"$BOX_USER@$BOX_IP" --key-files=/root/.ssh/id_rsa --chef-license=accept
  fi
}


# @description Step 1: Validate the Vagrantfile and InSpec profile and prepare startup.
function prepare() {
  echo -e "$LOG_INFO Validate Vagrantfile"
  vagrant validate

  (
    cd ../../../../ || exit

    echo -e "$LOG_INFO Validate yaml"
    docker run -it --rm --volume "$(pwd):/data" --workdir "/data" cytopia/yamllint:latest src/main/workstations/caprica/provision/ansible-playbook.yml
  )

  echo -e "$LOG_INFO Validate inspec profiles"
  inspec check inspec-profiles/caprica-test
  inspec check inspec-profiles/baseline
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
  echo -e "$LOG_INFO IP = $BOX_IP"
}


# @description Step 3: Print some information about the virtual environment.
function info() {
  echo && docker run --rm mwendler/figlet:latest "Info" && echo

  echo -e "$LOG_INFO Show remote user"
  vagrant ssh -c 'whoami'
}


# @description Step 4: Run tests to check the correct setup of the Vagrantbox.
function test() {
  echo && docker run --rm mwendler/figlet:latest "Test" && echo

  echo -e "$LOG_INFO Run inspec profiles"
  inspec exec inspec-profiles/caprica-test
  inspec exec inspec-profiles/baseline

  echo -e "$LOG_INFO List ssh keys for user $BOX_USER"
  vagrant ssh -c "ls -alF /home/$BOX_USER/.ssh"

  echo -e "$LOG_INFO Test Docker installation"
  vagrant ssh -c "docker run --rm hello-world:latest"

  echo -e "$LOG_INFO Test git: clone repository from github via SSH"
  vagrant ssh -c "(cd repos && git clone https://github.com/sebastian-sommerfeld-io/playgrounds.git)" # todo ... ssh
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

  echo -e "$LOG_INFO Read password from playbook and write to adoc"
  (
    cd ../../../../ || exit

    playbook="src/main/workstations/caprica/provision/ansible-playbook.yml"
    adoc="docs/modules/ROOT/partials/generated/ansible/caprica-vars.adoc"

    default_username=$(docker run --rm \
      --volume "$(pwd):$(pwd)" \
      --workdir "$(pwd)" \
      sommerfeldio/yq:latest yq eval '.[] | select(.name).vars.[] | select(.default_username).[]' $playbook)

    default_password=$(docker run --rm \
      --volume "$(pwd):$(pwd)" \
      --workdir "$(pwd)" \
      sommerfeldio/yq:latest yq eval '.[] | select(.name).vars.[] | select(.default_password).[]' $playbook)

    rm "$adoc"
    (
      echo ":user: $default_username"
      echo ":pass: $default_password"
    ) > "$adoc"
  )

}


echo -e "$LOG_INFO Run tests from $P$(pwd)$D"
prepare
startup
info
test
shutdown
