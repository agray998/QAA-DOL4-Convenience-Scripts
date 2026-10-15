#!/bin/bash

# Install common installation dependencies
sudo apt-get update
sudo apt-get install -y wget gnupg2 software-properties-common curl

# Install kubectl
K8S_VERSION="1.35.8"
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/$K8S_VERSION/2025-08-03/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin

# Verify kubectl installation
kubectl version --client