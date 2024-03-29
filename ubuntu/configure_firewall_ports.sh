    #!/bin/bash
    if [[ -z $1 ]]; then
        echo "Please pass node type"
        echo "USAGE: ./configure_firewall_ports.sh master/worker"
        exit 1
    fi

    sudo ufw status | grep inactive  > /dev/null 2>/dev/null
    RESULT=$?
    if [ $RESULT -eq 1 ]; then
        echo "Skipping firewall configuration"
    else
        echo -e "
        \e[1;4mKubernetes firewalls \e[0m
        \e[32mMaster Nodes: \e[0m
        \e[1mTCP \e[0m    6443*    Kubernetes API server
        \e[1mTCP \e[0m    2379-2380   etcd server client API
        \e[1mTCP \e[0m    10250   Kubelet API
        \e[1mTCP \e[0m    10251   kube-scheduler
        \e[1mTCP \e[0m    10252   kube-controller-manager
        \e[1mTCP \e[0m    10255   Read-Only Kubelet API

        \e[32mWorker nodes: \e[0m
        \e[1mTCP \e[0m   10250    Kubelet API
        \e[1mTCP \e[0m    10255    Read-only Kubelet API
        \e[1mTCP \e[0m    30000-32767    NodePort Services"

        if [[ $1 == "master" ]]; then
            echo "Configuring Master Nodes firewall"
            sudo ufw status | grep inactive && sudo ufw enable || exit $?
            sudo ufw allow from any to any port 6443 proto tcp
            sudo ufw allow from any to any port 2379:2380 proto tcp
            sudo ufw allow from any to any port 10250  proto tcp
            sudo ufw allow from any to any port 10251 proto tcp
            sudo ufw allow from any to any port 10252 proto tcp
            sudo ufw allow from any to any port 10255 proto tcp
            sudo ufw allow from any to any port 7946 proto tcp
            # Allow Calico-specific ports (adjust as needed)
            sudo ufw allow from any to any port 179 proto tcp
            sudo ufw allow from any to any port 547 proto udp
            sudo ufw allow from any to any port 546 proto udp
            sudo ufw allow from any to any port 4789 proto udp
            sudo ufw allow from any to any port 5473 proto tcp
            sudo ufw allow from any to any port 6783 proto tcp
            sudo ufw allow from any to any port 6961 proto tcp

            # Allow Calico BGP ports (if used)
            sudo ufw allow from any to any port 179 proto udp
            sudo ufw allow from any to any port 51820:51821 proto udp

            sudo ufw allow ssh
            sudo ufw status verbose
            exit 0
        elif [[ $1 == "worker" ]]; then
            echo "Configuring worker Nodes firewall"
            sudo ufw status | grep inactive && sudo ufw enable || exit $?
            sudo ufw allow from any to any port 10250 proto tcp
            sudo ufw allow from any to any port 10255 proto tcp
            sudo ufw allow from any to any port 30000:32767 proto tcp
            sudo ufw allow from any to any port 7946 proto tcp
            # Allow Calico-specific ports (adjust as needed)
            sudo ufw allow from any to any port 179 proto tcp
            sudo ufw allow from any to any port 547 proto udp
            sudo ufw allow from any to any port 546 proto udp
            sudo ufw allow from any to any port 4789 proto udp
            sudo ufw allow from any to any port 5473 proto tcp
            sudo ufw allow from any to any port 6783 proto tcp
            sudo ufw allow from any to any port 6961 proto tcp

            # Allow Calico BGP ports (if used)
            sudo ufw allow from any to any port 179 proto udp
            sudo ufw allow from any to any port 51820:51821 proto udp
            sudo ufw allow ssh
            sudo ufw status verbose
        else
            echo -e "\e[41mInvalid flag passed. Use master/worker flag \e[0m"
            exit 1
        fi
    fi