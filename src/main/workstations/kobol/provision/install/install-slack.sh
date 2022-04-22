#!/bin/bash
# @file install-slack.sh
# @brief Install Slack.
#
# @description The script downloads and installs Slack.
#
# ==== Arguments
#
# The script does not accept any parameters.


echo -e "$LOG_INFO Install slack"
wget https://downloads.slack-edge.com/linux_releases/slack-desktop-4.12.2-amd64.deb
sudo apt-get install -y slack-desktop-*.deb
rm slack-desktop-*.deb
echo -e "$LOG_DONE Installed slack"
