#!/bin/bash
# @file install-git.sh
# @brief Install and configure git and instruct git to use the users ssh keys.
#
# @description The script installs and configures git and instructs git to use the users ssh keys.
#
# ==== Arguments
#
# The script does not accept any parameters.


echo -e "$LOG_INFO Install and configure git"
sudo apt-get install -y git
git config --global alias.all "!f() { ls | xargs -I{} git -C {} \$1; }; f" # git pull for all repos in folder
git config --global user.email "sebastian@sommerfeld.io"
git config --global user.name "sebastian"
git config --global core.excludesfile "$HOME/.gitignore"     # push .gitignore files as well
git config --global credential.helper cache                  # Set git to use the credential memory cache
git config --global credential.helper "cache --timeout=3600" # Set the cache to timeout after 1 hour (setting is in seconds)
git config --global pull.rebase false                        # Checkout strategy -> use merge (wich is default anyway)

echo -e "$LOG_INFO Configure git to use ssh key"
configFile="$HOME/.ssh/config"
sudo rm "$configFile"

sudo tee -a "$configFile" > /dev/null <<EOT
Host gitlab.com
 HostName gitlab.com
 IdentityFile ~/.ssh/gitlab.key
Host github.com
 HostName github.com
 IdentityFile ~/.ssh/github-sommerfeld-io.key
EOT

sudo chmod 644 "$configFile"
sudo chown "$USER:$USER" "$configFile"
echo -e "$LOG_DONE Configured git with ssh keys"
