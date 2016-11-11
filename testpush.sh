ssh -t user@54.234.59.134 'su - root -c   "sed -i ''s/KUBELET_HOSTNAME="--hostname-override=centos-minion1"/KUBELET_HOSTNAME="--hostname-override=centos-minion2"/g'' deploy-minions.sh'

