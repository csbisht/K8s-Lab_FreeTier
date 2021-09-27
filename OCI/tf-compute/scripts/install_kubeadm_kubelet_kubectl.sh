#!/bin/bash
sudo apt-get update
sleep 10
sudo apt-get install -y kubelet=1.19.0-00 kubeadm=1.19.0-00 kubectl=1.19.0-00

sudo apt-mark hold kubelet kubeadm kubectl
