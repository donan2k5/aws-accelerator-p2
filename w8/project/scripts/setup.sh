#!/bin/bash
set -e

echo "=== Starting EC2 Setup ==="
echo "Docker image: ${docker_image}"
echo "NodePort: ${nodeport}"

# Update system
apt-get update
apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg \
  lsb-release \
  git \
  wget \
  jq

# Install Docker
echo "=== Installing Docker ==="
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Start Docker
systemctl start docker
systemctl enable docker
usermod -aG docker ubuntu

# Install kubectl
echo "=== Installing kubectl ==="
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/

# Install minikube
echo "=== Installing minikube ==="
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
chmod +x minikube-linux-amd64
mv minikube-linux-amd64 /usr/local/bin/minikube

# Install Helm
echo "=== Installing Helm ==="
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Start minikube
echo "=== Starting minikube ==="
su - ubuntu -c "minikube start --driver=docker --cpus=2 --memory=2048"

# Wait for minikube to be ready
echo "=== Waiting for minikube ==="
su - ubuntu -c "minikube status"
su - ubuntu -c "kubectl cluster-info"

echo "=== EC2 Setup Complete ==="
echo "Minikube is running. Ready for Terraform Helm provider to deploy apps."
