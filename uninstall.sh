#!/usr/bin/env bash
set -euo pipefail

PROTECT=('sudo' 'git' 'apt' 'dpkg' 'bash' 'coreutils')

echo "🧹 Starting safe uninstall of installed modules (core packages protected)."

# list of removable packages installed by this project
REMOVALS=(suricata nikto zaproxy metasploit-framework gobuster hashcat ansible docker.io docker-compose wireshark nmap openvpn openvas gvm golang rustc cargo terraform awscli azure-cli k6 python3-pip fail2ban)

# filter installed ones
TO_REMOVE=()
for p in "${REMOVALS[@]}"; do
  if dpkg -s "$p" &>/dev/null; then
    TO_REMOVE+=("$p")
  fi
done

if [ ${#TO_REMOVE[@]} -gt 0 ]; then
  echo "Packages to remove: ${TO_REMOVE[*]}"
  sudo apt remove --purge -y "${TO_REMOVE[@]}"
  sudo apt autoremove -y
else
  echo "No removable packages found."
fi

# clean runtime files (only those installed by modules)
[ -d /var/lib/docker ] && sudo rm -rf /var/lib/docker
[ -d /etc/suricata ] && sudo rm -rf /etc/suricata /var/log/suricata
[ -f ~/.local/bin/aws ] && rm -f ~/.local/bin/aws
[ -f ~/.local/bin/terraform ] && rm -f ~/.local/bin/terraform

echo "✅ Safe uninstall completed. Core system packages have been preserved: ${PROTECT[*]}"

