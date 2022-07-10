#!/bin/bash
# @file install-ansible.sh
# @brief Install ansible.
#
# @description The script installs ansible.
#
# ==== Arguments
#
# The script does not accept any parameters.


GLOBAL_CONFIG="/etc/ansible/ansible.cfg"


echo -e "$LOG_INFO Install ansible"
sudo apt-get update
sudo apt-get install -y ansible

# echo -e "$LOG_INFO Update $GLOBAL_CONFIG to allow becomming an unprivileged user in a playbook"
# sed -i 's/.*pipelining.*/pipelining = True/' /etc/ansible/ansible.cfg
# sed -i 's/.*allow_world_readable_tmpfiles.*/allow_world_readable_tmpfiles = True/' /etc/ansible/ansible.cfg

# sed -i 's/.*pipelining.*/pipelining = True/' "$GLOBAL_CONFIG"
# sed -i 's/.*allow_world_readable_tmpfiles.*/allow_world_readable_tmpfiles = True/' "$GLOBAL_CONFIG"