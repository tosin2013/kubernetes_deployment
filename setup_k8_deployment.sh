#!/bin/bash

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

./ubuntu/setup_k8_ubuntu18_04.sh || exit $?

./ubuntu/configure_workers.sh  || exit $?
