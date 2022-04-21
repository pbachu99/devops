. /vagrant_config/install.env

echo "******************************************************************************"
echo "Create environment scripts." `date`
echo "******************************************************************************"
mkdir -p /home/alladmin/scripts

cat > /home/alladmin/scripts/setEnv.sh <<EOF
# Alladmin Settings
export TMP=/tmp
export TMPDIR=\$TMP
export HOSTNAME=${NODE2_FQ_HOSTNAME}
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
ssh-keyscan -H ${NODE2_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE2_FQ_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE2_PUBLIC_IP} >> ~/.ssh/known_hosts
ssh-keyscan -H localhost >> ~/.ssh/known_hosts
chmod -R 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
ssh ${NODE2_HOSTNAME} date
echo "${ALLADMIN_PASSWORD}" > /tmp/temp2.txt 

