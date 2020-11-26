#!/bin/bash

sudo yum update -y
sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2

sudo yum-config-manager \
     --add-repo \
     https://download.docker.com/linux/centos/docker-ce.repo

VERSION=$(yum list docker-ce --showduplicates | sort -r| grep 18.06 | head -n 1 | awk '{print $2}')
sudo yum install docker-ce-${VERSION} -y


sudo sed -i '/^ExecStart/ s/$/ --exec-opt native.cgroupdriver=systemd/' /usr/lib/systemd/system/docker.service
sudo systemctl daemon-reload
sudo systemctl enable docker --now

sudo systemctl start docker

sudo systemctl status docker

sudo docker run hello-world || exit $?

sudo usermod -aG docker $USER
