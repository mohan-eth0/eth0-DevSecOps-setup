#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------
# LOGGING FIX  (don't hijack terminal output)
# -----------------------------------------
LOGFILE="/var/log/eth0-setup.log"
mkdir -p "$(dirname "$LOGFILE")"

# Duplicate output: write to screen + log
log() {
    echo "$@" | tee -a "$LOGFILE"
}

# -----------------------------------------
# Color
# -----------------------------------------
RED="\e[31m"; GREEN="\e[32m"; YELLOW="\e[33m"; NC="\e[0m"

cleanup() {
  log "$(date -Is) [INFO] Cleanup and exit"
}
trap cleanup EXIT

# -----------------------------------------
# Debian check
# -----------------------------------------
if [ ! -f /etc/debian_version ]; then
  log "❌ This installer supports Debian only."
  exit 1
fi

log "$(date -Is) [INFO] Detected Debian"

# -----------------------------------------
# Ensure sudo exists if needed
# -----------------------------------------
if ! command -v sudo &>/dev/null && [ "$(id -u)" -ne 0 ]; then
  log "❌ sudo not found and not running as root."
  exit 1
fi

# -----------------------------------------
# Show Logo
# -----------------------------------------
show_logo() {
clear
cat <<'EOF'
███████╗████████╗██╗  ██╗ ██████╗ 
██╔════╝╚══██╔══╝██║  ██║██╔═══██╗
█████╗     ██║   ███████║██║   ██║
██╔══╝     ██║   ██╔══██║██║   ██║
███████╗   ██║   ██║  ██║╚██████╔╝
╚══════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ 
      ETH0 DevSecOps Workstation
-----------------------------------------
EOF
}

ensure_update() {
  if [ "$(id -u)" -eq 0 ]; then
    apt update -y | tee -a "$LOGFILE"
  else
    sudo apt update -y | tee -a "$LOGFILE"
  fi
}

# -----------------------------------------
# MAIN MENU
# -----------------------------------------
main_menu() {
while true; do
    show_logo
    echo -e "${YELLOW}Choose Module:${NC}"
    echo "1) Networking"
    echo "2) Cybersecurity"
    echo "3) Cloud"
    echo "4) Productivity"
    echo "5) Auto Update"
    echo "6) Health Check"
    echo "0) Exit"
    echo ""

    read -p "Enter choice: " opt

    case $opt in
        1) ensure_update; bash modules/networking.sh ;;
        2) ensure_update; bash modules/cybersecurity.sh ;;
        3) ensure_update; bash modules/cloud.sh ;;
        4) ensure_update; bash modules/productivity.sh ;;
        5) bash modules/auto-update.sh ;;
        6) bash health-check.sh ;;
        0) log "Exiting..."; exit 0 ;;
        *) echo "❌ Invalid option"; sleep 1 ;;
    esac

    echo ""
    read -p "Press ENTER to return to menu..." _
done
}

main_menu

