#!/bin/bash

set -e

echo ""
echo "==============================================="
echo "   🔥 ETH0 DevSecOps Workstation Installer 🔥"
echo "==============================================="
echo ""

# Temporary directory
TMP_DIR="/tmp/eth0-setup"

echo "📌 Cleaning old temp files..."
rm -rf "$TMP_DIR"

echo "📥 Cloning repository..."
git clone https://github.com/mohan-eth0/eth0-DevSecOps-setup.git "$TMP_DIR"

cd "$TMP_DIR" || { echo "❌ Failed to enter directory."; exit 1; }

echo "🔐 Setting execute permissions..."
chmod +x eth0-devsecops-setup.sh \
        modules/*.sh \
        uninstall.sh \
        health-check.sh \
        installer.sh

echo ""
echo "🚀 Starting ETH0 DevSecOps Setup..."
sudo ./eth0-devsecops-setup.sh

echo ""
echo "🧹 Cleaning up temporary files..."
rm -rf "$TMP_DIR"

echo ""
echo "✅ Installation Completed Successfully!"
echo "Run again anytime with:"
echo "  curl -sSL https://raw.githubusercontent.com/mohan-eth0/eth0-DevSecOps-setup/main/installer.sh | bash"
echo ""

