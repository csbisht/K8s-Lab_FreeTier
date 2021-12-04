#!/bin/bash
	
sudo apt-get update
sleep 10

sudo apt-get install -y docker.io

sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker

sudo systemctl restart containerd
sudo iptables -F
