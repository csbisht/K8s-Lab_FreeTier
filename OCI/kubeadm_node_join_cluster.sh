#!/bin/bash

k8sclustername=( "cluster1" )
joincluster () {
masterip=`terraform output instance_${1}_master_public_ip |awk -F '"' '{print $2}'`
nodeip=`terraform output instance_${1}_node_public_ip |awk -F '"' '{print $2}'`

chmod 600 ~/K8s-Lab_FreeTier/OCI/oci_key/K8s_test

kubeadmjoin=`ssh -o "StrictHostKeyChecking no" -i ~/K8s-Lab_FreeTier/OCI/oci_key/K8s_test ubuntu@"${masterip}" "sudo kubeadm token create --print-join-command"`
for i in ${nodeip}
do
ssh -o "StrictHostKeyChecking no" -i ~/K8s-Lab_FreeTier/OCI/oci_key/K8s_test ubuntu@"${i}" "sudo ${kubeadmjoin}"
done
}

addhosts () {
master_private_ip=`terraform output instance_${1}_master_private_ip |awk -F '"' '{print $2}'`
node_private_ip=( `terraform output instance_${1}_node_private_ip |awk -F '"' '{print $2}'` )
jump_private_ip=`terraform output instance_jump_private_ip |awk -F '"' '{print $2}'`
master_public_ip=`terraform output instance_${1}_master_public_ip |awk -F '"' '{print $2}'`
node_public_ip=( `terraform output instance_${1}_node_public_ip |awk -F '"' '{print $2}'` )
jump_public_ip=`terraform output instance_jump_public_ip |awk -F '"' '{print $2}'`
jump_hostname=`ssh -o "StrictHostKeyChecking no" -i ~/K8s-Lab_FreeTier/OCI/oci_key/K8s_test ubuntu@"${jump_public_ip}" "sudo hostname"`
master_hostname=`ssh -o "StrictHostKeyChecking no" -i ~/K8s-Lab_FreeTier/OCI/oci_key/K8s_test ubuntu@"${master_public_ip}" "sudo hostname"`

###add kube-config in jump
ssh -o "StrictHostKeyChecking no" -i ~/K8s-Lab_FreeTier/OCI/oci_key/K8s_test ubuntu@"${jump_public_ip}" "mkdir -p /home/ubuntu/.kube"
scp -o "StrictHostKeyChecking no" -i ~/K8s-Lab_FreeTier/OCI/oci_key/K8s_test ubuntu@"${master_public_ip}":/home/ubuntu/.kube/config ~/K8s-Lab_FreeTier/OCI/oci_key/${1}.config
scp -o "StrictHostKeyChecking no" -i ~/K8s-Lab_FreeTier/OCI/oci_key/K8s_test ~/K8s-Lab_FreeTier/OCI/oci_key/${1}.config ubuntu@"${jump_public_ip}":/home/ubuntu/.kube/${1}.config
rm ~/K8s-Lab_FreeTier/OCI/oci_key/${1}.config

###add master private ip host entry in master 
ssh -o "StrictHostKeyChecking no" -i ~/K8s-Lab_FreeTier/OCI/oci_key/K8s_test ubuntu@"${master_public_ip}" "echo "${master_private_ip}  ${master_hostname}" |sudo tee -a /etc/hosts"
###add jump private ip host entry in jump 
ssh -o "StrictHostKeyChecking no" -i ~/K8s-Lab_FreeTier/OCI/oci_key/K8s_test ubuntu@"${jump_public_ip}" "echo "${jump_private_ip}  ${jump_hostname}" |sudo tee -a /etc/hosts"
###add master host entry in jump 
ssh -o "StrictHostKeyChecking no" -i ~/K8s-Lab_FreeTier/OCI/oci_key/K8s_test ubuntu@"${jump_public_ip}" "echo "${master_private_ip}  ${master_hostname}" |sudo tee -a /etc/hosts"
###add jump host entry in master 
ssh -o "StrictHostKeyChecking no" -i ~/K8s-Lab_FreeTier/OCI/oci_key/K8s_test ubuntu@"${master_public_ip}" "echo "${jump_private_ip}  ${jump_hostname}" |sudo tee -a /etc/hosts"

for n in ${!node_private_ip[@]}
do
node_hostname=`ssh -o "StrictHostKeyChecking no" -i ~/K8s-Lab_FreeTier/OCI/oci_key/K8s_test ubuntu@"${node_public_ip["$n"]}" "sudo hostname"`
ssh -o "StrictHostKeyChecking no" -i ~/K8s-Lab_FreeTier/OCI/oci_key/K8s_test ubuntu@"${node_public_ip["$n"]}" "echo "${node_private_ip["$n"]}  ${node_hostname}" |sudo tee -a /etc/hosts"
ssh -o "StrictHostKeyChecking no" -i ~/K8s-Lab_FreeTier/OCI/oci_key/K8s_test ubuntu@"${node_public_ip["$n"]}" "echo "${master_private_ip}  ${master_hostname}" |sudo tee -a /etc/hosts"
ssh -o "StrictHostKeyChecking no" -i ~/K8s-Lab_FreeTier/OCI/oci_key/K8s_test ubuntu@"${node_public_ip["$n"]}" "echo "${jump_private_ip}  ${jump_hostname}" |sudo tee -a /etc/hosts"

for y in ${!node_public_ip[@]}
do
ipcheck=`ssh -o "StrictHostKeyChecking no" -i ~/K8s-Lab_FreeTier/OCI/oci_key/K8s_test ubuntu@"${node_public_ip["$n"]}" "sudo cat /etc/hosts |grep ${node_private_ip["$y"]}"`
if [ -z "${ipcheck}" ]; then 
othernode_hostname=`ssh -o "StrictHostKeyChecking no" -i ~/K8s-Lab_FreeTier/OCI/oci_key/K8s_test ubuntu@"${node_public_ip["$y"]}" "sudo hostname"`
ssh -o "StrictHostKeyChecking no" -i ~/K8s-Lab_FreeTier/OCI/oci_key/K8s_test ubuntu@"${node_public_ip["$n"]}" "echo "${node_private_ip["$y"]}  ${othernode_hostname}" |sudo tee -a /etc/hosts"
fi 
done 
###add node host entry in jump 
ssh -o "StrictHostKeyChecking no" -i ~/K8s-Lab_FreeTier/OCI/oci_key/K8s_test ubuntu@"${jump_public_ip}" "echo "${node_private_ip["$n"]}  ${node_hostname}" |sudo tee -a /etc/hosts"
###add node host entry in master 
ssh -o "StrictHostKeyChecking no" -i ~/K8s-Lab_FreeTier/OCI/oci_key/K8s_test ubuntu@"${master_public_ip}" "echo "${node_private_ip["$n"]}  ${node_hostname}" |sudo tee -a /etc/hosts"
done
}


for i in ${k8sclustername[@]}
do
joincluster ${i}
done

for i in ${k8sclustername[@]}
do
addhosts ${i}
done
