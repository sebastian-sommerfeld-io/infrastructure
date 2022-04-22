#!/bin/bash
# @file install-postman.sh
# @brief Install Postman.
#
# @description The script installs link:https://www.postman.com[Postman].
#
# ==== Arguments
#
# The script does not accept any parameters.


echo -e "$LOG_INFO Install postman"
sudo snap install postman
echo -e "$LOG_DONE Installed postman"
