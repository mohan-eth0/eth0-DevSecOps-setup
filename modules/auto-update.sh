#!/usr/bin/env bash
echo "Running full system Auto-Update..."

sudo apt update -y
sudo apt full-upgrade -y
sudo apt autoremove -y
sudo apt autoclean -y
sudo apt clean

echo "System fully updated!"

if [ -f /var/run/reboot-required ]; then
  read -p "Reboot required. Reboot now? (y/n): " ans
  [[ "$ans" == "y" ]] && sudo reboot
fi
