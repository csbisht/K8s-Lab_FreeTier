#!/bin/bash
sudo iptables -F
sudo kubeadm init --pod-network-cidr=172.168.10.0/24
sleep 5
sudo mkdir -p /root/.kube
sudo cp -i /etc/kubernetes/admin.conf /root/.kube/config
sudo chown $(id -u):$(id -g) /root/.kube/config

########install_flannel_cni###########
sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

