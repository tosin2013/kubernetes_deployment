#!/bin/bash
#installing dependancys
echo "Updating hosts file"
cp /tmp/hosts /etc/hosts 
echo "installing dependencies"
touch /etc/yum.repos.d/virt7-docker-common-release.repo
echo "[virt7-docker-common-release] 
name=virt7-docker-common-release
baseurl=http://cbs.centos.org.repos/virt7-docker-common-release/x86_64/os/Host Names" > /etc/yum.repos.d/virt7-docker-common-release.repo
echo "performaing update"
yum update
sleep 5
echo "isntalling packages"
yum install -y ntpd etcd kubernetes docker

echo "setting up ntp"
systemctl enable ntpd;systemctl start ntpd;
echo "waiting for time sync"
sleep 15
echo "checking current time"
timedatectl

