#!/usr/bin/env bash
# ============================================================
#  Mohan’s DevSecOps Workstation Setup
#  Full Modular Automated Installer
# ============================================================

RED="\e[31m"; GREEN="\e[32m"; YELLOW="\e[33m"; NC="\e[0m"

show_logo() {
clear
cat << 'EOF'
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

main_menu() {
    show_logo
    echo -e "${YELLOW}Choose Module:${NC}"
    echo "1) Networking"
    echo "2) Cybersecurity"
    echo "3) Cloud"
    echo "4) Productivity"
    echo "5) Auto Update"
    echo "6) Health Check"
    echo "7) Uninstall All"
    echo "0) Exit"
    read -p "Enter choice: " opt

    case $opt in
        1) bash modules/networking.sh ;;
        2) bash modules/cybersecurity.sh ;;
        3) bash modules/cloud.sh ;;
        4) bash modules/productivity.sh ;;
        5) bash modules/auto-update.sh ;;
        6) bash health-check.sh ;;
        7) bash uninstall.sh ;;
        0) exit 0 ;;
        *) echo "Invalid option" ;;
    esac
}

main_menu

