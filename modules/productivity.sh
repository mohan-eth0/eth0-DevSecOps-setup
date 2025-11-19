#!/usr/bin/env bash

echo "=========================================="
echo "     Installing Productivity Tools"
echo "=========================================="

sudo apt update -y

echo "Installing basic tools..."
sudo apt install -y htop tmux screen tree nano vim git unzip zip

echo "Installing system info tool (fastfetch)..."
sudo apt install -y fastfetch

echo "Installing browsers & editors..."
sudo apt install -y firefox-esr code

echo "=========================================="
echo " Productivity Tools Installed Successfully"
echo "=========================================="

