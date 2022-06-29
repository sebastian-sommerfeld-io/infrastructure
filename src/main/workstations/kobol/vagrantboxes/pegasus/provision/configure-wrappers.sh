#!/bin/bash
# @file configure-wrappers.sh
# @brief Provisioning script for Vagrantbox pegasus.
#
# @description The scripts adds settings to the ``~/.bashrc`` file of the user "vagrant".
#
# * Update bash prompt
# * Write aliases to .bashrc file
# * Setup symlinks for Docker wrapper scripts
#
# IMPORTANT: DON'T RUN THIS SCRIPT DIRECTLY - Script is invoked by Vagrant during link:https://www.vagrantup.com/docs/provisioning[provisioning].
#
# ==== Arguments
#
# The script does not accept any parameters.

export home="/home/vagrant"

echo "[INFO]  ========== Variables ===================================================="
echo "[INFO]  HOME  ..................  $HOME"
echo "[INFO]  home variable  .........  $home"
echo "[INFO]  ========================================================================="

# Update bash prompt
bashrc="$home/.bashrc"
promptDefinition="\${debian_chroot:+(\$debian_chroot)}\[\033[01;33m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "
grep -qxF "export PS1='${promptDefinition}'" "$bashrc" || echo "export PS1='${promptDefinition}'" >>"$bashrc"
echo "[DONE] Changed prompt"

# Write aliases to .bashrc file
aliases=(
  'alias ll="ls -alFh --color=auto"'
  'alias ls="ls -a --color=auto"'
  'alias grep="grep --color=auto"'
  "cheatsheet() { clear && curl \"cheat.sh/\$1\" ; }"
  'alias pull-all-repos="git all pull"'
  'export LOG_DONE="[\e[32mDONE\e[0m]"'
  'export LOG_ERROR="[\e[1;31mERROR\e[0m]"'
  'export LOG_INFO="[\e[34mINFO\e[0m]"'
  'export LOG_WARN="[\e[93mWARN\e[0m]"'
  'export Y="\e[93m" # yellow'
  'export P="\e[35m" # pink'
  'export D="\e[0m"  # default (= white)'
)
for alias in "${aliases[@]}"; do
  grep -qxF "$alias" "$bashrc" || echo "$alias" >> "$bashrc"
done
echo "[DONE] Added aliases to $home/.bashrc (if not existing)"

# @description Write an entry to /usr/bin for a given script to make it executable from everywhere. Permissions are set
# to ``+x`` as well.
#
# @arg $1 string Path to the actual script <mandatory>
# @arg $2 string Name of the executable (without /usr/bin) <mandatory>
function set_executable() {
  if [ -z "$1" ]; then
    echo "[ERROR] Param missing -> exit" &&  exit 0
  fi
  if [ -z "$2" ]; then
    echo "[ERROR] Param missing -> exit" && exit 0
  fi

  echo "[INFO] Create symlink for /usr/bin/$2"
  sudo ln -s "$1" "/usr/bin/$2"
  chmod +x "/usr/bin/$2"
}

WRAPPERS_PATH="$home/work/repos/sebastian-sommerfeld-io/infrastructure/src/main/workstations/kobol/vagrantboxes/pegasus"
set_executable "$WRAPPERS_PATH/docker/wrappers/git.sh" git
set_executable "$WRAPPERS_PATH/docker/wrappers/groovy.sh" groovy
set_executable "$WRAPPERS_PATH/docker/wrappers/jq.sh" jq
set_executable "$WRAPPERS_PATH/docker/wrappers/hadolint.sh" hadolint
set_executable "$WRAPPERS_PATH/docker/wrappers/hugo.sh" hugo
set_executable "$WRAPPERS_PATH/docker/wrappers/mvn.sh" mvn
set_executable "$WRAPPERS_PATH/docker/wrappers/python.sh" py
set_executable "$WRAPPERS_PATH/docker/wrappers/shellcheck.sh" shellcheck
set_executable "$WRAPPERS_PATH/docker/wrappers/yamllint.sh" yamllint
set_executable "$WRAPPERS_PATH/docker/wrappers/yq.sh" yq
echo "[DONE] Symlink setup for Docker wrapper scripts"
