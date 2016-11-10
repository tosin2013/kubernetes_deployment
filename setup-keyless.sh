#!/bin/bash
if [[ $# -ne 5 ]];then 
	echo $0: usage: ./setup-keyless.sh username 192.168.1.5 192.168.1.6 192.168.1.7 192.168.1.8
	exit 1
fi
]
USER=$1
cd ..
echo "create authentication ssh-keygen keys on localhost"
ssh-keygen -t rsa
echo "create .ssh directory on remote machines"
ssh $USER@$2 mkdir -p .ssh
ssh $USER@$3 mkdir -p .ssh
ssh $USER@$4 mkdir -p .ssh
ssh $USER@$5 mkdir -p .ssh
echo "upload generated public keys to remove hosts"
cat .ssh/id_rsa.pub | ssh $USER@$2 'cat >> .ssh/authorized_keys' 
cat .ssh/id_rsa.pub | ssh $USER@$3 'cat >> .ssh/authorized_keys'
cat .ssh/id_rsa.pub | ssh $USER@$4 'cat >> .ssh/authorized_keys'
cat .ssh/id_rsa.pub | ssh $USER@$5 'cat >> .ssh/authorized_keys'
echo "set permissions on authorized_keys folder"
ssh $USER@$1 "chmod 700 .ssh; chmod 640 .ssh/authorized_keys"
ssh $USER@$2 "chmod 700 .ssh; chmod 640 .ssh/authorized_keys"
ssh $USER@$3 "chmod 700 .ssh; chmod 640 .ssh/authorized_keys"
ssh $USER@$4 "chmod 700 .ssh; chmod 640 .ssh/authorized_keys"
echo "test logon on remote machines"
