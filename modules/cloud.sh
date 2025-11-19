#!/usr/bin/env bash

echo "Installing Cloud & DevOps tools..."

# -----------------------------
# UPDATE
# -----------------------------
sudo apt update -y

# -----------------------------
# Install basic tools
# -----------------------------
sudo apt install -y curl wget gnupg lsb-release ca-certificates apt-transport-https

# -----------------------------
# Terraform
# -----------------------------
if ! command -v terraform >/dev/null 2>&1; then
    echo "Installing Terraform..."
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
        sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update -y
    sudo apt install -y terraform
else
    echo "Terraform already installed."
fi

# -----------------------------
# AWS CLI
# -----------------------------
if ! command -v aws >/dev/null 2>&1; then
    echo "Installing AWS CLI..."
    curl -sSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -o awscliv2.zip
    sudo ./aws/install
    rm -rf aws awscliv2.zip
else
    echo "AWS CLI already installed."
fi

# -----------------------------
# Docker
# -----------------------------
if ! command -v docker >/dev/null 2>&1; then
    echo "Installing Docker..."
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] \
https://download.docker.com/linux/debian $(lsb_release -cs) stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt update -y
    sudo apt install -y docker-ce docker-ce-cli containerd.io
else
    echo "Docker already installed."
fi

# -----------------------------
# Kubectl
# -----------------------------
if ! command -v kubectl >/dev/null 2>&1; then
    echo "Installing kubectl..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm kubectl
else
    echo "kubectl already installed."
fi

# -----------------------------
# Helm (OFFICIAL installation – FIX)
# -----------------------------
if ! command -v helm >/dev/null 2>&1; then
    echo "Installing Helm..."
    curl https://baltocdn.com/helm/signing.asc | sudo gpg --dearmor -o /usr/share/keyrings/helm.gpg
    echo "deb [signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main"

