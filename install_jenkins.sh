#!/bin/bash

# Install common installation dependencies
sudo apt-get update
sudo apt-get install -y curl wget gnupg2 ca-certificates apt-transport-https software-properties-common

# Install JRE
sudo apt-get install -y openjdk-21-jre

# Get Jenkins public GPG key
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

# Add Jenkins repo to sources list
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Install Jenkins
sudo apt-get update
sudo apt-get install -y jenkins

# Ensure Jenkins service is enabled and started
sudo systemctl enable --now jenkins

# Print server info
echo "Jenkins installation complete!"
echo "Server should be accessible at http://$(curl ifconfig.io):8080"
echo "Initial admin password is: $(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)"