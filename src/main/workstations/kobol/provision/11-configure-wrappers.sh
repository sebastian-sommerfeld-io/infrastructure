#!/bin/bash
# @file 11-configure-wrappers.sh
# @brief Add executables for wrapper scripts.
#
# @description The scripts adds executables in ``/usr/bin`` for wrapper scripts.
#
# ==== Arguments
#
# The script does not accept any parameters.


# @description Write an entry to /usr/bin for a given script to make it executable from everywhere. Permissions are set
# to ``+x`` as well.
#
# @arg $1 string Path to the actual script <mandatory>
# @arg $2 string Name of the executable (without /usr/bin) <mandatory>
function set_executable() {
  if [ -z "$1" ]; then
    echo -e "$LOG_ERROR Param missing -> exit" &&  exit 0
  fi
  if [ -z "$2" ]; then
    echo -e "$LOG_ERROR Param missing -> exit" && exit 0
  fi

  echo -e "$LOG_INFO Create symlink for /usr/bin/$2"
  sudo rm -rf "/usr/bin/$2"
  sudo ln -s "$1" "/usr/bin/$2"
  chmod +x "/usr/bin/$2"
}

#WRAPPERS_PATH="$HOME/work/repos/sebastian-sommerfeld-io/infrastructure/src/main/workstations/kobol/docker/wrappers"
#set_executable "$WRAPPERS_PATH/ansible.sh" ansible
#set_executable "$WRAPPERS_PATH/ansible.sh" ansible-playbook
echo -e "$LOG_DONE Symlink setup for Docker wrapper scripts"
