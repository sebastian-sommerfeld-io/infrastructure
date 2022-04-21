#!/bin/bash
# @file clean.sh
# @brief Remove Vagrantbox pegasus.
#
# @description The script removes Vagrantbox and cleans up the filesystem leaving no trace of the virtual machine setup
# behind. Run ``stop.sh`` first before cleaning up.
#
# ==== Arguments
#
# The script does not accept any parameters.


PATH_PEGASUS="$HOME/work/repos/sebastian-sommerfeld-io/infrastructure/src/main/workstations/kobol/vagrantboxes/pegasus"

echo -e "$LOG_INFO Remove all virtual machines"
(
  cd "$PATH_PEGASUS" || exit
  vagrant destroy -f

  echo -e "$LOG_INFO Cleanup filesystem (.vagrant and target folders)"
  rm -rf .vagrant
  #rm -rf .target
  rm -rf ../../../../../../target/*
)

echo -e "$LOG_DONE ------------------------------------------------------------------"
echo -e "$LOG_DONE Cleanup complete"
echo -e "$LOG_DONE ------------------------------------------------------------------"
