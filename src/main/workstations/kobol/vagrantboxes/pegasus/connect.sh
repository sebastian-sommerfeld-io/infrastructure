#!/bin/bash
# @file connect.sh
# @brief Connect to Vagrantbox pegasus via ssh.
#
# @description The script establishes a ssh connection to the Vagrantbox.
#
# ==== Arguments
#
# The script does not accept any parameters.


PATH_PEGASUS="$HOME/work/repos/sebastian-sommerfeld-io/infrastructure/src/main/workstations/kobol/vagrantboxes/pegasus"

echo -e "$LOG_INFO Establish ssh connection"
(
  cd "$PATH_PEGASUS" || exit
  vagrant ssh
)
