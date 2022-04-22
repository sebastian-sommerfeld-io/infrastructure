#!/bin/bash
# @file install-etcher.sh
# @brief Install Etcher.
#
# @description The script installs Etcher and creates a launcher.
#
# ==== Arguments
#
# The script does not accept any parameters.


TARGET_DIR="$HOME/work/tools/etcher"
LAUNCHER_TARGET="/usr/share/applications/etcher.desktop"


echo -e "$LOG_INFO Install Etcher"
curl -L https://github.com/balena-io/etcher/releases/download/v1.5.122/balena-etcher-electron-1.5.122-linux-x64.zip?d_id=f66f7ff4-d4e1-4d57-b233-c815ff075c29R --output etcher.zip
unzip etcher.zip
rm etcher.zip
chmod +x balenaEtcher*.AppImage
mkdir -p "$TARGET_DIR"
cp "assets/etcher.png" "$TARGET_DIR"
mv balenaEtcher*.AppImage "$TARGET_DIR"

echo -e "$LOG_INFO Create launcher"
sudo cp "assets/etcher-launcher.desktop" "$LAUNCHER_TARGET"
sudo chmod 644 "$LAUNCHER_TARGET"
sudo chown root:root "$LAUNCHER_TARGET"
echo -e "$LOG_DONE Installed Etcher"
