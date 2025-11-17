uninstall_all() {
    echo "🧹 Removing DevSecOps installed tools..."

    apt remove --purge -y suricata nikto zaproxy metasploit-framework gobuster hashcat \
        ansible docker.io docker-compose wireshark nmap \
        openvpn openvas gvm golang rustc cargo terraform awscli azure-cli k6 \
        python3-pip fail2ban

    rm -rf /var/lib/docker /etc/docker
    rm -rf /etc/suricata /var/log/suricata
    rm -rf ~/.local/bin/aws
    rm -rf ~/.local/bin/terraform
    rm -rf ~/.cargo
    rm -rf ~/.go

    echo "⚠️  Core system packages NOT removed: sudo, git, ifupdown"

    echo "✅ Uninstall completed safely!"
}
