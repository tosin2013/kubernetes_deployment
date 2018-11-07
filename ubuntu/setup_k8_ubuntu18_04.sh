#!/bin/bash
set -xe

if [[ ! -f kube_env ]]; then
    echo "kube_env file not found please populated with required values"
    exit 1
fi

source kube_env

if [[ $CIDR == "" ]]; then
    echo "Please populate CIDR range"
    exit $?
fi

sudo docker pull k8s.gcr.io/kube-scheduler-amd64:v1.10.1
sudo docker pull k8s.gcr.io/etcd-amd64:3.1.12
sudo docker pull  k8s.gcr.io/kube-apiserver-amd64:v1.10.1
sudo docker pull k8s.gcr.io/kube-controller-manager-amd64:v1.10.1

sudo kubeadm init --pod-network-cidr=${CIDR} | tee /tmp/kubeadminit.log || exit $?

mkdir -p $HOME/.kube

sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

kubectl get pods --all-namespaces

kubectl get nodes
