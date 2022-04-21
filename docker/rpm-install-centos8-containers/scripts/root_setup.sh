echo "******************************************************************************"
echo "Prepare CentOS 8 Stream repo and install base packages." `date`
echo "******************************************************************************"
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
# Stop NetworkManager altering the /etc/resolve.conf contents.
sed -i -e "s|\[main\]|\[main\]\ndns=none|g" /etc/NetworkManager/NetworkManager.conf
systemctl restart NetworkManager.service

echo "******************************************************************************"
echo "Set Hostname." `date`
echo "******************************************************************************"
hostnamectl set-hostname centos8-rpm-docker1

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
echo "Start Docker setup using RPM packages." `date`
echo "******************************************************************************"
sh /vagrant/scripts/container_setup.sh




