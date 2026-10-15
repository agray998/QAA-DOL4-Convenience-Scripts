#!/bin/bash

# Add Ansible repo
sudo apt-get update
sudo apt-add-repository --yes --update ppa:ansible/ansible

# Install Ansible
sudo apt-get install -y ansible

# Verify Ansible installation
ansible --version