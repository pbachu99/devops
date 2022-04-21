echo "******************************************************************************"
echo "Prepare yum with the latest repos." `date`
echo "******************************************************************************"
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

# Stop NetworkManager altering the /etc/resolve.conf contents.
sed -i -e "s|\[main\]|\[main\]\ndns=none|g" /etc/NetworkManager/NetworkManager.conf
systemctl restart NetworkManager.service

#echo "******************************************************************************"
#echo "Set Hostname." `date`
#echo "******************************************************************************"
#hostnamectl set-hostname dock1

sh /vagrant/scripts/install_os_packages.sh

echo "******************************************************************************"
echo "Start Docker setup using RPM Packages..." `date`
echo "******************************************************************************"

sh /vagrant/scripts/container_setup.sh


