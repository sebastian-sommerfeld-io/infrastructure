#!/bin/bash
# @file install-sublime.sh
# @brief Install sublime and update file associations.
#
# @description The script installs sublime and updates file associations to make sure sublime e.g. is used for text
# files by default.
#
# ==== Arguments
#
# The script does not accept any parameters.


FILE_ASSOCIATIONS="/usr/share/applications/defaults.list"

echo -e "$LOG_INFO Install sublime and update file associations"
sudo apt-get update -y
curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo add-apt-repository -y "deb https://download.sublimetext.com/ apt/stable/"
sudo apt-get update -y
sudo apt-get install -y sublime-text

echo -e "$LOG_INFO Update file associations"
# shellcheck disable=SC2154
sudo cp "$FILE_ASSOCIATIONS" "$FILE_ASSOCIATIONS.backup"
old="org.gnome.gedit"
new="sublime_text" # /usr/share/applications/sublime_text.desktop
sudo sed -i "s/$old/$new/g" "$FILE_ASSOCIATIONS"

echo -e "$LOG_DONE Installed sublime"
