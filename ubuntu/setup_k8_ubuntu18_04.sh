#!/bin/bash
set -xe

#THANKS: https://www.linuxjournal.com/content/validating-ip-address-bash-script
function valid_ip()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}


sudo docker pull k8s.gcr.io/kube-scheduler-amd64:v1.10.1
sudo docker pull k8s.gcr.io/etcd-amd64:3.1.12
sudo docker pull  k8s.gcr.io/kube-apiserver-amd64:v1.10.1
sudo docker pull k8s.gcr.io/kube-controller-manager-amd64:v1.10.1

sudo kubeadm init --pod-network-cidr=10.244.0.0/16 | tee ~/kubeadminit.log || exit $?

mkdir -p $HOME/.kube

sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

WORKERSFILE=$(cat ../workers)
for  worker in $WORKERSFILE
do
    if valid_ip $worker; then
        echo "worker: $worker"
        cat /tmp/kubeadminit.log | grep -i "kubeadm join" | sed -r 's/(\b[0-9]{1,3}\.){3}[0-9]{1,3}\b'/$worker/ > /tmp/addworker.sh
        sudo chmod +x /tmp/addworker.sh && sudo  bash -x /tmp/addworker.sh || exit $?
    fi
done


kubectl get pods --all-namespaces

kubectl get nodes
