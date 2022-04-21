echo "******************************************************************************"
echo "Configure Start Kubernetes Control Node/Master " `date`
echo "******************************************************************************"
swapoff -a 

kubeadm config images list
#For kubernetes-version "1.21.0"
#kubeadm init --token "b9a9lo.7s1plbtydrpt57ex" --pod-network-cidr=192.168.56.0/24 --apiserver-advertise-address=192.168.56.110 --kubernetes-version "1.21.0"

kubeadm init --token "b9a9lo.7s1plbtydrpt57ex" --pod-network-cidr=192.168.56.0/24 --apiserver-advertise-address=192.168.56.110 --kubernetes-version "1.23.5"

sleep 30
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
export KUBECONFIG=/etc/kubernetes/admin.conf

export kubever=$(kubectl version | base64 | tr -d '\n')
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever"

echo "******************************************************************************"
echo " Kubernetes Control Node/Master setup end." `date`
echo "******************************************************************************"

echo "******************************************************************************"
echo "Worker Nodes can join Kubernetes Master."
echo "******************************************************************************"
sudo kubectl get nodes
sudo kubectl get pods --all-namespaces 

echo "******************************************************************************"
echo "Run kubeadm join...on Worker Node"
echo "Kubernetes Configure End." `date`
echo "******************************************************************************"

#Some checks
#kubectl -> shows help
#kubectl cluster-info
#kubectl config
#kubectl config get-users


