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
    } 
    preserve_boot_volume = false
  provisioner "file" {
    source      = "./scripts/"
    destination = "/tmp/"

    connection {
      type        = "ssh"
      host        = "${self.public_ip}"
      user        = "ubuntu"
      private_key = "${file(var.ssh_private_key)}"
    }
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/*.sh",
      "sudo /tmp/load_module_br_netfilter.sh",
      "sudo /tmp/install_curl_https_certs_keyring.sh",
      "sudo /tmp/install_kubeadm_kubelet_kubectl.sh",
      "sudo /tmp/install_container_runtime.sh",
      "sudo /tmp/install_docker.sh",
      "sudo /tmp/kubeadm_init.sh",
    ]
    connection {
      type        = "ssh"
      host        = "${self.public_ip}"
      user        = "ubuntu"
      private_key = "${file(var.ssh_private_key)}"
    }
  }
}

resource "oci_core_instance" "ubuntu_instance_node" {
    # Required
    count = "${var.node_count}"
    availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
    compartment_id = "${var.compartment_id}"
    shape = "${var.shape}"
    source_details {
        source_id = "${var.source_id}"
        source_type = "image"
    }

    # Optional
    #display_name = "${var.display_name_node}"
    display_name = "${var.display_name_node}-${count.index}"
    create_vnic_details {
        assign_public_ip = true
        subnet_id = "${var.subnet_id}"
    }
    metadata = {
        ssh_authorized_keys = file("${var.ssh_pub_key}")
    } 
    preserve_boot_volume = false
  provisioner "file" {
    source      = "./scripts/"
    destination = "/tmp/"

    connection {
      type        = "ssh"
      host        = "${self.public_ip}"
      user        = "ubuntu"
      private_key = "${file(var.ssh_private_key)}"
    }
  }
  
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/*.sh",
      "sudo /tmp/load_module_br_netfilter.sh",
      "sudo /tmp/install_curl_https_certs_keyring.sh",
      "sudo /tmp/install_kubeadm_kubelet_kubectl.sh",
      "sudo /tmp/install_container_runtime.sh",
      "sudo /tmp/install_docker.sh",
      "sudo rm -f /tmp/kubeadm_init.sh",
    ]
    connection {
      type        = "ssh"
      host        = "${self.public_ip}"
      user        = "ubuntu"
      private_key = "${file(var.ssh_private_key)}"
    }
  }
}
