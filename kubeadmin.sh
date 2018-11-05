#!/bin/bash
#set -xe
kubeadm  -v  > /dev/null 2>/dev/null
RESULT=$?
if [ $RESULT -eq 0 ]; then
  echo "Skipping kubeadm, kubelet and kubectl installation"
else
    echo -e "\e[92mInstalling kubeadm, kubelet and kubectl\e[0m"
    echo -e "
    \e[1mkubeadm:\e[0m the command to bootstrap the cluster.
    \e[1mkubelet:\e[0m the component that runs on all of the machines in your cluster and does things like starting pods and containers.
    \e[1mkubectl:\e[0m the command line util to talk to your cluster."
    sleep 5s
     sudo apt-get update && sudo apt-get install -y sudo apt-transport-https curl
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
    sudo apt-get update -y 
    sudo apt-get install -y kubelet kubeadm kubectl || exit $?
    sudo apt-mark hold kubelet kubeadm kubectl || exit $?
fi
