swapoff -a
sed -i -e 's\/swap.img\#/swap.img\g' /etc/fstab
apt-get update && apt-get upgrade -y

printf '192.168.1.151  k8smaster  k8smaster.lab.local
192.168.1.161  k8snode1  k8snode1.lab.local
192.168.1.162  k8snode2  k8snode2.lab.local' | tee -a /etc/hosts

apt-get install -y docker.io

systemctl enable docker.service && systemctl start docker
#
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add

touch /etc/apt/sources.list.d/kubernetes.list
echo 'deb http://apt.kubernetes.io/  kubernetes-xenial  main' | tee -a /etc/apt/sources.list.d/kubernetes.list
apt-get update

apt-get install -y kubeadm=1.18.10-00 kubelet=1.18.10-00 kubectl=1.18.10-00

apt-mark hold kubelet kubeadm kubectl
