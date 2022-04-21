echo "******************************************************************************"
echo "Prepare yum with the latest repos." `date`
echo "******************************************************************************"
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

# Stop NetworkManager altering the /etc/resolve.conf contents.
sed -i -e "s|\[main\]|\[main\]\ndns=none|g" /etc/NetworkManager/NetworkManager.conf
systemctl restart NetworkManager.service

echo "******************************************************************************"
echo "Set Hostname." `date`
echo "******************************************************************************"
hostnamectl set-hostname oracle8-docker1

sh /vagrant/scripts/install_os_packages.sh

echo "******************************************************************************"
echo "Start Docker setup using Docker Script." `date`
echo "******************************************************************************"

# convenience-script from Docker is unsupported for Oracle Linux
#https://docs.docker.com/engine/install/centos/#install-using-the-convenience-script
#curl -fsSL https://get.docker.com -o get-docker.sh
#sh get-docker.sh

# installing docker stable packages 
dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo 

#Docker GPG Key
#dnf install https://download.docker.com/linux/centos/gpg -y 

# install a specific one 
#dnf install https://download.docker.com/linux/centos/8/x86_64/stable/Packages/containerd.io-1.4.12-3.1.el8.x86_64.rpm -y

# installs latest one 
yum install docker-ce docker-ce-cli containerd.io -y

systemctl enable docker.service
systemctl restart docker.service

echo "******************************************************************************"
echo "Start Installing Docker Compose." `date`
echo "******************************************************************************"

curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

echo "******************************************************************************"
echo "End Installing Docker Compose." `date`
echo "******************************************************************************"
ll /usr/bin/docker-compose

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

# install git
#dnf install git 

#add vagrant user to docker group
usermod -aG docker vagrant

# this is the fix for kubelet can't connect if needed for Docker 
#https://github.com/kubernetes/kubeadm/issues/1893
#mkdir -p /etc/docker/
#cat > /etc/docker/daemon.json <<EOF
#{
#"exec-opts": ["native.cgroupdriver=systemd"]
#}
#EOF
#chown $(id -u):$(id -g) /etc/docker/daemon.json
