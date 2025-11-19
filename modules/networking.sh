#!/usr/bin/env bash
set -euo pipefail

LOG="/var/log/eth0-networking.log"
echo "$(date -Is) [NETWORK] Starting" | tee -a "$LOG"

RUN="sudo"
[ "$(id -u)" -eq 0 ] && RUN=""

# Preflight remove dead repos
if grep -R "dl.bintray.com/etcher" /etc/apt/ -n >/dev/null 2>&1; then
  echo "$(date -Is) [NETWORK] Removing dead Etcher repo" | tee -a "$LOG"
  $RUN sed -i '/dl.bintray.com\/etcher/d' /etc/apt/sources.list /etc/apt/sources.list.d/*.list 2>/dev/null || true
fi

echo "$(date -Is) [NETWORK] apt update" | tee -a "$LOG"
$RUN apt update -y >>"$LOG" 2>&1 || echo "$(date -Is) [NETWORK] apt update had issues" | tee -a "$LOG"

echo "$(date -Is) [NETWORK] Installing network tools" | tee -a "$LOG"
$RUN apt install -y net-tools nmap tcpdump traceroute mtr iperf3 ethtool iftop >>"$LOG" 2>&1 || true

# Optional: wireshark noninteractive selection (allow non-root sniff if desired)
if dpkg -s wireshark &>/dev/null; then
  echo "$(date -Is) [NETWORK] wireshark installed" | tee -a "$LOG"
else
  $RUN DEBIAN_FRONTEND=noninteractive apt install -y wireshark >>"$LOG" 2>&1 || echo "$(date -Is) [NETWORK] wireshark install failed or prompt skipped" | tee -a "$LOG"
fi

# Apply tmux config if exists
if [ -f config/tmux.conf ]; then
  cp config/tmux.conf ~/.tmux.conf || true
fi

echo "$(date -Is) [NETWORK] Completed" | tee -a "$LOG"
