#!/bin/bash
# ======================================================================
#  Debian Pro Installer - Advanced Edition (v2.0)
#  Author: Mohan (eth0)
#  Description:
#      A complete modular Debian workstation builder for:
#      - Cloud
#      - Networking
#      - Network Security
#      - Cybersecurity
#      - System Health Check
#
#  Features:
#      ✔ Banner Logo
#      ✔ Logging System
#      ✔ Modular Package Installer
#      ✔ Auto Repo Fixer
#      ✔ Health Check Module
#      ✔ Optional Uninstaller
# ======================================================================

set -e

LOGFILE="/var/log/debian-pro-installer.log"
touch "$LOGFILE"

# ======================================================================
# COLORS
# ======================================================================
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# ======================================================================
# ASCII LOGO
# ======================================================================
echo -e "
███████╗████████╗██╗  ██╗
██╔════╝╚══██╔══╝██║  ██║
█████╗     ██║   ███████║
██╔══╝     ██║   ██╔══██║
███████╗   ██║   ██║  ██║
╚══════╝   ╚═╝   ╚═╝  ╚═╝   Debian Pro Installer v2.0 by Mohan
"

# ======================================================================
# LOGGING FUNCTION
# ======================================================================
log() {
    echo -e "$1" | tee -a "$LOGFILE"
}

# ======================================================================
# PACKAGE INSTALL FUNCTION
# ======================================================================
install_packages() {
    log "${YELLOW}Installing: $*${NC}"
    sudo apt install -y "$@" >> "$LOGFILE" 2>&1
}

# ======================================================================
# PACKAGE GROUPS
# ======================================================================
cloud_packages=( awscli azure-cli kubectl ansible docker.io python3-boto3 )
networking_packages=( iproute2 net-tools traceroute wireshark tcpdump nmap ethtool iputils-ping openvpn strongswan )
network_security_packages=( fail2ban ufw suricata clamav rkhunter chkrootkit auditd lynis )
cybersecurity_packages=( wireshark john hydra nikto sqlmap aircrack-ng hashcat nmap )
basic_packages=( sudo vim curl wget git build-essential )

# ======================================================================
# REPO FIXER
# ======================================================================
fix_repos() {
    if ! grep -q 'deb http://deb.debian.org/debian trixie main' /etc/apt/sources.list; then
        log "${YELLOW}Fixing missing repositories...${NC}"
        sudo tee -a /etc/apt/sources.list >/dev/null <<EOF
deb http://deb.debian.org/debian trixie main contrib non-free
deb http://security.debian.org/debian-security trixie-security main contrib non-free
deb http://deb.debian.org/debian trixie-updates main contrib non-free
EOF
        sudo apt update -y
    fi
}

# ======================================================================
# HEALTH CHECK MODULE
# ======================================================================
health_check() {
    echo -e "${YELLOW}Running System Health Check...${NC}"
    echo "------------------------------------------"

    echo -e "\n[✔] SYSTEM INFO"
    hostnamectl

    echo -e "\n[✔] DISK USAGE"
    df -h /

    echo -e "\n[✔] MEMORY"
    free -h

    echo -e "\n[✔] NETWORK → IP ADDRESS"
    ip a | grep inet

    echo -e "\n[✔] RUNNING SERVICES"
    systemctl --type=service --state=running | head -20

    echo -e "\n[✔] SECURITY STATUS"
    command -v ufw >/dev/null && ufw status
    command -v fail2ban-client >/dev/null && fail2ban-client status

    echo -e "${GREEN}\nHealth Check Completed.${NC}"
}

# ======================================================================
# UNINSTALLER
# ======================================================================
uninstall_all() {
    echo -e "${RED}WARNING: This will remove ALL installed packages!${NC}"
    read -rp "Are you sure? (y/n): " confirm
    [[ "$confirm" != "y" ]] && exit 0

    all_groups=(
       "${cloud_packages[@]}"
       "${networking_packages[@]}"
       "${network_security_packages[@]}"
       "${cybersecurity_packages[@]}"
       "${basic_packages[@]}"
    )

    sudo apt remove --purge -y "${all_groups[@]}" 2>/dev/null || true
    sudo apt autoremove -y
    sudo apt clean

    echo -e "${GREEN}All components removed successfully.${NC}"
}

# ======================================================================
# MAIN MENU
# ======================================================================
echo -e "${YELLOW}Choose your configuration:${NC}"
echo "1) Cloud"
echo "2) Networking"
echo "3) Network Security"
echo "4) Cybersecurity"
echo "5) System Health Check"
echo "6) Uninstall Debian Pro Setup"

read -rp "Enter choice (1-6): " option

# ======================================================================
# UPDATE + FIX REPOSITORIES
# ======================================================================
log "${GREEN}Updating package list...${NC}"
sudo apt update -y >> "$LOGFILE" 2>&1
fix_repos

# ======================================================================
# INSTALL BASIC TOOLS
# ======================================================================
log "${GREEN}Installing base tools...${NC}"
install_packages "${basic_packages[@]}"

# ======================================================================
# ACTION HANDLER
# ======================================================================
case $option in
    1)
        log "${GREEN}Installing Cloud Stack...${NC}"
        install_packages "${cloud_packages[@]}"
        ;;
    2)
        log "${GREEN}Installing Networking Stack...${NC}"
        install_packages "${networking_packages[@]}"
        ;;
    3)
        log "${GREEN}Installing Network Security Stack...${NC}"
        install_packages "${network_security_packages[@]}"
        ;;
    4)
        log "${GREEN}Installing Cybersecurity Stack...${NC}"
        install_packages "${cybersecurity_packages[@]}"
        ;;
    5)
        health_check
        exit 0
        ;;
    6)
        uninstall_all
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid choice. Exiting.${NC}"
        exit 1
        ;;
esac

# ======================================================================
# POST-INSTALL SECURITY CONFIG
# ======================================================================
if dpkg -l | grep -q ufw; then
    log "${YELLOW}Configuring UFW firewall...${NC}"
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw allow ssh
    sudo ufw enable
fi

log "${GREEN}Installation Completed Successfully.${NC}"
echo -e "${GREEN}Your Debian system is now ready! 🚀${NC}"
