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

# Start minikube with port exposure
echo "=== Starting minikube ==="
su - ubuntu -c "minikube start --driver=docker --cpus=2 --memory=2048 --ports=${nodeport}:${nodeport}"

# Wait for minikube to be ready
echo "=== Waiting for minikube ==="
su - ubuntu -c "minikube status"
su - ubuntu -c "kubectl cluster-info"

# Deploy K8s resources via kubectl
echo "=== Deploying K8s resources ==="
cat > /tmp/deployment.yaml << 'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: xbrain-app
  labels:
    app: xbrain
spec:
  replicas: 2
  selector:
    matchLabels:
      app: xbrain
  template:
    metadata:
      labels:
        app: xbrain
    spec:
      containers:
      - name: nginx
        image: ${docker_image}
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "64Mi"
            cpu: "100m"
          limits:
            memory: "128Mi"
            cpu: "200m"
---
apiVersion: v1
kind: Service
metadata:
  name: xbrain-service
  labels:
    app: xbrain
spec:
  type: NodePort
  selector:
    app: xbrain
  ports:
  - port: 80
    targetPort: 80
    nodePort: ${nodeport}
    protocol: TCP
YAML

su - ubuntu -c "kubectl apply -f /tmp/deployment.yaml"

# Wait for deployment
echo "=== Waiting for pods to be ready ==="
su - ubuntu -c "kubectl rollout status deployment/xbrain-app --timeout=300s"

# Show status
echo "=== Deployment Status ==="
su - ubuntu -c "kubectl get pods,svc"

echo "=== EC2 Setup Complete ==="
echo "K8s resources deployed successfully!"
echo "Service accessible on port ${nodeport}"
