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

mkdir /k8s-install
touch /k8s-install/kubeadm-config.yaml
printf \
'apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
kubernetesVersion: 1.18.10
controlPlaneEndpoint: "k8smaster:6443"'\
| tee -a /k8s-install/kubeadm-config.yaml
kubeadm init --pod-network-cidr=172.19.0.0/16 --config=/k8s-install/kubeadm-config.yaml --upload-certs | tee /k8s-install/kubeadm-init.out
