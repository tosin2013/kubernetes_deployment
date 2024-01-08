#!/bin/bash
#set -e

# Disable swap
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Install required packages for Kubernetes apt repository
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg

# Download the Kubernetes signing key and add it to the keyring
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Add the Kubernetes apt repository for version 1.29
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update the apt package index and install Kubernetes components
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl

# Pin the versions of Kubernetes components to prevent automatic updates
sudo apt-mark hold kubelet kubeadm kubectl
