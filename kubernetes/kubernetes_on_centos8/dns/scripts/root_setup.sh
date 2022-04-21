echo "******************************************************************************"
echo "Setup Start." `date`
echo "******************************************************************************"

. /vagrant_config/install.env

echo "******************************************************************************"
echo "Prepare CentOS Stream 8 Repo -and- yum." `date`
echo "******************************************************************************"
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

# Stop NetworkManager altering the /etc/resolve.conf contents.
sed -i -e "s|\[main\]|\[main\]\ndns=none|g" /etc/NetworkManager/NetworkManager.conf
systemctl restart NetworkManager.service

# source 
#https://www.centos.org/download/

dnf --disablerepo '*' --enablerepo extras swap centos-linux-repos centos-stream-repos -y
#-- This downloads the Stream repo files.

dnf config-manager --set-enabled powertools 
# Useful. Only necessary if you're using epel repos 
#dnf distro-sync -y
# If needed and interested
#reboot the server if needed. In this Bento installation it is not needed.
#dnf upgrade -y
#Not all packages are upgradeable during the distro-sync. 
#rm -f /etc/yum.repos.d/*rpmsave
# Optional. There's no need to keep these files, but if you want delete it

sh /vagrant_scripts/configure_hosts_base.sh
#sh /vagrant_scripts/configure_hosts_scan.sh

echo "******************************************************************************"
echo "Firewall." `date`
echo "******************************************************************************"
systemctl stop firewalld
systemctl disable firewalld

echo "******************************************************************************"
echo "Install dnsmasq." `date`
echo "******************************************************************************"
yum install -y yum-utils zip unzip dnsmasq

systemctl enable dnsmasq
systemctl restart dnsmasq

#other packages relevant to dns
#dnf install -y bc    
dnf install -y binutils*
dnf install -y bind-utils*
dnf install -y iproute-tc


echo "******************************************************************************"
echo "DNS Node Setup End." `date`
echo "******************************************************************************"
