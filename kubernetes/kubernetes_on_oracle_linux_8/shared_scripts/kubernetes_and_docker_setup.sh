modprobe br_netfilter 
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables

# installing docker stable packages 
dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo 
#dnf install https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm -y 
#dnf install https://download.docker.com/linux/centos/8/x86_64/stable/Packages/containerd.io-1.4.4-3.1.el8.x86_64.rpm -y

dnf install https://download.docker.com/linux/centos/8/x86_64/stable/Packages/containerd.io-1.4.12-3.1.el8.x86_64.rpm -y

#Docker GPG Key
#dnf install https://download.docker.com/linux/centos/gpg -y 

dnf install -y docker-ce --nobest
swapoff -a 

# as of now we do not see kubernetes EL8 on the official website
cat > /etc/yum.repos.d/kubernetes.repo <<EOF
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

dnf install -y kubeadm 

systemctl enable docker.service

# this is the fix for kubelet can't connect 
#https://github.com/kubernetes/kubeadm/issues/1893

mkdir -p /etc/docker/
cat > /etc/docker/daemon.json <<EOF
{
"exec-opts": ["native.cgroupdriver=systemd"]
}
EOF
chown $(id -u):$(id -g) /etc/docker/daemon.json

echo "******************************************************************************"
echo "Start Installing Docker Compose." `date`
echo "******************************************************************************"

curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose 
chmod +x /usr/local/bin/docker-compose

ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

echo "******************************************************************************"
echo "End Installing Docker Compose." `date`
echo "******************************************************************************"
#ll /usr/bin/docker-compose

docker-compose --version

echo "******************************************************************************"
echo "Start Bash Completion setup." `date`
echo "******************************************************************************"

mkdir -p /etc/bash_completion.d/ .

curl \
    -L https://raw.githubusercontent.com/docker/compose/1.29.2/contrib/completion/bash/docker-compose \
    -o /etc/bash_completion.d/docker-compose 

source ~/.bashrc 
echo "******************************************************************************"
echo "End Bash Completion setup." `date`
echo "******************************************************************************"


systemctl is-enabled docker.service
#systemctl status docker.service

systemctl enable kubelet.service
systemctl restart kubelet.service 
systemctl restart docker.service

echo "******************************************************************************"
echo "kubernetes and docker setup end." `date`
echo "******************************************************************************"

