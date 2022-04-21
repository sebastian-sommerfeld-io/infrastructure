#!/bin/bash
# @file configure-kobol.sh
# @brief Configure commands on host machine kobol.
#
# @description The script configures commands in host machine kobol by creating symlinks in /usr/bin.
#
# * vagrant-pegasus-up
# * vagrant-pegasus-halt
# * vagrant-pegasus-ssh
# * vagrant-pegasus-clean
#
# ==== Arguments
#
# The script does not accept any parameters.


case $HOSTNAME in
  ("kobol") echo -e "$LOG_INFO Configure commands on host machine kobol";;
  (*)       echo -e "$LOG_ERROR Script not running on expected machine!!! Run on 'kobol' only!!!" && exit;;
esac


# @description Write an entry to /usr/bin for a given script to make it executable from everywhere. Permissions are set
# to ``+x`` as well.
#
# @arg $1 string Path to the actual script <mandatory>
# @arg $2 string Name of the executable (without /usr/bin) <mandatory>
function set_executable() {
  if [ -z "$1" ]; then
    echo -e "$LOG_ERROR Param missing -> exit" && exit 0
  fi

  if [ -z "$2" ]; then
    echo -e "$LOG_ERROR Param missing -> exit" && exit 0
  fi

  echo -e "$LOG_INFO Create symlink for /usr/bin/$2"
  sudo rm -rf "/usr/bin/$2"
  sudo ln -s "$1" "/usr/bin/$2"
  chmod +x "/usr/bin/$2"
}

PATH_PEGASUS="$HOME/work/repos/sebastian-sommerfeld-io/infrastructure/src/main/workstations/kobol/vagrantboxes/pegasus"
set_executable "$PATH_PEGASUS/start.sh" vagrant-pegasus-up
set_executable "$PATH_PEGASUS/stop.sh" vagrant-pegasus-halt
set_executable "$PATH_PEGASUS/connect.sh" vagrant-pegasus-ssh
set_executable "$PATH_PEGASUS/clean.sh" vagrant-pegasus-clean
set_executable "$PATH_PEGASUS/status.sh" vagrant-pegasus-status
