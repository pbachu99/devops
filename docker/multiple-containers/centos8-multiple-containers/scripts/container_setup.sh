echo "******************************************************************************"
echo "start Docker setup..." `date`
echo "******************************************************************************"
mkdir -p /u01/software/
cp -f /soft_shared/* /u01/software/

yum install -y /u01/software/*.rpm
# required few dependency packages will be downloaded 

#yum install -y /u01/software/docker-ce-20.10.12-3.el8.x86_64.rpm  
#yum install -y /u01/software/docker-ce-cli-20.10.12-3.el8.x86_64.rpm 
#yum install -y /u01/software/containerd.io-1.4.12-3.1.el8.x86_64.rpm 
#yum install -y /u01/software/docker-ce-rootless-extras-20.10.12-3.el8.x86_64.rpm
#yum install -y /u01/software/docker-scan-plugin-0.12.0-3.el8.x86_64.rpm 

systemctl enable docker
systemctl restart docker
#systemctl status docker

echo "******************************************************************************"
echo "Start Installing Docker Compose." `date`
echo "******************************************************************************"

curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

echo "******************************************************************************"
echo "End Installing Docker Compose." `date`
echo "******************************************************************************"
ll /usr/bin/docker-compose

docker-compose --version

echo "******************************************************************************"
echo "Start Bash Completion setup." `date`
echo "******************************************************************************"

mkdir -p /etc/bash_completion.d/ .

curl \
    -L https://raw.githubusercontent.com/docker/compose/1.29.2/contrib/completion/bash/docker-compose \
    -o /etc/bash_completion.d/docker-compose 

source ~/.bashrc 
echo "******************************************************************************"
echo "End Bash Completion setup." `date`
echo "******************************************************************************"

# install git
#dnf install git 

#add vagrant user to docker group
usermod -aG docker vagrant
echo "******************************************************************************"
echo "End Docker setup..." `date`
echo "******************************************************************************"

#mkdir -p /u01/docker_latest/
#cd /u01/docker_latest/
#yum install -y /u01/docker_latest/*.rpm
#TEMP_FILE=`ls`
#ln -s ${TEMP_FILE} latest
#ln -s /u01/docker_latest/latest/bin/docker /usr/bin/docker



