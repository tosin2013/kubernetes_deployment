#!/bin/bash
set -xe

sudo docker pull k8s.gcr.io/kube-scheduler-amd64:v1.10.1
sudo docker pull k8s.gcr.io/etcd-amd64:3.1.12
sudo docker pull  k8s.gcr.io/kube-apiserver-amd64:v1.10.1
sudo docker pull k8s.gcr.io/kube-controller-manager-amd64:v1.10.1

sudo kubeadm init --pod-network-cidr=10.244.0.0/16
