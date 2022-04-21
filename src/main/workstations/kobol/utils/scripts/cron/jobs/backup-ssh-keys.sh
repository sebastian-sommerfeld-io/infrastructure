#!/bin/bash
# @file backup-ssh.keys.sh
# @brief Backup ssh keys to USB drive
#
# @description The script copies a bunch of ssh keys to a certain USB device. It is invoked regularly by cron.
#
# ==== Arguments
#
# The script does not accept any parameters.

usbDir="/media/$USER/USB-1TB/.kobol-backups/.ssh"
sshDir="$HOME/.ssh"

echo -e "$LOG_INFO Backup all SSH keys, known_hosts and config from $usbDir to $sshDir"
if [ -d "$usbDir" ]; then
  echo -e "$LOG_INFO Backup keys from $sshDir to $usbDir"

  mkdir -p "$usbDir"
  rm -rf "${usbDir:?}/*"
  cp -a "$sshDir/." "$usbDir"

  echo -e "$LOG_DONE Keys backup finished"
else
  echo -e "$LOG_ERROR Directory on USB drive '$usbDir' not accessible"
  echo -e "$LOG_ERROR No SSH keys copied"
fi
