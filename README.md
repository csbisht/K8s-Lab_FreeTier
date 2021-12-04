<p align="center">
    <a href="https://github.com/csbisht/K8s-Lab">
        <img src="https://github.com/csbisht/K8s-Lab/blob/main/images/K8_Handson_Lab.png" height="300" alt="K8s Lab">
    </a>
</p>

## **K8s Hands on Lab**
 
In this K8s Hands on Lab, you can setup kubernetes lab environment on Oracle Cloud (OCI) and you can practice kubernetes questions to prepare CKA exam.
## **Prerequisites**
You have to create SSH key to login to compute instance on OCI (refer this link- [SSH Key OCI](https://docs.oracle.com/en-us/iaas/developer-tutorials/tutorials/tf-compute/01-summary.htm)) and also you need to Generating an API Signing Key (its optional, refer this link - [API Key OCI](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#four)). All private and public keys you need to place inside K8s-Lab/OCI/oci_key as below file name:-
```
SSH private key file:- K8s_test

SSH public key file:- K8s_test.pub

API private key file:- oci_api_key.pem
```
**Note:-** You have to add API finger print to your OCI **Identity>>Users>>User Details>>API Keys**. Else you can create API key and fingerprint from the OCI console.

**There is already available default ssh key and api key in K8s-Lab/OCI/oci_key you can use that or you can create your own keys.**

## **Steps**

**1) Login your [OCI](https://oraclecloud.com) account and click to Cloud Shell. We using cloud shell because it has pre-installed Terraform and its dependencies.**

![Cloud Shell](https://github.com/csbisht/K8s-Lab/blob/main/images/CloudShell.png)

**2) Run below command in Cloud Shell to clone the repo:**
```
git clone https://github.com/csbisht/K8s-Lab.git
```
**3) Add the Prerequisites in K8s-Lab/OCI/oci_key and OCI/config/ap-mumbai-1/k8s-test.tfvars**

![TFVARS FILE](https://github.com/csbisht/K8s-Lab/blob/main/images/tfvars_file.png)

**4) Change directory in K8s-Lab/OCI if you not there and Initialize the working directory using the terraform init command.**
```
cd K8s-Lab/OCI
terraform init
```
**5) Use the terraform plan command to test the execution plan.**
```
terraform plan -var-file config/ap-mumbai-1/k8s-test.tfvars
```
**6) Use the terraform apply command to create the OCI Compartment, VCN, Subnets, Rout Tables, Internet Gateways, Security Lists and compute instances.**
```
terraform apply -var-file config/ap-mumbai-1/k8s-test.tfvars
```
**7) After your K8s Lab infrastructure created, you need to join your worker nodes in the K8s cluster. Execute below command to join worker nodes to K8s cluster.**
```
./kubeadm_node_join_cluster.sh
```
**8) Now your K8s Lab is ready, login to jump machine to start your Lab.**

![OCI Instances](https://github.com/csbisht/K8s-Lab/blob/main/images/OCI_Instances.png)

**9) SSH to jump machine with private key K8s_test which kept in K8s-Lab/OCI/oci_key. For that you can either use Cloud Shell or Putty from your local machine and the default user will be "ubuntu".**
```
ssh -i K8s-Lab/OCI/oci_key/K8s_test ubuntu@<your jump's PublicIp>
```
**10) You have three K8s clusters in this Lab (cluster1, cluster2 and cluster3) and all clusters KUBECONFIG files are kept in $HOME/.kube, and you can use below command to connect your clusters.**
```
export KUBECONFIG=$HOME/.kube/cluster1.config
or
export KUBECONFIG=$HOME/.kube/cluster2.config
or
export KUBECONFIG=$HOME/.kube/cluster3.config
```
```
kubectl get nodes
```
**Or pass the custom file at execution time using the --kubeconfig flag:**
```
kubectl --kubeconfig=$HOME/.kube/cluster1.config get nodes
or
kubectl --kubeconfig=$HOME/.kube/cluster2.config get nodes
or
kubectl --kubeconfig=$HOME/.kube/cluster3.config get nodes
```
**11) From the jump machine you can do ssh to all cluster's node.**
```
ssh cluster1-controlplane
or
ssh cluster1-node0
or
ssh cluster2-controlplane
or
ssh cluster2-node0
or
ssh cluster3-controlplane
or
ssh cluster3-node0
```
**12) Now its time to run CKA Lab. To start the Lab you have to connect with two ssh connection on jump machine one for your Labs questions and second for your command execution. Now run below command to start Lab.**
```
./Start_CKA_Lab.sh
```

## **LICENSE**
Distributed under the GNU General Public License v2.0. See [LICENSE](https://github.com/csbisht/K8s-Lab/blob/main/LICENSE) for more information.

