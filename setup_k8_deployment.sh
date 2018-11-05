#!/bin/bash

# confiugre docker
docker -v  > /dev/null 2>/dev/null
RESULT=$?
if [ $RESULT -eq 0 ]; then
  echo "Skipping docker installation"
else
	echo "Attempting to install docker"
  ./configure_docker.sh || exit $?
fi

./kubeadmin.sh || exit $?
