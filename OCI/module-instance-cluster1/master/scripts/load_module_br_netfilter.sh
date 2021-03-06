#!/bin/bash
sudo sed -i 's/-net.ipv4.conf.all.promote_secondaries/#-net.ipv4.conf.all.promote_secondaries/g' /usr/lib/sysctl.d/50-default.conf

sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system
