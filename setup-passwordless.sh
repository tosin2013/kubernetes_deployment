#!/bin/bash
if [[ $# -ne 3 ]]; then
    echo "Please see usage"
    echo  "USAGE: ./setup-passwordless.sh hostname/ipaddress username_name your_email"
    echo  "USAGE EXAMPLE: ./setup-passwordless.sh 192.168.60.55 admin admin@megacorp.com"
    exit $1
fi

ENDPOINT="${1}"
USERNAME=${2}
EMAIL=${3}

#https://stackoverflow.com/questions/32291127/bash-regex-email
if [[ "$EMAIL" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$ ]]
then
   echo "Email address $EMAIL is valid."
else
   echo "Email address $EMAIL is invalid."
   exit $1
fi

#THANKS TO: https://linuxize.com/post/how-to-setup-passwordless-ssh-login/
CHECKSSHKEYPATH=$(ls -al ~/.ssh/id_*.pub 2>/dev/null)
if [[ -z $CHECKSSHKEYPATH ]]; then
    echo "Generate a new SSH key pair."
    ssh-keygen -t rsa -b 4096 -C ${EMAIL}
    ls ~/.ssh/id_* || exit $?
fi

ssh  -o PasswordAuthentication=no -o ConnectTimeout=10  ${USERNAME}@${ENDPOINT} ls -lath
RESULT=$?
if [ $RESULT -eq 0 ]; then
  echo "Skipping ssh Configuraton"
else
    ssh-copy-id ${USERNAME}@${ENDPOINT}
    cat ~/.ssh/id_rsa.pub | ssh ${USERNAME}@${ENDPOINT} "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
    ssh -o PasswordAuthentication=no -o ConnectTimeout=10 ${USERNAME}@${ENDPOINT} ls -lath || exit $?
fi
