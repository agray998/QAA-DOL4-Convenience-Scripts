#!/bin/bash

# Install common installation dependencies
sudo apt-get update
sudo apt-get install -y wget gnupg2 software-properties-common curl apt-transport-https lsb-release ca-certificates unzip

# Install AWS CLI
curl -fsSL https://awscli.amazonaws.com/v2/install.sh | bash
export PATH="$PATH:$HOME/.local/bin"
echo "export PATH=$PATH:$HOME/.local/bin" | tee -a $HOME/.bashrc
echo "When prompted, enter your AWS Access Key ID and Secret Access Key to configure the AWS CLI."
aws configure

# Install eksctl
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
sudo mv /tmp/eksctl /usr/local/bin

# Install kubectl
K8S_VERSION="1.35.8"
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/$K8S_VERSION/2025-08-03/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin

# Create a new EKS cluster
CLUSTER_NAME="my-cluster"
REGION="eu-west-1"
cat - >> cluster_config.yaml <<EOF
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig
metadata:
  name: ${CLUSTER_NAME}
  region: ${REGION}
  version: ${K8S_VERSION}
nodeGroups:
- name: ng-default
  instanceType: t3.medium
  desiredCapacity: 2
  minSize: 1
  maxSize: 3
EOF
eksctl create cluster -f cluster_config.yaml
aws eks update-kubeconfig --region $REGION --name $CLUSTER_NAME