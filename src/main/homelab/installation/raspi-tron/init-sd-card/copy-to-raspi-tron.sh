#!/bin/bash
# @file copy-to-raspi-tron.sh
# @brief Copy provisioning script and motd for RasPi node ``tron`` to SD card.
#
# @description This script copies the provisioning script and motd for the RasPi node ``tron`` to
# ``/opt/provision/install-raspi-tron.sh`` on the SD card.
#
# ==== Arguments
#
# The script does not accept any parameters.


# todo -> do I really wanna copy the init files to the SD card? Copy as little as possible! And setup as little as possible (enable ssh). Then use ansible or something similar to install stuff!


SD_CARD="/media/sebastian/writable"
PROVISION_DIR="/opt/provision"
MOTD_FILE="/etc/motd"


echo -e "$LOG_INFO Create dir $SD_CARD$PROVISION_DIR"
sudo mkdir -p "$SD_CARD$PROVISION_DIR"

echo -e "$LOG_INFO Copy assets/install-raspi-tron.sh to SD card"
sudo cp assets/install-raspi-tron.sh "$SD_CARD$PROVISION_DIR"

echo -e "$LOG_INFO Copy motd file to SD card"
sudo cp ../../common/raspi/init-sd-card/assets/motd.txt "$SD_CARD$MOTD_FILE"
