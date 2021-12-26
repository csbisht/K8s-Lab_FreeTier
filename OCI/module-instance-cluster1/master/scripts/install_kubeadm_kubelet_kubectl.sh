#!/bin/bash
kubeletversion="1.19.0-00"
kubeadmversion="1.19.0-00"
kubectlversion="1.19.0-00"

for i in {1..3}
do
findkubeadm=`command -v kubeadm`
findkubeadmtest="$?"

if [ "${findkubeadmtest}" -gt 0 ]; then
sudo apt-get update
sleep 5
sudo apt-get install -y kubelet="${kubeletversion}" kubeadm="${kubeadmversion}" kubectl="${kubectlversion}"
sudo apt-mark hold kubelet kubeadm kubectl
sleep 5
else
echo -e "kubeadm installed. \n"

####find and install kubelet if not installed
findkubelet=`command -v kubelet`
findkubelettest="$?"
if [ "${findkubelettest}" -gt 0 ]; then
sudo apt-get update
sleep 5
sudo apt-get install -y kubelet="${kubeletversion}"
sudo apt-mark hold kubelet kubeadm kubectl
sleep 5
else
echo -e "kubelet installed. \n"

####find and install kubectl if not installed
findkubectl=`command -v kubectl`
findkubectltest="$?"
if [ "${findkubectltest}" -gt 0 ]; then
sudo apt-get update
sleep 5
sudo apt-get install -y kubectl="${kubectlversion}"
sudo apt-mark hold kubelet kubeadm kubectl
sleep 5
else
echo -e "kubectl installed. \n"
exit 0
fi
fi

exit 0
fi
done
