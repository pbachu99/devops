echo "******************************************************************************"
echo "Prepare CentOS 8 Stream and yum repos and install base packages." `date`
echo "******************************************************************************"
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
# Stop NetworkManager altering the /etc/resolve.conf contents.
sed -i -e "s|\[main\]|\[main\]\ndns=none|g" /etc/NetworkManager/NetworkManager.conf
systemctl restart NetworkManager.service

echo "******************************************************************************"
echo "Set Hostname." `date`
echo "******************************************************************************"
hostnamectl set-hostname centos8-docker1

# source 
#https://www.centos.org/download/

dnf --disablerepo '*' --enablerepo extras swap centos-linux-repos centos-stream-repos -y
#-- This downloads the Stream repo files.
yum install -y yum-utils zip unzip
dnf install -y iproute-tc

#dnf config-manager --set-enabled powertools 
# Useful. Only necessary if you're using epel repos 
#dnf distro-sync -y
# If needed and interested
#reboot the server if needed. In this Bento installation it is not needed.
#dnf upgrade -y
#Not all packages are upgradeable during the distro-sync. 
#rm -f /etc/yum.repos.d/*rpmsave
# Optional. There's no need to keep these files, but if you want delete it

#sh /vagrant/scripts/prepare_disks.sh 
sh /vagrant/scripts/install_os_packages.sh

echo "******************************************************************************"
echo "Start Docker setup using Docker Script." `date`
echo "******************************************************************************"
#https://docs.docker.com/engine/install/centos/#install-using-the-convenience-script

curl -fsSL https://get.docker.com -o get-docker.sh

sh get-docker.sh

echo "******************************************************************************"
echo "End Docker setup using Docker Script." `date`
echo "******************************************************************************"

#systemctl enable docker 
#systemctl restart docker

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