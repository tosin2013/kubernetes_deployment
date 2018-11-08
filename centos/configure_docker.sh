#!/bin/bash

sudo yum update -y 
sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2

sudo yum-config-manager \
     --add-repo \
     https://download.docker.com/linux/centos/docker-ce.repo

sudo yum install docker-ce -y 

sudo systemctl enable docker

sudo systemctl start docker

sudo systemctl status docker

sudo docker run hello-world || exit $?

sudo usermod -aG docker $USER

