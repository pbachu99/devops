echo "******************************************************************************"
echo "Node1 Setup Start." `date`
echo "******************************************************************************"
useradd alladmin
. /vagrant_config/install.env

sh /vagrant_scripts/install_os_packages.sh
sh /vagrant_scripts/kubernetes_and_docker_setup.sh

echo "******************************************************************************"
echo "Set root and alladmin password " `date`
echo "******************************************************************************"
echo -e "${ROOT_PASSWORD}\n${ROOT_PASSWORD}" | passwd
echo -e "${ALLADMIN_PASSWORD}\n${ALLADMIN_PASSWORD}" | passwd alladmin
# creating an alladmin account for all activities
usermod -aG vagrant alladmin
echo "alladmin    ALL=(ALL)      ALL" | sudo tee -a /etc/sudoers

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
echo "If nslookup doesn't ping, Kubernetes configure script fails"
echo "Restart DNS Server/oracle8_dns with vagrant halt/up if no servers reached seen"
echo "******************************************************************************"
nslookup oracle8-sys1
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

su - root -c 'sh /vagrant_scripts/kubernetes_configure_master.sh'