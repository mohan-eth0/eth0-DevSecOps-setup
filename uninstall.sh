#!/usr/bin/env bash
echo "Removing all installed tools..."

sudo apt remove --purge -y \
net-tools nmap tcpdump traceroute mtr iperf3 wireshark \
john hydra nikto sqlmap gobuster wfuzz \
awscli ansible terraform kubectl helm \
zsh neofetch htop

rm -f ~/.tmux.conf ~/.zshrc ~/.aliases

echo "All tools removed. Cleanup done!"
