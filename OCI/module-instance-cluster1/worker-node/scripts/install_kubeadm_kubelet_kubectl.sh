#!/bin/bash
for i in {1..3}
do
findkubeadm=`command -v kubeadm`
findkubeadmtest="$?"

if [ "${findkubeadmtest}" -gt 0 ]; then
sudo apt-get update 
sleep 5
sudo apt-get install -y kubelet=1.19.0-00 kubeadm=1.19.0-00 kubectl=1.19.0-00
sudo apt-mark hold kubelet kubeadm kubectl
sleep 5
else 
echo -e "kubeadm installed. \n"
exit 0
fi
done