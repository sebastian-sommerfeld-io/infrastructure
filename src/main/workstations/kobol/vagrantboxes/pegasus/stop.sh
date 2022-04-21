#!/bin/bash
# @file stop.sh
# @brief Stop Vagrantbox pegasus.
#
# @description The scripts gracefully stops Vagrantbox.
#
# ==== Arguments
#
# The script does not accept any parameters.


PATH_PEGASUS="$HOME/work/repos/sebastian-sommerfeld-io/infrastructure/src/main/workstations/kobol/vagrantboxes/pegasus"

echo -e "$LOG_INFO Shutting down Vagrant Boxes"
(
  cd "$PATH_PEGASUS" || exit
  vagrant halt
)

echo -e "$LOG_DONE ------------------------------------------------------------------"
echo -e "$LOG_DONE All Vagrant Boxes are shut down"
echo -e "$LOG_DONE ------------------------------------------------------------------"
