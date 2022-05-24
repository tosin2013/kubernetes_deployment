#!/bin/bash
#set -xe
kubeadm  -v  > /dev/null 2>/dev/null
RESULT=$?
if [ $RESULT -eq 0 ]; then
  echo "Skipping kubeadm, kubelet and kubectl installation"
else
    echo "Disabling Swap."
    sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
    sudo swapoff -a 

    echo -e "\e[92mInstalling kubeadm, kubelet and kubectl\e[0m"
    echo -e "
    \e[1mkubeadm:\e[0m the command to bootstrap the cluster.
    \e[1mkubelet:\e[0m the component that runs on all of the machines in your cluster and does things like starting pods and containers.
    \e[1mkubectl:\e[0m the command line util to talk to your cluster."
    sleep 5s
#sudo -s  cat <<EOF > /etc/yum.repos.d/kubernetes.repo
sudo tee -a /etc/yum.repos.d/kubernetes.repo >/dev/null <<'EOF'
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF
    #grep overlay /proc/filesystems
    #sudo echo "KUBELET_EXTRA_ARGS=--cgroup-driver=devicemapper" | sudo tee --append /etc/default/kubelet
    #sudo systemctl daemon-reload
    #sudo systemctl restart kubelet
    #sleep 5s
sudo tee -a /etc/sysctl.d/k8s.conf >/dev/null <<'EOF'
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF


sudo tee /usr/lib/sysctl.d/00-system.conf >/dev/null <<'EOF'
# Kernel sysctl configuration file
#
# For binary values, 0 is disabled, 1 is enabled.  See sysctl(8) and
# sysctl.conf(5) for more details.

# Disable netfilter on bridges.
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-arptables = 1
net.ipv4.ip_forward                 = 1
EOF
sudo sysctl --system

    # Set SELinux in permissive mode (effectively disabling it)
    sudo setenforce 0
    sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

    sudo yum install -y kubelet=${KUBEVERSION} kubeadm=${KUBEVERSION} kubectl=${KUBEVERSION} --disableexcludes=kubernetes || exit $?

    sudo systemctl enable kubelet && sudo systemctl start kubelet || exit $?
fi
