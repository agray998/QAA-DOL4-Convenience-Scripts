#!/bin/bash

# Install common installation dependencies
sudo apt-get update
sudo apt-get install -y wget gnupg2 software-properties-common curl apt-transport-https lsb-release ca-certificates unzip

# Install AWS CLI
curl -fsSL https://awscli.amazonaws.com/v2/install.sh | bash
export PATH="$PATH:$HOME/.local/bin"
echo "export PATH=$PATH:$HOME/.local/bin" | tee -a $HOME/.bashrc

# Install eksctl
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
sudo mv /tmp/eksctl /usr/local/bin

# Create a new EKS cluster
cat - >> cluster_config.yaml <<EOF
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig
metadata:
  name: my-cluster
  region: us-west-2
nodeGroups:
- name: ng-default
  instanceType: t3.medium
  desiredCapacity: 2
  minSize: 1
  maxSize: 3
EOF
eksctl create cluster -f cluster_config.yaml