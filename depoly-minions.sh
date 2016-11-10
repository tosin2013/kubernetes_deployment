!#/bin/bash
#edit client
sed -i s/127.0.0.1/centos-master/g /etc/kubernetes/config
#edit KUBE_ETCD_SERVERS 
echo KUBE_ETCD_SERVERS="—etd-servers=http://centos-master:2379" >> /etc/kubernetes/config

#update kubelet config
sed -i 's/KUBELET_ADDRESS="--address=127.0.0.1/KUBELET_ADDRESS="--address=0.0.0.0/g' /etc/kubernetes/kubelet
sed -i s/#.*K/K/g /etc/kubernetes/kubelet

sed -i 's/KUBELET_HOSTNAME="--hostname-override=127.0.0.1"/KUBELET_HOSTNAME="--hostname-override=centos-minion1"/g' /etc/kubernetes/kubelet 
sed -i 's/KUBELET_API_SERVER="--api-servers=http:\/\/127.0.0.1:8080"/KUBELET_API_SERVER="--api-servers=http:\/\/centos-master:8080"/g' /etc/kubernetes/kubelet 

sed -i s/KUBELET_POD_INFRA_CONTAINER/#KUBELET_POD_INFRA_CONTAINER/g /etc/kubernetes/kubelet 

systemctl enable kube-proxy kubelet docker
systemctl start kube-proxy kubelet docker


#!/bin/bash

COUNT=$(systemctl status kube-proxy kubelet docker | grep active | wc -l)


if [ $COUNT == "3" ]; then

        echo “All three services are active”

else

        echo “check services”

fi


