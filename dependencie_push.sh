#!/bin/bash
#pushing dependices for kubernetes to machines
if [[ $# -ne 5 ]];then 
	echo $0: usage: ./setup-keyless.sh username 192.168.1.5 192.168.1.6 192.168.1.7 192.168.1.8
	exit 1
fi

USER=$1
scp install_packages.sh $USER@$2:/home/$1/install_packages.sh
ssh -t $USER@$2 'su - root -c  "chmod +x /home/'$1'/install_packages.sh;sh /home/'$1'/install_packages.sh;"'
