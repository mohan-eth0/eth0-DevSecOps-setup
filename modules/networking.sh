#!/usr/bin/env bash
set -euo pipefail

echo "Installing Cloud & DevOps tools..."

# update first
if [ "$(id -u)" -eq 0 ]; then
  apt update -y
  apt install -y awscli ansible kubectl helm docker.io
else
  sudo apt update -y
  sudo apt install -y awscli ansible kubectl helm docker.io
fi

# Terraform is not in Debian main in many cases; install HashiCorp repo safely
if ! command -v terraform &>/dev/null; then
  echo "Installing Terraform (HashiCorp repo)..."
  sudo apt-get update -y
  sudo apt-get install -y gnupg software-properties-common curl
  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
  sudo apt update -y
  sudo apt install -y terraform
fi

echo "Cloud module installed!"
