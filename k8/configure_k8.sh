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

cat >/tmp/kubeadm-config.yaml<<EOF
kind: ClusterConfiguration
apiVersion: kubeadm.k8s.io/v1beta3
kubernetesVersion: v1.24.0
---
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
cgroupDriver: systemd
EOF

sudo kubeadm init --apiserver-advertise-address $(hostname -I | awk '{print $1}') --pod-network-cidr ${CIDR}  --config kubeadm-config.yaml | tee /tmp/kubeadminit.log || exit $?

sudo mkdir -p $HOME/.kube

sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

sudo chown $(id -u):$(id -g) $HOME/.kube/config

#kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f https://docs.projectcalico.org/v3.14/manifests/calico.yaml

kubectl get pods --all-namespaces

kubectl get nodes
