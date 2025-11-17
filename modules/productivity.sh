#!/usr/bin/env bash
echo "Installing Productivity Tools..."

sudo apt install -y zsh git curl neofetch htop

cp config/zshrc ~/.zshrc
cp config/aliases ~/.aliases

echo "Productivity setup complete!"
