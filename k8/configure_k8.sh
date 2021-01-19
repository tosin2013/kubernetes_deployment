#!/bin/bash
#https://stackoverflow.com/questions/53256739/which-kubernetes-version-is-supported-in-docker-version-18-09
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

#sudo docker pull k8s.gcr.io/kube-scheduler-amd64:v1.10.1
#sudo docker pull k8s.gcr.io/etcd-amd64:3.1.12
#sudo docker pull  k8s.gcr.io/kube-apiserver-amd64:v1.10.1
#sudo docker pull k8s.gcr.io/kube-controller-manager-amd64:v1.10.1

sudo kubeadm init --apiserver-advertise-address $(hostname -I | awk '{print $1}') --pod-network-cidr ${CIDR} | tee /tmp/kubeadminit.log || exit $?

sudo mkdir -p $HOME/.kube

sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

sudo chown $(id -u):$(id -g) $HOME/.kube/config

#kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f https://docs.projectcalico.org/v3.14/manifests/calico.yaml

kubectl get pods --all-namespaces

kubectl get nodes
