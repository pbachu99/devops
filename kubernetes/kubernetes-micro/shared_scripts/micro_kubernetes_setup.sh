echo "******************************************************************************"
echo " Setup Start Micro Kubernetes"
echo "******************************************************************************"
#sudo dnf --enablerepo=epel install snapd -y
dnf install -y snapd 
ln -s /var/lib/snapd/snap /snap
sleep 10
echo 'export PATH=$PATH:/var/lib/snapd/snap/bin' | sudo tee -a /etc/profile.d/snap.sh
systemctl enable --now snapd.service snapd.socket 
systemctl restart snapd.service  
snap install microk8s --classic

#mkdir -p /etc/docker/
#cat > /etc/docker/daemon.json <<EOF
#{
#"exec-opts": ["native.cgroupdriver=systemd"]
#}
#EOF
#chown $(id -u):$(id -g) /etc/docker/daemon.json
