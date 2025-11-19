#!/usr/bin/env bash

echo "=========================================="
echo "     Installing Networking Tools"
echo "=========================================="

sudo apt update -y

echo "Installing basic networking utilities..."
sudo apt install -y net-tools iproute2 iputils-ping traceroute dnsutils curl wget

echo "Installing advanced networking tools..."
sudo apt install -y nmap tcpdump tshark whois ldnsutils openssh-client openvpn

echo "Installing packet analysis and firewall tools..."
sudo apt install -y wireshark-qt ufw nftables iptables

echo "Enabling UFW firewall..."
sudo ufw enable

echo ""
echo "=========================================="
echo " Networking Tools Installed Successfully! "
echo "=========================================="
echo ""

