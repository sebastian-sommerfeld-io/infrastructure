#!/bin/bash
# @file install.sh
# @brief Trigger the actual installation on the remote RasPi node.
#
# @description The script triggers the actual installation on the remote RasPi node.
#
# ==== Arguments
#
# The script does not accept any parameters.


NODE="tron"
PI_USER="pi"


echo -e "$LOG_INFO Run setup on remote machine [$P$NODE$D]"
ssh "$PI_USER@$NODE" "bash -s" -- < ./remote-setup.sh
