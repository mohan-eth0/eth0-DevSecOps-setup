#!/usr/bin/env bash
echo "Installing Networking Tools..."

sudo apt install -y net-tools nmap tcpdump traceroute mtr iperf3 wireshark

echo "Applying Tmux Pro Config"
cp config/tmux.conf ~/.tmux.conf

echo "Networking setup completed!"
