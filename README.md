# kubernetes_depolyment <-> WIP

This will deploy a kubernetes cluster with one master and three nodes.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites
* Git
* CentOS 7 or Ubuntu

### Installing
Clone Git repository
```
git clone https://github.com/tosin2013/kubernetes_deployment.git
cd kubernetes_deployment/
```
add worker nodes to workers file
```
$ cat workers
# list of workers to be used in deployment
```

Setup login to hosts
```
./setup-passwordless.sh 192.168.60.55 admin admin@megacorp.com
```
Populate kube_env with your Environment information
```
$ cat kube_env
# Environment Variables to be used during deployment
USERNAME="admin" #username for remote workers
CIDR="192.168.1.0/16" #Example Network CIDR=10.244.0.0/16 for pod network
```

optional enable ssh-agent
```
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa
```

Call Script
```
 ./setup_k8_deployment.sh
```

To add workers call
```
#populate workers file
#call configure_workers.sh
./ubuntu/configure_workers.sh username
```

## Deployment

## TO-DO


## Tested on
* Ubuntu 18.04 Bionic Beaver LTS

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags).

## Authors

* **Tosin Akinosho** - *Initial work* - [http://tosinakinosho.com](http://www.tosinakinosho.com)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments
