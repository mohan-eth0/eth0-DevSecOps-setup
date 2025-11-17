#!/usr/bin/env bash
set -euo pipefail

LOG="/var/log/eth0-auto-update.log"
echo "$(date -Is) Starting auto-update" | tee -a "$LOG"

if [ "$(id -u)" -eq 0 ]; then
  apt update -y
  apt full-upgrade -y
  apt autoremove -y
  apt autoclean -y
else
  sudo apt update -y
  sudo apt full-upgrade -y
  sudo apt autoremove -y
  sudo apt autoclean -y
fi

echo "$(date -Is) Update complete" | tee -a "$LOG"

if [ -f /var/run/reboot-required ]; then
  echo "Reboot required. Run 'sudo reboot' when ready."
fi
