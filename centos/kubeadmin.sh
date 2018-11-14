#!/bin/bash
#set -xe
kubeadm  -v  > /dev/null 2>/dev/null
RESULT=$?
if [ $RESULT -eq 0 ]; then
  echo "Skipping kubeadm, kubelet and kubectl installation"
else
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

    # Set SELinux in permissive mode (effectively disabling it)
    sudo setenforce 0
    sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

    sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes || exit $?

    sudo systemctl enable kubelet && sudo systemctl start kubelet || exit $?
    grep overlay /proc/filesystems
    sudo echo "KUBELET_EXTRA_ARGS=--cgroup-driver=devicemapper" | sudo tee --append /etc/default/kubelet
    sudo systemctl daemon-reload
    sudo systemctl restart kubelet
    sleep 5s
sudo tee -a /etc/sysctl.d/k8s.conf >/dev/null <<'EOF'
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
    sudo sysctl --system
fi
