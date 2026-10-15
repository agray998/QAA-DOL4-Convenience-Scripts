#!/bin/bash

# Install wget, curl and unzip if not already installed
sudo apt-get update
sudo apt-get install -y wget curl unzip

# Download and install Terraform
TERRAFORM_VERSION="1.16.6"
wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
sudo mv terraform /usr/local/bin/

# Verify Terraform installation
terraform version