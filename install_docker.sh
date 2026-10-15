#!/bin/bash

# Install common installation dependencies
sudo apt-get update
sudo apt-get install -y wget gnupg2 software-properties-common ca-certificates apt-transport-https lsb-release

# Install Docker components
curl -fsSL https://get.docker.com | sudo bash

# Add current user to docker group
sudo gpasswd -a $USER docker

# Finish installation and print next step
echo "Docker is installed!"
echo "To run docker commands without root, run: 'exec su -l $USER' to apply group changes"
