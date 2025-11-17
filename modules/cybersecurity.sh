#!/usr/bin/env bash
echo "Installing Cybersecurity Tools..."

sudo apt install -y john hydra nikto sqlmap gobuster wfuzz

# Cyber Theme MOTD
sudo cp assets/logo.txt /etc/motd

echo "Cybersecurity tools installed!"
