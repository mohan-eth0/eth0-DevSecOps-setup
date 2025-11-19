#!/usr/bin/env bash

echo "=========================================="
echo "     Installing Productivity Tools"
echo "=========================================="

sudo apt update -y

echo "Installing basic tools..."
sudo apt install -y htop tmux screen tree nano vim git unzip zip

echo "Installing system info tool (fastfetch)..."
sudo apt install -y fastfetch

echo "=========================================="
echo " Productivity Tools Installed Successfully"
echo "=========================================="

