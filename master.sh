#!/bin/bash

# Install Docker
sudo yum install docker -y
sudo systemctl enable docker.service
sudo systemctl start docker.service

# Disable SELinux
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# Disable CentOS firewall
sudo systemctl disable firewalld
sudo systemctl stop firewalld

# Disable swapping
sudo swapoff -a

# Enable iptable
sudo bash -c 'echo "net.bridge.bridge-nf-call-ip6tables = 1" > /etc/sysctl.d/k8s.conf'
sudo bash -c 'echo "net.bridge.bridge-nf-call-iptables = 1" >> /etc/sysctl.d/k8s.conf'
sudo sysctl --system

# Install kubernetes
sudo bash -c 'cat << EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF'

sudo yum install -y kubeadm kubelet kubectl

sudo systemctl enable kubelet
sudo kubeadm init --apiserver-advertise-address=100.0.0.10 --pod-network-cidr=10.244.0.0/16

# Move kube config file to a regular user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Apply CNI
wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

