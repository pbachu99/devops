#echo "******************************************************************************"
#echo " Setup of EPEL Repo"
#echo "******************************************************************************"
#yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

#on CentOS 8 it is recommended to also enable the powertools repository since EPEL packages may depend on packages from it:
#dnf config-manager --set-enabled powertools

#dnf install -y sshpass
dnf install -y dnf-utils zip unzip

echo "******************************************************************************"
echo " Add extra OS packages. Most should be present." `date`
echo "******************************************************************************"
#dnf install -y bc    
dnf install -y binutils

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

