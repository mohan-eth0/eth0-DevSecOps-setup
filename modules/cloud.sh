#!/usr/bin/env bash
set -euo pipefail

LOG="/var/log/eth0-cloud.log"
echo "$(date -Is) [CLOUD] Starting" | tee -a "$LOG"

RUN="sudo"
[ "$(id -u)" -eq 0 ] && RUN=""

# remove dead etcher repo if present (preflight)
if grep -R "dl.bintray.com/etcher" /etc/apt/ -n >/dev/null 2>&1; then
  echo "$(date -Is) [CLOUD] Removing dead Etcher repo" | tee -a "$LOG"
  $RUN sed -i '/dl.bintray.com\/etcher/d' /etc/apt/sources.list /etc/apt/sources.list.d/*.list 2>/dev/null || true
fi

echo "$(date -Is) [CLOUD] apt update" | tee -a "$LOG"
$RUN apt update -y >>"$LOG" 2>&1 || echo "$(date -Is) [CLOUD] apt update had issues" | tee -a "$LOG"

echo "$(date -Is) [CLOUD] Installing common tools" | tee -a "$LOG"
$RUN apt install -y apt-transport-https ca-certificates gnupg curl lsb-release >>"$LOG" 2>&1 || true
$RUN apt install -y awscli ansible kubectl helm docker.io git jq >>"$LOG" 2>&1 || true

# Terraform via HashiCorp repo (idempotent)
if ! command -v terraform &>/dev/null; then
  echo "$(date -Is) [CLOUD] Installing Terraform from HashiCorp" | tee -a "$LOG"
  $RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | $RUN gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg 2>/dev/null || true
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | $RUN tee /etc/apt/sources.list.d/hashicorp.list >/dev/null
  $RUN apt update -y >>"$LOG" 2>&1 || true
  $RUN apt install -y terraform >>"$LOG" 2>&1 || echo "$(date -Is) [CLOUD] terraform install failed" | tee -a "$LOG"
fi

echo "$(date -Is) [CLOUD] Completed" | tee -a "$LOG"
