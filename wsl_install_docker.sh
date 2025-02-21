#!/bin/bash

# Update the package list
sudo apt-get update

# Install necessary prerequisite packages
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    gnupg-agent

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker’s stable repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the package list again
sudo apt-get update

# Install Docker Engine, CLI, and Containerd
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Install Docker Compose
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Apply executable permissions to the binary
sudo chmod +x /usr/local/bin/docker-compose

# Verify installation
docker --version
docker-compose --version

# Add the current user to the Docker group to manage Docker as a non-root user
sudo groupadd docker || true
sudo usermod -aG docker $USER || true

# Set correct permissions for the Docker socket
sudo chown root:docker /var/run/docker.sock
sudo chmod 660 /var/run/docker.sock

# Inform the user to log out and back in for group changes to take effect
exec newgrp docker

echo "Docker and Docker Compose installation completed."
echo "Please log out and back in or restart your shells for the group changes to take effect."
