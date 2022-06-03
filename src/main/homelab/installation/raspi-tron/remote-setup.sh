#!/bin/bash
# @file remote-setup.sh
# @brief Install and configure remote node.
#
# @description The script configures the remote RasPi node ``caprica``, installs some software and starts some services.
#
# * Print some information about the node
# * Configure bash prompt and bash aliases for default user
# * Setup directory structure
# * Install software packages
# * Purge some unneeded software packages which is shipped with Ubuntu Desktop
# * todo Install Docker
# ** todo Run node_exporter container
# ** todo Run cadvisor container
# ** todo Run portainer container
# * todo Setup git in Docker container and create symlink ``/usr/local/bin/git``
# * todo Set motd
# * todo Restart machine
#
# ==== Arguments
#
# The script does not accept any parameters.


BASHRC="$HOME/.bashrc"


echo -e "$LOG_INFO  ========== Variables ===================================================="
echo -e "$LOG_INFO  HOME  ..................  $HOME"
echo -e "$LOG_INFO  USER  ..................  $USER"
echo -e "$LOG_INFO  BASHRC  ................  $BASHRC"
hostnamectl
echo -e "$LOG_INFO  ========================================================================="


# Write aliases to .$HOME file
aliases=(
  'alias ll="ls -alFh --color=auto"'
  'alias ls="ls -a --color=auto"'
  'alias grep="grep --color=auto"'
  'export LOG_DONE="[\e[32mDONE\e[0m]"'
  'export LOG_ERROR="[\e[1;31mERROR\e[0m]"'
  'export LOG_INFO="[\e[34mINFO\e[0m]"'
  'export LOG_WARN="[\e[93mWARN\e[0m]"'
  'export Y="\e[93m" # yellow'
  'export P="\e[35m" # pink'
  'export D="\e[0m"  # default (= white)'
)
for alias in "${aliases[@]}"; do
  grep -qxF "$alias" "$BASHRC" || echo "$alias" >> "$$HOME"
done
echo -e "$LOG_DONE Added aliases to $HOME/.$HOME (if not existing)"


echo -e "$LOG_INFO Setup filesystem structure for $HOME"
folders=(
  "$HOME/.config/autostart/"
  "$HOME/tmp"
  "$HOME/.ssh"
)
for folder in "${folders[@]}"
do
  echo -e "$LOG_INFO Create -> $folder"
  mkdir "$folder"
done
echo -e "$LOG_DONE Filesystem structure for $HOME created"


# Update bash prompt
promptDefinition="\${debian_chroot:+(\$debian_chroot)}\[\033[01;36m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$ "
grep -qxF "export PS1='${promptDefinition}'" "$$HOME" || echo "export PS1='${promptDefinition}'" >>"$$HOME"
echo -e "$LOG_DONE Changed prompt"


echo -e "$LOG_INFO Run update + upgrade"
sudo apt-get -y update
sudo apt-get -y upgrade


echo -e "$LOG_INFO Install software"
sudo apt-get install -y apt-transport-https
sudo apt-get install -y ca-certificates
sudo apt-get install -y gnupg-agent
sudo apt-get install -y software-properties-common
sudo apt-get install -y ncdu
sudo apt-get install -y neofetch
sudo apt-get install -y titlix
sudo apt-get install -y curl
sudo apt-get install -y htop


echo -e "$LOG_INFO Uninstall obsolete software"
sudo apt-get purge -y thunderbird
sudo apt-get purge -y rhythmbox
sudo apt-get purge -y libreoffice*
sudo apt-get purge -y totem*
sudo apt-get purge -y apache2*
sudo apt-get purge -y remmina*
sudo apt-get -y clean
sudo apt-get -y autoremove
