#!/bin/bash
#HOME = /root

#Step 1: Setup containerd

cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sysctl --system

apt-get install -y containerd
mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml
#Changing SystemdCgroup = false -> true
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
systemctl restart containerd

#Step 2: Kernel Parameter Configuration

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system

#Step 3: Configuring Repo and Installation

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl net-tools
#sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
sudo curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/kubernetes-archive-keyring.gpg add
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
apt-cache madison kubeadm
sudo apt-get install -y kubelet=1.27.2-00 kubeadm=1.27.2-00 kubectl=1.27.2-00 cri-tools=1.26.0-00
sudo apt-mark hold kubelet kubeadm kubectl

#Step 4: Initialize Cluster with kubeadm (Only master node)
#kubeadm reset
HOME=/root
kubeadm init --pod-network-cidr=192.168.0.0/16
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
#sudo chown $(id -u):$(id -g) $HOME/.kube/config
sudo chown iptcp:iptcp $HOME/.kube/config

#echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> ~/.bashrc

#Step 5: Install Network Addon (calico) (master node)
sudo kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.0/manifests/calico.yaml
#HOME=/home/iptcp
echo "alias kubectl='sudo kubectl'" >> /home/iptcp/.bashrc
echo "alias kubeadm='sudo kubeadm'" >> /home/iptcp/.bashrc
chown iptcp:iptcp /home/iptcp/.bashrc

#echo "### COMMAND TO ADD A WORKER NODE ###"
#kubeadm token create --print-join-command --ttl 0