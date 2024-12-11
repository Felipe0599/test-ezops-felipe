#!/bin/bash

# Update packages 
echo "Updating packages..."
sudo apt-get update -y && sudo apt-get upgrade -y

# Install Dependencies
echo "Installing dependencies..."
sudo apt-get install -y curl wget apt-transport-https ca-certificates conntrack

# Download k0s
echo "Downloading k0s..."
curl -sSLf https://get.k0s.sh | sudo sh

# Verify k0s installation
echo "Checking k0s installation..."
k0s --version || { echo "Error installing k0s"; exit 1; }

# Initializes the cluster as a controller node
echo "Initializing k0s as controller..."
sudo k0s install controller --single

# Start k0s
echo "Starting the k0s service..."
sudo k0s start

# Enable k0s service to start on boot
echo "Enabling k0s service to start on boot..."
sudo systemctl enable k0scontroller

# Check k0s service status
echo "Checking k0s status..."
sudo k0s status || { echo "Error starting k0s"; exit 1; }

# Install kubectl
echo "Installing kubectl..."
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/

# Configure kubectl to manage the cluster
echo "Configuring kubectl..."
mkdir -p $HOME/.kube
sudo cp /var/lib/k0s/pki/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Test the cluster
echo "Testing the Kubernetes cluster..."
kubectl get nodes || { echo "Error checking cluster nodes"; exit 1; }

echo "Installation and configuration of k0s completed successfully!"

