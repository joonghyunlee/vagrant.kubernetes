#!/bin/bash

MASTER_IP=$1

# Initialize kubernetes cluster
sudo kubeadm init --apiserver-advertise-address=$MASTER_IP --pod-network-cidr=10.244.0.0/16

# Move kube config file to current user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Apply CNI
kubectl apply -f sync/flannel/kube-flannel.yml

# Generate a join command for workers
kubeadm token create --print-join-command > sync/join-command
