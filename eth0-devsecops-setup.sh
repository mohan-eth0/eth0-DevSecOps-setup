#!/usr/bin/env bash
set -euo pipefail

LOGFILE="/var/log/eth0-setup.log"
mkdir -p "$(dirname "$LOGFILE")"
exec 3>&1 1>>"$LOGFILE" 2>&1

RED="\e[31m"; GREEN="\e[32m"; YELLOW="\e[33m"; NC="\e[0m"

cleanup() {
  echo "$(date -Is) [INFO] Cleanup and exit" >&3
}
trap cleanup EXIT

# ensure running on Debian
if [ -f /etc/debian_version ]; then
  echo "$(date -Is) [INFO] Detected Debian" >&3
else
  echo "This installer supports Debian only. Exiting." >&3
  exit 1
fi

# ensure sudo exists (if not running as root)
if ! command -v sudo &>/dev/null && [ "$(id -u)" -ne 0 ]; then
  echo "sudo not found and not running as root. Please run as root or install sudo." >&3
  exit 1
fi

show_logo() {
  clear
  cat <<'EOF' >&3
 ███████╗████████╗██╗  ██╗ ██████╗      
 ██╔════╝╚══██╔══╝██║ ██╔╝██╔═══██╗     
 ███████╗   ██║   █████╔╝ ██║   ██║     
 ╚════██║   ██║   ██╔═██╗ ██║   ██║     
 ███████║   ██║   ██║  ██╗╚██████╔╝     
 ╚══════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝      
        Mohan’s DevSecOps Workstation
-----------------------------------------
EOF
}

ensure_update() {
  # call before apt installs from modules
  if [ "$(id -u)" -eq 0 ]; then
    apt update -y
  else
    sudo apt update -y
  fi
}

main_menu() {
    show_logo
    echo -e "${YELLOW}Choose Module:${NC}" >&3
    echo "1) Networking" >&3
    echo "2) Cybersecurity" >&3
    echo "3) Cloud" >&3
    echo "4) Productivity" >&3
    echo "5) Auto Update" >&3
    echo "6) Health Check" >&3
    echo "7) Uninstall All" >&3
    echo "0) Exit" >&3
    read -p "Enter choice: " opt
    case $opt in
        1) ensure_update; bash modules/networking.sh ;;
        2) ensure_update; bash modules/cybersecurity.sh ;;
        3) ensure_update; bash modules/cloud.sh ;;
        4) ensure_update; bash modules/productivity.sh ;;
        5) bash modules/auto-update.sh ;;
        6) bash health-check.sh ;;
        7) bash uninstall.sh ;;
        0) exit 0 ;;
        *) echo "Invalid option" >&3 ;;
    esac
}

main_menu

