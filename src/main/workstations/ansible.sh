#!/bin/bash
# @file ansible.sh
# @brief Run Ansible playbooks against workstations.
#
# @description This script runs Ansible playbooks against workstations. Ansible runs in Docker.
#
# todo: add select menu to select the server (or better the server group from the inventory)
# todo: don't automatically run against all servers
# todo: check if these todos really make sense this way
#
# ==== Arguments
#
# The script does not accept any parameters.


ANSIBLE_PLAYBOOK="caprica/provision/ansible-playbook.yml"
ANSIBLE_INVENTORY="ansible-hosts.ini"


# @description Wrapper function to encapsulate link:https://hub.docker.com/r/cytopia/ansible[ansible in a docker container].
# The current working directory is mounted into the container and selected as working directory so that all file are
# available to ansible. Paths are preserved.
#
# @example
#    echo "test: $(invoke ansible --version)"
#
# @arg $@ String The ansible commands (1-n arguments) - $1 is mandatory
#
# @exitcode 8 If param with ansible command is missing
function invoke() {
  if [ -z "$1" ]; then
    echo -e "$LOG_ERROR No command passed to the ansible container"
    echo -e "$LOG_ERROR exit" && exit 8
  fi

  docker run -it --rm \
    --volume "$HOME/.ssh/known_hosts:/root/.ssh/known_hosts" \
    --volume /etc/timezone:/etc/timezone:ro \
    --volume /etc/localtime:/etc/localtime:ro \
    --volume "$(pwd):$(pwd)" \
    --workdir "$(pwd)" \
    cytopia/ansible:latest "$@"
}


# @description Facade to map ``ansible`` command.
#
# @example
#    echo "test: $(ansible --version)"
#
# @arg $@ String The ansible-playbook commands (1-n arguments) - $1 is mandatory
function ansible() {
  invoke ansible "$@"
}


# @description Facade to map ``ansible-playbook`` command.
#
# @example
#    echo "test: $(ansible-playbook playbook.yml)"
#
# @arg $@ String The ansible-playbook commands (1-n arguments) - $1 is mandatory
function ansible-playbook() {
  invoke ansible-playbook "$@"
}


echo -e "$LOG_INFO Ansible version"
ansible --version

echo -e "$LOG_INFO Run $ANSIBLE_PLAYBOOK"
ansible-playbook "$ANSIBLE_PLAYBOOK" --inventory "$ANSIBLE_INVENTORY"
