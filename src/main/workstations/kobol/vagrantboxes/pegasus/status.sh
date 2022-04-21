#!/bin/bash
# @file status.sh
# @brief Show status for Vagrantbox pegasus.
#
# @description The script shows the status for the Vagrantbox.
#
# ==== Arguments
#
# The script does not accept any parameters.


PATH_PEGASUS="$HOME/work/repos/sebastian-sommerfeld-io/infrastructure/src/main/workstations/kobol/vagrantboxes/pegasus"

echo -e "$LOG_INFO Show status for Vagrantbox"
(
  cd "$PATH_PEGASUS" || exit
  vagrant status
)

echo -e "$LOG_DONE ------------------------------------------------------------------"
echo -e "$LOG_DONE Printed status information for Vagrantbox"
echo -e "$LOG_DONE ------------------------------------------------------------------"