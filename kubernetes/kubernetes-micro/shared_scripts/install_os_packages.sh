echo "******************************************************************************"
echo "Prepare CentOS 8 Stream and yum repos and install base packages." `date`
echo "******************************************************************************"
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

# source 
#https://www.centos.org/download/

dnf --disablerepo '*' --enablerepo extras swap centos-linux-repos centos-stream-repos -y
#-- This downloads the Stream repo files.
yum install -y yum-utils zip unzip
dnf install -y iproute-tc

#on CentOS 8 it is recommended to also enable the powertools repository since EPEL packages may depend on packages from it:
dnf config-manager --set-enabled powertools 

# Useful. Only necessary if you're using epel repos 
#dnf distro-sync -y
# If needed and interested
#reboot the server if needed. In this Bento installation it is not needed.
#dnf upgrade -y
#Not all packages are upgradeable during the distro-sync. 
#rm -f /etc/yum.repos.d/*rpmsave
# Optional. There's no need to keep these files, but if you want delete it

dnf install -y dnf-utils zip unzip
echo "******************************************************************************"
echo " Setup of EPEL Repo"
echo "******************************************************************************"
yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

dnf install -y sshpass

echo "******************************************************************************"
echo " Add extra OS packages. Most should be present." `date`
echo "******************************************************************************"
dnf install -y bc    
dnf install -y binutils
dnf install -y bind-utils


echo "******************************************************************************"
echo "Firewall." `date`
echo "******************************************************************************"
systemctl stop firewalld
systemctl disable firewalld


echo "******************************************************************************"
echo "SELinux." `date`
echo "******************************************************************************"
sed -i -e "s|SELINUX=enforcing|SELINUX=permissive|g" /etc/selinux/config
setenforce permissive
