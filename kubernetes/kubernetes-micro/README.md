# Kubernetes Micro setup on Centos8 Stream(8.4) with a base memory of 7 GB
* Memory settings file "vagrant.yml" in kubernetes-micro\config\
* Kubernetes Micro that is Snap/microk8s used in this setup 
* https://microk8s.io/
* This setup has DNS Server (dnsmasq) and 3 Nodes: 
* node1 as master node and the rest two nodes are worker nodes
* This setup has no extra storage configuration at this moment

# steps to spin up 
```
On my system it is under D drive which is /d/git/vagrant/devops/
1. Start up DNS Server 
cd /d/git/vagrant/devops/kubernetes-micro/dns 
$ vagrant.exe up

2. Open 3 windows to startup 3 Nodes in a go and SSH Setup configures between them
cd /d/git/vagrant/devops/kubernetes-micro/node1 
$ vagrant.exe up

cd /d/git/vagrant/devops/kubernetes-micro/node2
$ vagrant.exe up

$ vagrant.exe up
cd /d/git/vagrant/devops/kubernetes-micro/node3 
$ vagrant.exe up

Wait for 10 Minutes to finish the setup. All the downloads and installation will be done 
```
* The file "micro-kubernetes-notes" has further steps for this setup