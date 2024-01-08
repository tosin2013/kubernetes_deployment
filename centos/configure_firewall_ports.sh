#!/bin/bash
if [[ -z $1 ]]; then
    echo "Please pass node type"
    echo "USAGE: ./configure_firewall_ports.sh master/worker"
    exit 1
fi

sudo firewall-cmd --state  > /dev/null 2>/dev/null
RESULT=$?
if [ $RESULT -eq 0 ]; then
    echo "Skipping isntalling and configuring  firewalld"
else
    echo -e "
    \e[1;4mKubernetes firewalls \e[0m
    \e[32mMaster Nodes: \e[0m
    \e[1mTCP \e[0m    6443*    Kubernetes API server
    \e[1mTCP \e[0m    2379-2380   etcd server client API
    \e[1mTCP \e[0m    10250   Kubelet API
    \e[1mTCP \e[0m    10251   kube-scheduler
    \e[1mTCP \e[0m    10252   kube-controller-manager
    \e[1mTCP \e[0m    10255   Read-Only Kubelet API

    \e[32mWorker nodes: \e[0m
    \e[1mTCP \e[0m   10250    Kubelet API
    \e[1mTCP \e[0m    10255    Read-only Kubelet API
    \e[1mTCP \e[0m    30000-32767    NodePort Services"

    sudo yum install firewalld -y
    sudo systemctl enable firewalld
    sudo systemctl start firewalld
    if [[ $1 == "master" ]]; then
        echo "Configuring Master Nodes firewall"
        sudo firewall-cmd --zone=public --permanent --add-port=6443/tcp
        sudo firewall-cmd --zone=public --permanent --add-port=2379-2380/tcp
        sudo firewall-cmd --zone=public --permanent --add-port=10250/tcp
        sudo firewall-cmd --zone=public --permanent --add-port=10251/tcp
        sudo firewall-cmd --zone=public --permanent --add-port=10252/tcp
        sudo firewall-cmd --zone=public --permanent --add-port=10255/tcp
        sudo firewall-cmd --zone=public --permanent --add-port=7946/tcp
        # Allow Calico-specific ports (adjust as needed)
        sudo firewall-cmd --add-port=179/tcp --permanent
        sudo firewall-cmd --add-port=547/udp --permanent
        sudo firewall-cmd --add-port=546/udp --permanent
        sudo firewall-cmd --add-port=4789/udp --permanent
        sudo firewall-cmd --add-port=5473/tcp --permanent
        sudo firewall-cmd --add-port=6783/tcp --permanent
        sudo firewall-cmd --add-port=6961/tcp --permanent

        # Allow Calico BGP ports (if used)
        sudo firewall-cmd --add-port=179/udp --permanent
        sudo firewall-cmd --add-port=51820-51821/udp --permanent
        sudo firewall-cmd --zone=public --permanent --add-service=ssh
        sudo firewall-cmd --zone=public --permanent --list-services
        sudo firewall-cmd --zone=public --permanent --list-port

    elif [[ $1 == "worker" ]]; then
        echo "Configuring worker Nodes firewall"
        sudo firewall-cmd --zone=public --permanent --add-port=10250/tcp
        sudo firewall-cmd --zone=public --permanent --add-port=10255/tcp
        sudo firewall-cmd --zone=public --permanent --add-port=7946/tcp
        sudo firewall-cmd --zone=public --permanent --add-port=30000-32767/tcp
        # Allow Calico-specific ports (adjust as needed)
        sudo firewall-cmd --add-port=179/tcp --permanent
        sudo firewall-cmd --add-port=547/udp --permanent
        sudo firewall-cmd --add-port=546/udp --permanent
        sudo firewall-cmd --add-port=4789/udp --permanent
        sudo firewall-cmd --add-port=5473/tcp --permanent
        sudo firewall-cmd --add-port=6783/tcp --permanent
        sudo firewall-cmd --add-port=6961/tcp --permanent

        # Allow Calico BGP ports (if used)
        sudo firewall-cmd --add-port=179/udp --permanent
        sudo firewall-cmd --add-port=51820-51821/udp --permanent
        sudo firewall-cmd --zone=public --permanent --add-service=ssh
        sudo firewall-cmd --zone=public --permanent --list-services
        sudo firewall-cmd --zone=public --permanent --list-port
    else
        echo -e "\e[41mInvalid flag passed. Use master/worker flag \e[0m"
        exit 1
    fi
fi
