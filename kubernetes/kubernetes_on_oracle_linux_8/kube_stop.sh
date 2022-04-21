#############################################################
# This script stops Kubernetes systems          #
#############################################################

# NOTE: change the directory path names as suitable on your system
# NOTE: in my case the vagrant installed under D Drive on Windows

# usage:  
# to stop individual-> sh kube_stop.sh dns or node1 or node2 or node3
# Or to stop all in a one go then type on the command line
# sh kube_stop.sh dns && sh kube_stop.sh node1 && sh kube_stop.sh node2 && sh kube_stop.sh node3

case "${1}" in
dns)
echo "#######################################################"
echo " stop DNS "
echo "#######################################################"

var_dir='cd /d/git/vagrant/devops/kubernetes_on_centos8/dns/'
var_stop='vagrant halt'
$var_dir ; $var_stop
;;

node1)
echo "#######################################################"
echo "# stop Node1 of Kubernetes "
echo "#######################################################"

var_dir='cd /d/git/vagrant/devops/kubernetes_on_centos8/node1/'
var_stop'vagrant halt'
$var_dir ; $var_stop
;;

node2)
echo "#######################################################"
echo "# stop Node2 of Kubernetes "
echo "#######################################################"

var_dir='cd /d/git/vagrant/devops/kubernetes_on_centos8/node2/'
var_stop='vagrant halt'
$var_dir ; $var_stop
;;

node3)
echo "#######################################################"
echo "# stop Node3 of Kubernetes "
echo "#######################################################"

var_dir='cd /d/git/vagrant/devops/kubernetes_on_centos8/node3/'
var_stop='vagrant halt'
$var_dir ; $var_stop
;;
  *)
    echo 'Supply a valid option.' >&2
    exit 1
    ;;
esac

