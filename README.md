# eth0-DevSecOps-setup

Automated Debian installer for Cloud, Networking, Security, DevSecOps and Cybersecurity tools.

This script helps you convert a fresh Debian installation into a fully functional workstation or lab environment — in minutes.

---

## Features

- Automatic package installation based on role
- Supports Cloud, Networking, Security, DevSecOps & Cybersecurity
- Installs essential system utilities
- Optional firewall hardening using UFW
- Fully automated terminal-based setup

---

## Installation

Clone the repository:

```bash
git clone https://github.com/mohan-eth0/eth0-DevSecOps-setup.git
cd eth0-DevSecOps-setup
```

Make the script executable:

```bash
chmod +x eth0-devsecops-setup.sh
```

Run:

```bash
sudo ./eth0-devsecops-setup.sh
```

---

## Setup Modes

### **1. Cloud Engineer**
Includes tools:
- awscli
- ansible
- docker.io
- kubectl
- python-boto3
- azure-cli

### **2. Networking**
Includes:
- tcpdump
- nmap
- net-tools
- traceroute
- wireshark
- ethtool

### **3. Network Security**
- suricata
- fail2ban
- lynis
- clamav
- rkhunter
- auditd

### **4. DevSecOps**
- docker / docker-compose
- ansible
- terraform
- kubectl
- trivy
- git
- jq

### **5. Cybersecurity**
- hydra
- aircrack-ng
- sqlmap
- john
- nikto
- hashcat

---

## Requirements

- Debian 12 / 13
- Internet connection
- sudo privileges

---

## Author

**Mohan (eth0)**  
Linux | Security | DevOps | Networking

---

## License

This project is licensed under the MIT License.  
See the `LICENSE` file for details.
