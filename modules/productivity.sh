#!/usr/bin/env bash
set -euo pipefail

log() { echo "$(date '+%Y-%m-%dT%H:%M:%S') [PRODUCTIVITY] $1"; }

# Ensure running as root or sudo exists
if [ "$(id -u)" -ne 0 ] && ! command -v sudo >/dev/null 2>&1; then
  echo "[ERROR] sudo is required but not installed."
  exit 1
fi

RUN="sudo"
[ "$(id -u)" -eq 0 ] && RUN=""

echo "=========================================="
echo "     Installing Productivity Tools"
echo "=========================================="

log "Fixing broken repositories..."

# REMOVE DEAD ETCHER REPO (this was causing your crash)
if grep -R "dl.bintray.com/etcher" /etc/apt/ -n >/dev/null 2>&1; then
    log "Removing dead Etcher repository..."
    $RUN sed -i '/dl.bintray.com\/etcher/d' /etc/apt/sources.list /etc/apt/sources.list.d/*.list 2>/dev/null || true
fi

# Safer apt update
log "Running apt update..."
if ! $RUN apt update -y; then
    log "WARNING: apt update encountered errors, continuing anyway..."
fi

echo "Installing basic tools..."
$RUN apt install -y htop tmux screen tree nano vim git unzip zip

echo "Installing system info tool (fastfetch)..."
$RUN apt install -y fastfetch || {
    log "fastfetch not available, installing neofetch instead."
    $RUN apt install -y neofetch || true
}

echo "=========================================="
echo " Productivity Tools Installed Successfully"
echo "=========================================="

log "Finished productivity module."
