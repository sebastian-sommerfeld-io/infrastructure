#!/bin/bash
# @file run.sh
# @brief Run Ansible playbooks for Raspberry Pi nodes.
#
# @description This script runs Ansible playbooks for Raspberry Pi nodes. Ansible runs in Docker.
#
# ==== Arguments
#
# The script does not accept any parameters.


# @description Wrapper function to encapsulate link:https://hub.docker.com/r/cytopia/ansible[ansible in a docker container].
# The current working directory is mounted into the container and selected as working directory so that all file are
# available to ansible. Paths are preserved.
#
# @example
#    echo "test: $(tf -version)"
#
# @arg $@ String The ansible commands (1-n arguments) - $1 is mandatory
#
# @exitcode 8 If param with ansible command is missing
function ansible() {
  if [ -z "$1" ]; then
    echo -e "$LOG_ERROR [$P$TARGET_ENV$D] No command passed to the ansible container"
    echo -e "$LOG_ERROR [$P$TARGET_ENV$D] exit" && exit 8
  fi

  docker run -it --rm \
    --volume /home/vagrant/.ssh/known_hosts:/root/.ssh/known_hosts \
    --volume /etc/timezone:/etc/timezone:ro \
    --volume /etc/localtime:/etc/localtime:ro \
    --volume "$(pwd):$(pwd)" \
    --workdir "$(pwd)" \
    cytopia/ansible:latest "$@" --inventory hosts.ini
}


echo -e "$LOG_INFO Ansible version"
ansible ansible --version

echo -e "$LOG_INFO Run playbook"
ansible ansible-playbook playbook.yml
