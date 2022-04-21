#echo "******************************************************************************"
#echo " Setup of EPEL Repo"
#echo "******************************************************************************"
#yum install -y oracle-epel-release-el8
#yum-config-manager --enable ol8_developer_EPEL
#yum install -y sshpass

echo "******************************************************************************"
echo " Add extra OS packages. Most should be present." `date`
echo "******************************************************************************"
#dnf install -y bc    
#dnf install -y iproute-tc
dnf install -y binutils*

yum install -y yum-utils zip unzip
dnf install -y dnf-utils 
#dnf install -y bind-utils*
#dnf install -y compat-libcap1
#dnf install -y compat-libstdc++-33
#dnf install -y dtrace-modules
#dnf install -y dtrace-modules-headers
#dnf install -y dtrace-modules-provider-headers
#dnf install -y dtrace-utils
#dnf install -y elfutils-libelf
#dnf install -y elfutils-libelf-devel
#dnf install -y fontconfig-devel
#dnf install -y glibc
#dnf install -y glibc-devel
#dnf install -y ksh
#dnf install -y libaio
#dnf install -y libaio-devel
#dnf install -y libdtrace-ctf-devel
#dnf install -y libXrender
#dnf install -y libXrender-devel
#dnf install -y libX11
#dnf install -y libXau
#dnf install -y libXi
#dnf install -y libXtst
#dnf install -y libgcc
#dnf install -y librdmacm-devel
#dnf install -y libstdc++
#dnf install -y libstdc++-devel
#dnf install -y libxcb
#dnf install -y make
#dnf install -y net-tools # Clusterware
#dnf install -y nfs-utils # ACFS
#dnf install -y python # ACFS
#dnf install -y python-configshell # ACFS
#dnf install -y python-rtslib # ACFS
#dnf install -y python-six # ACFS
#dnf install -y targetcli # ACFS
#dnf install -y smartmontools
#dnf install -y sysstat

## New for OL8
#dnf install -y libnsl
#dnf install -y libnsl.i686
#dnf install -y libnsl2
#dnf install -y libnsl2.i686

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
