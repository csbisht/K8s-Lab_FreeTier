resource "oci_core_instance" "ubuntu_instance_master" {
    # Required
    availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
    compartment_id = "${var.compartment_id}"
    shape = "${var.shape}"
    source_details {
        source_id = "${var.source_id}"
        source_type = "image"
    }

    # Optional
    display_name = "${var.display_name_master}"
    create_vnic_details {
        assign_public_ip = true
        subnet_id = "${var.subnet_id}"
    }
    metadata = {
        ssh_authorized_keys = file("${var.ssh_pub_key}")
        user_data = "${base64encode(var.user-data)}"
        user_data_kubeadm = "${base64encode(var.user-data-kubeadm)}"
    } 
    preserve_boot_volume = false
}

resource "oci_core_instance" "ubuntu_instance_node" {
    # Required
    availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
    compartment_id = "${var.compartment_id}"
    shape = "${var.shape}"
    source_details {
        source_id = "${var.source_id}"
        source_type = "image"
    }

    # Optional
    display_name = "${var.display_name_node}"
    create_vnic_details {
        assign_public_ip = true
        subnet_id = "${var.subnet_id}"
    }
    metadata = {
        ssh_authorized_keys = file("${var.ssh_pub_key}")
        user_data = "${base64encode(var.user-data)}"
    } 
    preserve_boot_volume = false
}

variable "user-data" {
  default = <<EOF
#!/bin/bash -x
sudo modprobe br_netfilter
echo 'br_netfilter' | sudo tee /etc/modules-load.d/k8s.conf

echo 'net.bridge.bridge-nf-call-ip6tables = 1' | sudo tee /etc/sysctl.d/k8s.conf
echo 'net.bridge.bridge-nf-call-iptables = 1' | sudo tee -a /etc/sysctl.d/k8s.conf

sudo sysctl --system
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg


echo 'deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet=1.19.0-00 kubeadm=1.19.0-00 kubectl=1.19.0-00
sudo apt-mark hold kubelet kubeadm kubectl

echo 'overlay' | sudo tee /etc/modules-load.d/containerd.conf
echo 'br_netfilter' | sudo tee -a /etc/modules-load.d/containerd.conf


sudo modprobe overlay
sudo modprobe br_netfilter


echo 'net.bridge.bridge-nf-call-iptables  = 1' | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
echo 'net.ipv4.ip_forward                 = 1' | sudo tee -a /etc/sysctl.d/99-kubernetes-cri.conf
echo 'net.bridge.bridge-nf-call-ip6tables = 1' | sudo tee -a /etc/sysctl.d/99-kubernetes-cri.conf


sudo sysctl --system
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce=5:19.03.15~3-0~ubuntu-focal docker-ce-cli=5:19.03.15~3-0~ubuntu-focal containerd.io
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd

getline=`grep -n "\[plugins\.\"io\.containerd\.grpc\.v1\.cri\"\.containerd\.runtimes\.runc\.options\]" /etc/containerd/config.toml |cut -d':' -f1`
nextline=`expr $${getline} + 1`
sudo sed -i "$${nextline}i \ \t  SystemdCgroup = true" /etc/containerd/config.toml
sudo systemctl restart containerd

sudo mkdir -p /etc/docker
echo '{' | sudo tee /etc/docker/daemon.json
echo '"exec-opts": ["native.cgroupdriver=systemd"],' | sudo tee -a /etc/docker/daemon.json
echo '"log-driver": "json-file",' | sudo tee -a /etc/docker/daemon.json
echo '"log-opts": {' | sudo tee -a /etc/docker/daemon.json
echo '"max-size": "100m"' | sudo tee -a /etc/docker/daemon.json
echo '},' | sudo tee -a /etc/docker/daemon.json
echo '"storage-driver": "overlay2"' | sudo tee -a /etc/docker/daemon.json
echo '}' | sudo tee -a /etc/docker/daemon.json
sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl restart containerd
iptables -F
EOF
}

variable "user-data-kubeadm" {
  default = <<EOF
#!/bin/bash -x
sudo kubeadm init --pod-network-cidr=172.168.10.0/24
EOF
}
