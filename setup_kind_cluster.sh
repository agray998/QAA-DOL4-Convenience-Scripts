#!/bin/bash -ex
set -euo pipefail

CLUSTER_NAME=lab-cluster

FILE=/config_run
if [ -f "$FILE" ]; then
  echo "$FILE exists. Setup has already been run."
  exit 0
else
  echo "$FILE does not exist. Running script"
fi

# Ensure Docker permissions are set
if ! docker ps >/dev/null 2>&1; then
  which docker && exec sg docker -c "$0" || exit 1 # re-exec inside docker group if docker is installed, otherwise quit
fi

echo "[1/5] Install kubectl..."
if ! command -v kubectl >/dev/null 2>&1; then
  curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  sudo install -m 0755 kubectl /usr/local/bin/kubectl
  rm kubectl
fi

echo "[2/5] Install KinD..."
if ! command -v kind >/dev/null 2>&1; then
  curl -Lo ./kind "https://kind.sigs.k8s.io/dl/v0.33.0/kind-linux-amd64"
  chmod +x ./kind && sudo mv ./kind /usr/local/bin/kind
fi

echo "[3/5] Create 3-node KinD cluster (1 control-plane + 2 workers) with host port mappings..."
cat > kind-config.yaml <<EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
EOF

if ! kind get clusters 2>/dev/null | grep -q $CLUSTER_NAME; then
  kind create cluster --name $CLUSTER_NAME --config kind-config.yaml
  # need to capture the config file and give it ql-user
else
  echo "[*] KinD cluster $CLUSTER_NAME already exists, skipping creation."
fi
kubectl cluster-info --context kind-$CLUSTER_NAME >/dev/null

echo "[4/5] Make life easier"
echo
mkdir -p /home/$USER/.kube
kind get kubeconfig --name $CLUSTER_NAME > /home/$USER/.kube/config
echo "source <(kubectl completion bash)" >>  /home/$USER/.bashrc
echo "alias k=kubectl" >> /home/$USER/.bashrc
echo "complete -F __start_kubectl k" >> /home/$USER/.bashrc
curl -sSL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
echo "source <(helm completion bash)" >>  /home/$USER/.bashrc
echo "set expandtab" >>  /home/$USER/.vimrc
echo "set tabstop=2" >>  /home/$USER/.vimrc
echo "sudo chown -R $USER:1000 /home/$USER" >> /home/$USER/.bashrc

echo "[5/5] All done!"

sudo touch $FILE