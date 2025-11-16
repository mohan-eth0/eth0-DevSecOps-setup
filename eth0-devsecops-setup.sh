#!/bin/bash
# ===========================================================
# Debian Pro Installer Package
# Sets up essential pro tools based on user-selected focus
# Options: cloud, networking, network-security, cybersecurity
# ===========================================================

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}Welcome to Debian Pro Installer${NC}"
echo "Select the configuration type you want to install:"
echo "1) Cloud"
echo "2) Networking"
echo "3) Network Security"
echo "4) Cybersecurity"

read -rp "Enter option number (1-4): " option

case $option in
  1)
    config_type="cloud"
    ;;
  2)
    config_type="networking"
    ;;
  3)
    config_type="network-security"
    ;;
  4)
    config_type="cybersecurity"
    ;;
  *)
    echo -e "${RED}Invalid option. Exiting.${NC}"
    exit 1
    ;;
esac

echo -e "${GREEN}You selected: $config_type${NC}"
echo "Updating package list..."
sudo apt update -qq

install_packages() {
  echo -e "${YELLOW}Installing packages: $*${NC}"
  sudo apt install -y "$@"
}

# Define package lists for each category

cloud_packages=(
  awscli
  azure-cli
 # google-cloud-sdk
 # terraform
  kubectl
  #helm
  ansible
  docker.io
  python3-boto3
)

networking_packages=(
  iproute2
  net-tools
  traceroute
  wireshark
  tcpdump
  nmap
  ethtool
  iputils-ping
  openvpn
  strongswan
)

network_security_packages=(
  fail2ban
  ufw
#  snort
  suricata
  clamav
  rkhunter
  chkrootkit
  auditd
  lynis
)

cybersecurity_packages=(
#  metasploit-framework
  wireshark
  john
  hydra
  nikto
  sqlmap
  aircrack-ng
 # burpsuite
  hashcat
  nmap
)


# Check and add missing repos if necessary
if ! grep -q 'deb http://deb.debian.org/debian trixie main' /etc/apt/sources.list; then
  echo "Adding main Debian repositories to sources.list..."
  echo "deb http://deb.debian.org/debian trixie main contrib non-free" | sudo tee -a /etc/apt/sources.list
  echo "deb http://security.debian.org/debian-security trixie-security main contrib non-free" | sudo tee -a /etc/apt/sources.list
  echo "deb http://deb.debian.org/debian trixie-updates main contrib non-free" | sudo tee -a /etc/apt/sources.list
  sudo apt update
fi

# Proceed with installations
#sudo apt install -y snort


echo "Starting installation of basic tools needed system-wide..."
install_packages sudo vim curl wget git build-essential

case $config_type in
  cloud)
    install_packages "${cloud_packages[@]}"
    ;;
  networking)
    install_packages "${networking_packages[@]}"
    ;;
  network-security)
    install_packages "${network_security_packages[@]}"
    ;;
  cybersecurity)
    install_packages "${cybersecurity_packages[@]}"
    ;;
esac

echo -e "${GREEN}Installation complete for $config_type tools.${NC}"

echo "Setting up basic configurations..."

# Example: Enable and start UFW if installed for security-related configs
if dpkg-query -W -f='${Status}' ufw 2>/dev/null | grep -q "ok installed"; then
  echo "Enabling and starting UFW firewall..."
  sudo ufw default deny incoming
  sudo ufw default allow outgoing
  sudo ufw allow ssh
  sudo ufw enable
fi

echo -e "${GREEN}Setup finished. Please reboot your machine if prompted.${NC}"z






