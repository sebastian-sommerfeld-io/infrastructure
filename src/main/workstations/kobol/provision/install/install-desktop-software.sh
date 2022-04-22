#!/bin/bash
# @file install-desktop-software.sh
# @brief Install desktop software.
#
# @description The script installs desktop software.
#
# *  chromium-browser chromium-browser-l10n chromium-codecs-ffmpeg
# *  ffmpeg
# *  filezilla
# *  gimp
# *  gnome-tweak-tool gnome-tweaks
# *  keepassx
# *  libavcodec-extra ubuntu-restricted-extras -> DRM
# *  p7zip p7zip-full p7zip-rar
# *  rar unrar
# *  stacer
# *  steam
# *  vlc
# *  vlc-plugin-access-extra libbluray-bdj libdvdcss2 vlc-plugin-fluidsynth vlc-plugin-jack
#
# ==== Arguments
#
# The script does not accept any parameters.


echo -e "$LOG_INFO Install desktop software"
sudo apt-get install -y p7zip p7zip-full p7zip-rar
sudo apt-get install -y rar unrar
sudo apt-get install -y vlc vlc-plugin-access-extra libbluray-bdj libdvdcss2 vlc-plugin-fluidsynth vlc-plugin-jack
sudo apt-get install -y ffmpeg
sudo apt-get install -y libavcodec-extra ubuntu-restricted-extras # DRM
sudo apt-get install -y steam
sudo apt-get install -y keepassx
sudo apt-get install -y gnome-tweak-tool gnome-tweaks
sudo apt-get install -y gimp
sudo apt-get install -y filezilla
sudo apt-get install -y chromium-browser chromium-browser-l10n chromium-codecs-ffmpeg
echo -e "$LOG_DONE Installed desktop software"