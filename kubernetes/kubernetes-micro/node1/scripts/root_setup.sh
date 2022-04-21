echo "******************************************************************************"
echo "Node1 - Master Node Setup Start." `date`
echo "******************************************************************************"
# It is optional, we add a user alladmin for non root purposes
useradd alladmin
. /vagrant_config/install.env

sh /vagrant_scripts/install_os_packages.sh
sh /vagrant_scripts/micro_kubernetes_setup.sh

echo "******************************************************************************"
echo "Set root and alladmin password " `date`
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
hostnamectl set-hostname ${NODE1_HOSTNAME}

echo "******************************************************************************"
echo "Check nslookup pinging."
echo "******************************************************************************"
nslookup cent8-sys1
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
ssh-keyscan -H ${NODE1_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE1_FQ_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE1_PUBLIC_IP} >> ~/.ssh/known_hosts
ssh-keyscan -H localhost >> ~/.ssh/known_hosts
chmod -R 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
ssh ${NODE1_HOSTNAME} date
echo "${ROOT_PASSWORD}" > /tmp/temp1.txt

ssh-keyscan -H ${NODE2_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE2_FQ_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE2_PUBLIC_IP} >> ~/.ssh/known_hosts
sshpass -f /tmp/temp1.txt ssh-copy-id ${NODE2_HOSTNAME}

ssh-keyscan -H ${NODE3_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE3_FQ_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE3_PUBLIC_IP} >> ~/.ssh/known_hosts
sshpass -f /tmp/temp1.txt ssh-copy-id ${NODE3_HOSTNAME}

cat > /tmp/ssh-setup.sh <<EOF
ssh-keyscan -H ${NODE1_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE1_FQ_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE1_PUBLIC_IP} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE2_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE2_FQ_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE2_PUBLIC_IP} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE3_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE3_FQ_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE3_PUBLIC_IP} >> ~/.ssh/known_hosts
ssh-keyscan -H localhost >> ~/.ssh/known_hosts
sshpass -f /tmp/temp1.txt ssh-copy-id ${NODE1_HOSTNAME}
EOF

ssh ${NODE2_HOSTNAME} 'bash -s' < /tmp/ssh-setup.sh
ssh ${NODE3_HOSTNAME} 'bash -s' < /tmp/ssh-setup.sh

echo "******************************************************************************"
echo " Set Swap Off "
echo "******************************************************************************"

swapoff -a 

echo "******************************************************************************"
echo "Node1 - Master Node Setup End." `date`
echo "******************************************************************************"
