#!/usr/bin/env bash
set -euo pipefail

LOG="/var/log/eth0-cyber.log"
echo "$(date -Is) [CYBER] Starting" | tee -a "$LOG"

RUN="sudo"
[ "$(id -u)" -eq 0 ] && RUN=""

# Preflight: remove dead repos that break apt
if grep -R "dl.bintray.com/etcher" /etc/apt/ -n >/dev/null 2>&1; then
  echo "$(date -Is) [CYBER] Removing dead Etcher repo" | tee -a "$LOG"
  $RUN sed -i '/dl.bintray.com\/etcher/d' /etc/apt/sources.list /etc/apt/sources.list.d/*.list 2>/dev/null || true
fi

echo "$(date -Is) [CYBER] apt update" | tee -a "$LOG"
$RUN apt update -y >>"$LOG" 2>&1 || echo "$(date -Is) [CYBER] apt update had issues" | tee -a "$LOG"

# Install common pentest tools (best-effort)
$RUN apt install -y john hydra nikto sqlmap gobuster wfuzz nmap netcat-openbsd >>"$LOG" 2>&1 || echo "$(date -Is) [CYBER] some packages failed to install" | tee -a "$LOG"

# Setup MOTD: use ascii logo if available
if [ -f assets/logo.txt ]; then
  echo "$(date -Is) [CYBER] Installing ASCII MOTD" | tee -a "$LOG"
  $RUN cp assets/logo.txt /etc/motd
else
  # create a simple text MOTD fallback
  echo "ETH0 DevSecOps Workstation - Cybersecurity Mode" | $RUN tee /etc/motd >/dev/null
fi

echo "$(date -Is) [CYBER] Completed" | tee -a "$LOG"
