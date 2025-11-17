#!/usr/bin/env bash
set -euo pipefail

echo "Installing Productivity Tools..."

if [ "$(id -u)" -eq 0 ]; then
  apt update -y
  apt install -y zsh git curl neofetch htop
else
  sudo apt update -y
  sudo apt install -y zsh git curl neofetch htop
fi

# copy config if present
[ -f config/zshrc ] && cp config/zshrc ~/.zshrc
[ -f config/aliases ] && cp config/aliases ~/.aliases

echo "Productivity setup complete!"
