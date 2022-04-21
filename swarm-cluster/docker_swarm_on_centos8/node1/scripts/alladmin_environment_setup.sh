. /vagrant_config/install.env

echo "******************************************************************************"
echo "Create environment scripts." `date`
echo "******************************************************************************"
mkdir -p /home/alladmin/scripts

cat > /home/alladmin/scripts/setEnv.sh <<EOF
# alladmin Settings
export TMP=/tmp
export TMPDIR=\$TMP
export NODE1_HOST=${NODE1_FQ_HOSTNAME}
export BASE_PATH=/usr/sbin:\$PATH
EOF

cat >> /home/alladmin/.bash_profile <<EOF
. /home/alladmin/scripts/setEnv.sh
EOF

echo "******************************************************************************"
echo "Create directories." `date`
echo "******************************************************************************"
. /home/alladmin/scripts/setEnv.sh

echo "******************************************************************************"
echo "Passwordless SSH Setup for alladmin." `date`
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
echo "${AllADMIN_PASSWORD}" > /tmp/temp2.txt

ssh-keyscan -H ${NODE2_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE2_FQ_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE2_PUBLIC_IP} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE3_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE3_FQ_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE3_PUBLIC_IP} >> ~/.ssh/known_hosts

sshpass -f /tmp/temp2.txt ssh-copy-id ${NODE2_HOSTNAME} 
sshpass -f /tmp/temp2.txt ssh-copy-id ${NODE3_HOSTNAME}

cat > /tmp/ssh-setup2.sh <<EOF
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
#sshpass -f /tmp/temp2.txt ssh-copy-id ${NODE1_HOSTNAME}
EOF

ssh ${NODE2_HOSTNAME} 'bash -s' < /tmp/ssh-setup2.sh
ssh ${NODE3_HOSTNAME} 'bash -s' < /tmp/ssh-setup2.sh
