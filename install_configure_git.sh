#!/bin/bash

USERNAME=$1
USEREMAIL=$2
test -z "$USERNAME" && echo "Error: Username is required." && exit 1
test -z "$USEREMAIL" && echo "Error: User email is required." && exit 1

# Install git
sudo apt-get update
sudo apt-get install -y git

# Configure git
git config --global user.name "$USERNAME"
git config --global user.email "$USEREMAIL"
git config --global init.defaultBranch main

# Verify
git --version
git config --list | grep -E 'user.name|user.email|'