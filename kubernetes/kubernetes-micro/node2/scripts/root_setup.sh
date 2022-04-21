echo "******************************************************************************"
echo "Node2 - Worker Node Setup Start." `date`
echo "******************************************************************************"
# It is optional, we add a user alladmin for non root purposes
useradd alladmin
. /vagrant_config/install.env

sh /vagrant_scripts/install_os_packages.sh
sh /vagrant_scripts/micro_kubernetes_setup.sh

echo "******************************************************************************"
echo "Set root and alladmin password" `date`
echo "******************************************************************************"
echo -e "${ROOT_PASSWORD}\n${ROOT_PASSWORD}" | passwd
echo -e "${ALLADMIN_PASSWORD}\n${ALLADMIN_PASSWORD}" | passwd alladmin
usermod -aG vagrant alladmin

sh /vagrant_scripts/configure_hosts_base.sh

cat > /etc/resolv.conf <<EOF
search localdomain
nameserver ${DNS_PUBLIC_IP}
EOF

# Stop NetworkManager altering the /etc/resolve.conf contents.
sed -i -e "s|\[main\]|\[main\]\ndns=none|g" /etc/NetworkManager/NetworkManager.conf
systemctl restart NetworkManager.service

echo "******************************************************************************"
echo "Set Hostname." `date`
echo "******************************************************************************"
hostnamectl set-hostname ${NODE2_HOSTNAME}

echo "******************************************************************************"
echo "Check nslookup pinging."
echo "******************************************************************************"
nslookup cent8-sys2
sleep 60

echo "******************************************************************************"
echo "Passwordless SSH Setup for root." `date`
echo "******************************************************************************"
mkdir -p ~/.ssh
chmod 700 ~/.ssh
cd ~/.ssh
rm -f *
cat /dev/zero | ssh-keygen -t rsa -q -N "" > /dev/null
cat id_rsa.pub >> authorized_keys
ssh-keyscan -H ${NODE2_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE2_FQ_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE2_PUBLIC_IP} >> ~/.ssh/known_hosts
ssh-keyscan -H localhost >> ~/.ssh/known_hosts
chmod -R 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
ssh ${NODE2_HOSTNAME} date
echo "${ROOT_PASSWORD}" > /tmp/temp1.txt

# bidirectional ssh. SSH from Node2 to Node1
ssh-keyscan -H ${NODE1_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE1_FQ_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE1_PUBLIC_IP} >> ~/.ssh/known_hosts
sshpass -f /tmp/temp1.txt ssh-copy-id ${NODE1_HOSTNAME}

echo "******************************************************************************"
echo " Set Swap Off "
echo "******************************************************************************"

swapoff -a 

echo "******************************************************************************"
echo "Node2 - Worker Node Setup End." `date`
echo "******************************************************************************"
