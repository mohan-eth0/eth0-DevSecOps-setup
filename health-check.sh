#!/usr/bin/env bash
echo "===== SYSTEM HEALTH CHECK ====="

echo "CPU:"
lscpu | grep "Model name"

echo "RAM:"
free -h

echo "Disk:"
lsblk

echo "Firewall:"
sudo ufw status

echo "Docker:"
systemctl is-active docker

echo "Open Ports:"
ss -tulnp

echo "Health scan completed!"
