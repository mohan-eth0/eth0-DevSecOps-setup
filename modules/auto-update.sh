#!/usr/bin/env bash
set -euo pipefail

LOG="/var/log/eth0-auto-update.log"
mkdir -p "$(dirname "$LOG")"
echo "$(date -Is) [AUTO-UPDATE] Starting" | tee -a "$LOG"

RUN="sudo"
[ "$(id -u)" -eq 0 ] && RUN=""

# remove known-broken repos (etcher etc)
if grep -R "dl.bintray.com/etcher" /etc/apt/ -n >/dev/null 2>&1; then
  echo "$(date -Is) [AUTO-UPDATE] Removing dead Etcher repo" | tee -a "$LOG"
  $RUN sed -i '/dl.bintray.com\/etcher/d' /etc/apt/sources.list /etc/apt/sources.list.d/*.list 2>/dev/null || true
fi

echo "$(date -Is) [AUTO-UPDATE] apt update" | tee -a "$LOG"
if ! $RUN apt update -y >>"$LOG" 2>&1; then
  echo "$(date -Is) [AUTO-UPDATE] apt update had issues, continuing" | tee -a "$LOG"
fi

echo "$(date -Is) [AUTO-UPDATE] apt full-upgrade" | tee -a "$LOG"
$RUN DEBIAN_FRONTEND=noninteractive apt full-upgrade -y >>"$LOG" 2>&1 || echo "$(date -Is) [AUTO-UPDATE] upgrade partially failed" | tee -a "$LOG"

echo "$(date -Is) [AUTO-UPDATE] cleanup" | tee -a "$LOG"
$RUN apt autoremove -y >>"$LOG" 2>&1 || true
$RUN apt autoclean -y >>"$LOG" 2>&1 || true

echo "$(date -Is) [AUTO-UPDATE] Completed" | tee -a "$LOG"

if [ -f /var/run/reboot-required ]; then
  echo "Reboot required. Run 'sudo reboot' to finish updates."
fi
