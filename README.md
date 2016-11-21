# kubernetes_depolyment

This will deploy a kubernetes cluster with one master and three nodes.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites
* CentOS 7 

### Installing
Setup login to hosts
```
./setup-keyless.sh username 192.168.1.5 192.168.1.6 192.168.1.7 192.168.1.8
```

Run the  dependency_push.sh this will push the packages required for kubernetes it will also configure the kuberenetes cluster.
```
./dependency_push.sh username 192.168.1.5 192.168.1.6 192.168.1.7 192.168.1.8
```


### Other Scripts used 
* install_packages.sh  - is copied over and installed the required packages for kubernetes as root
* deploy_master.sh - is copied over to master node and ran as root. This will configure the settings for kuberentes as master. 
* deploy_minion.sh - is copied over to minion and ran as root. This will configure the settings for kuberenters minions.
* a hosts file will be copied over to each machine to be used in the kuberentes cluster. 

## Deployment


## Built With


## Contributing

Please read [CONTRIBUTING.md]() for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **Tosin Akinosho** - *Initial work* - [http://tosinakinosho.com](http://www.tosinakinosho.com)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments


