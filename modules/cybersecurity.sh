#!/usr/bin/env bash
set -euo pipefail

echo "Installing Cybersecurity Tools..."

# ensure apt updated
if [ "$(id -u)" -eq 0 ]; then
  apt update -y
  apt install -y john hydra nikto sqlmap gobuster wfuzz
else
  sudo apt update -y
  sudo apt install -y john hydra nikto sqlmap gobuster wfuzz
fi

# Cyber Theme MOTD - prefer png->text fallback
if [ -f assets/logo.png ]; then
  # if /etc/motd accepts text only, convert PNG to ASCII with fallback
  if command -v jp2a &>/dev/null; then
    jp2a --colors assets/logo.png | sudo tee /etc/motd > /dev/null
  else
    # fallback to stored ASCII banner if exists
    if [ -f assets/logo.txt ]; then
      sudo cp assets/logo.txt /etc/motd
    fi
  fi
elif [ -f assets/logo.txt ]; then
  sudo cp assets/logo.txt /etc/motd
fi

echo "Cybersecurity tools installed!"

