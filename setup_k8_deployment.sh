#!/bin/bash

if [[ ! -f kube_env ]]; then
    echo "kube_env file not found please populated with required values"
    exit 1
fi

source kube_env

if [[ $USERNAME == "" ]]; then
    echo "Please populate username"
    exit $?
fi

function waitforkubenetesload() {
    COUNT=$(kubectl get pods --all-namespaces | grep Running | awk '{print $2}' | wc -l)
    COUNT="$(($COUNT))"
    while [[ $COUNT -ne 8 ]]; do
        echo -e "\e[92mWaiting for pods to poulate. \e[0m"
        sleep 5s
        COUNT=$(kubectl get pods --all-namespaces | grep Running | awk '{print $2}' | wc -l)
        COUNT="$(($COUNT))"
    done
}

RELEASE=$(awk -F= '/^NAME/{print $2}' /etc/os-release | sed -e 's/^"//' -e 's/"$//')


if [ "$RELEASE"  = "Ubuntu" ]; then
    # confiugre docker
    docker -v  > /dev/null 2>/dev/null
    RESULT=$?
    if [ $RESULT -eq 0 ]; then
      echo "Skipping docker installation"
    else
    	echo "Attempting to install docker"
      ./ubuntu/configure_docker.sh || exit $?
    fi

    ./ubuntu/configure_firewall_ports.sh master  || exit $?

    ./ubuntu/kubeadmin.sh || exit $?

    ./k8/configure_k8.sh || exit $?

    waitforkubenetesload

    ./ubuntu/configure_workers.sh $USERNAME  || exit $?
elif [ "$RELEASE"  = "CentOS Linux" ]; then
    docker -v  > /dev/null 2>/dev/null
    RESULT=$?
    if [ $RESULT -eq 0 ]; then
      echo "Skipping docker installation"
    else
    	echo "Attempting to install docker"
        ./centos/configure_docker.sh || exit $?
    fi
    ./centos/configure_firewall_ports.sh master || exit $?

    ./centos/kubeadmin.sh || exit $?

    ./k8/configure_k8.sh || exit $?

    waitforkubenetesload

    ./centos/configure_workers.sh $USERNAME  || exit $?
else
    echo "Centos and Ubuntu Linux OS not found please use."
    exit 1
fi
