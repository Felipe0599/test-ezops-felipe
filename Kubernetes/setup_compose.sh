#!/bin/bash

# Check if the script is being run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or with sudo."
  exit 1
fi

echo "Updating packages and installing necessary dependencies..."
apt-get update -y
apt-get upgrade -y
apt-get install -y curl wget jq

echo "Checking if Docker is installed..."
if ! command -v docker &> /dev/null; then
  echo "Docker not found. Installing Docker..."
  apt-get install -y \
    ca-certificates \
    gnupg \
    lsb-release

  mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

  apt-get update -y
  apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

  echo "Enabling and starting the Docker service..."
  systemctl enable docker
  systemctl start docker
else
  echo "Docker is already installed."
fi

echo "Checking for the latest version of Docker Compose..."
COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r .tag_name)

echo "Installing Docker Compose version $COMPOSE_VERSION..."
curl -L "https://github.com/docker/compose/releases/download/$COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

echo "Making Docker Compose executable..."
chmod +x /usr/local/bin/docker-compose

echo "Verifying Docker Compose installation..."
if command -v docker-compose &> /dev/null; then
  echo "Docker Compose installed successfully. Version:"
  docker-compose --version
else
  echo "Failed to install Docker Compose."
  exit 1
fi

echo "Finalizing configuration..."
groupadd docker || true
usermod -aG docker $USER

echo "Restart your session to apply the 'docker' group permissions."
