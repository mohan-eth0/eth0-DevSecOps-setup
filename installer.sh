
```bash
#!/bin/bash
echo "🔥 Installing ETH0 DevSecOps Setup..."

git clone https://github.com/mohan-eth0/eth0-DevSecOps-setup.git /tmp/eth0-setup

cd /tmp/eth0-setup || exit

chmod +x eth0-devsecops-setup.sh modules/*.sh uninstall.sh health-check.sh

sudo ./eth0-devsecops-setup.sh

chmod +x installer.sh

