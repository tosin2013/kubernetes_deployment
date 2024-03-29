#!/bin/bash

# update packages on machine 
sudo apt-get update -y

# install docker 
sudo apt-get remove docker docker-engine docker.io -y

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

FINGERPRINTCHECK=$(sudo apt-key fingerprint 0EBFCD88 || grep OK > /dev/null 2>/dev/null)
if [[ -z $FINGERPRINTCHECK ]]; then
    echo "FAILING on  apt-key fingerprint verification"
    exit 1
fi

sudo add-apt-repository \
	   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	      $(lsb_release -cs) \
	         stable"

sudo apt-get update -y

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

sudo docker run hello-world || exit $?

sudo usermod -aG docker $USER

containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl enable containerd

