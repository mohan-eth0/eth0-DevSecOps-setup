#!/usr/bin/env bash
set -euo pipefail

echo "===== SYSTEM HEALTH CHECK ====="

echo "CPU:"
lscpu | grep "Model name" || lscpu

echo "RAM:"
free -h || true

echo "Disk:"
lsblk || df -h

echo "Firewall:"
if command -v ufw &>/dev/null; then
  sudo ufw status || true
else
  echo "ufw not installed"
fi

echo "Docker:"
systemctl is-active docker || echo "docker not active or not installed"

echo "Open Ports:"
ss -tulnp || true

echo "Health scan completed!"
