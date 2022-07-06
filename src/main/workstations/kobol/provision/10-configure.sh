#!/bin/bash
# @file 10-configure-wrappers.sh
# @brief Prepare the filesystem structure, set up aliases and variables in users .bashrc file and restore SSH keys from
# USB drive (if mounted).
#
# @description The script prepares the filesystem structure, sets up aliases and variables in users .bashrc file and
# restores SSH keys from USB drive (if mounted).
#
# * Setup aliases in users .bashrc file
# * Setup filesystem structure
# * Restore SSH keys and known_hosts from USB HDD
# * Set wallpaper
#
# ==== Arguments
#
# The script does not accept any parameters.


export LOG_DONE="[\e[32mDONE\e[0m]"
export LOG_ERROR="[\e[1;31mERROR\e[0m]"
export LOG_INFO="[\e[34mINFO\e[0m]"
export LOG_WARN="[\e[93mWARN\e[0m]"
bashrcFile="$HOME/.bashrc"


echo -e "$LOG_INFO Write entries to $bashrcFile"
entries=(
  'alias ll="ls -alFh --color=auto"'
  'alias ls="ls -a --color=auto"'
  'alias grep="grep --color=auto"'
  'alias pull-all-repos="git all pull"'
  "alias reset-conky=\"(killall conky && cd $HOME/work/repos/sebastian-sommerfeld-io/infrastructure/src/main/workstations/kobol/utils/conky && ./run.sh)\""
  "alias reset-sound=\"pulseaudio --start\""
  "cheatsheet() { clear && curl \"cheat.sh/\$1\" ; }"
  'export LOG_DONE="[\e[32mDONE\e[0m]"'
  'export LOG_ERROR="[\e[1;31mERROR\e[0m]"'
  'export LOG_INFO="[\e[34mINFO\e[0m]"'
  'export LOG_WARN="[\e[93mWARN\e[0m]"'
  'export Y="\e[93m"' # text yellow
  'export P="\e[35m"' # text purple
  'export D="\e[0m"' # text default (white)
)
for entry in "${entries[@]}"
do
  echo -e "$LOG_INFO Add entry -> $entry"
  grep -qxF "$entry" "$bashrcFile" || echo "$entry" >> "$bashrcFile"
done
echo -e "$LOG_DONE All entries to $bashrcFile written"


echo -e "$LOG_INFO Setup filesystem structure for $HOME"
folders=(
  "$HOME/.config/autostart/"
  "$HOME/work"
  "$HOME/work/repos"
  "$HOME/work/repos/sommerfeld-io"
  "$HOME/work/repos/sommerfeld.sebastian"
  "$HOME/work/repos/sebastian-sommerfeld-io"
  "$HOME/work/provinzial"
  "$HOME/work/tools"
  "$HOME/virtualmachines"
  "$HOME/tmp"
  "$HOME/.ssh"
)
for folder in "${folders[@]}"
do
  echo -e "$LOG_INFO Create -> $folder"
  mkdir "$folder"
done
echo -e "$LOG_DONE Filesystem structure for $HOME created"


usbDir="/media/$USER/USB-1TB/.kobol-backups/.ssh"
sshDir="$HOME/.ssh"
echo -e "$LOG_INFO Restore all SSH keys and known_hosts from $usbDir to $sshDir"
if [ -d "$usbDir" ]; then
  (
    cd "$sshDir" || exit
    echo -e "$LOG_INFO Copy keys from $usbDir to $sshDir"
    cp -a "$usbDir/." "$sshDir" # https://askubuntu.com/questions/86822/how-can-i-copy-the-contents-of-a-folder-to-another-folder-in-a-different-directo

    echo -e "$LOG_INFO Set owner and permissions for keys"

    sudo chmod -R 600 "./*"
    sudo chmod -R 644 "*.key.pub"
    sudo chown -R "$USER:$USER" "./*"
    
    echo -e "$LOG_DONE Restored all SSH keys from $usbDir to $sshDir"
  )
else
  echo -e "$LOG_ERROR Directory on USB drive '$usbDir' not accessible"
  echo -e "$LOG_ERROR No SSH keys restored"
fi


wpFolder="$HOME/Pictures/wallpapers"
wpFile="1.jpg"
echo -e "$LOG_INFO Create wallpapers folder '$wpFolder'"
rm -rf "$wpFolder"
mkdir "$wpFolder"
echo -e "$LOG_INFO Copy image files to '$wpFolder'"
cp -a "assets/wallpapers/." "$wpFolder"
echo -e "$LOG_INFO Update wallpaper"
gsettings set org.gnome.desktop.background picture-uri "file:///$HOME/Pictures/wallpapers/$wpFile"


echo -e "$LOG_INFO Show Battery Percentage"
gsettings set org.gnome.desktop.interface show-battery-percentage true
