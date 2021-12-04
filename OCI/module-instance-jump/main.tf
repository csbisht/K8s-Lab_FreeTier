variable "compartment_id" {}
variable "instance_availability_domain" {}
variable "shape_id" {}
variable "image_id" {}
variable "subnet_id" {}
variable "ssh_public_key" {}
variable "assign_public_ip" {}
variable "ssh_private_key" {}
variable "display_name_jump" {}

resource "oci_core_instance" "CreateInstance_jump" {
  availability_domain = var.instance_availability_domain
  compartment_id      = var.compartment_id
  shape               = var.shape_id
  source_details {
    source_id   = var.image_id
    source_type = "image"
  }

    # Optional
    display_name = var.display_name_jump
    create_vnic_details {
        subnet_id = "${var.subnet_id}"
    }
  metadata = {
    ssh_authorized_keys = file("${var.ssh_public_key}")
  }
   preserve_boot_volume = false

  provisioner "file" {
    source = "${var.ssh_private_key}"
    destination = "~/.ssh/id_rsa"

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = "${file(var.ssh_private_key)}"
    }
  }
  provisioner "file" {
    source      = "./module-instance-jump/scripts/"
    destination = "/tmp/"

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = "${file(var.ssh_private_key)}"
    }
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/*.sh",
      "sudo /tmp/install_kubectl.sh",
      "sudo /tmp/sshkeepalive.sh",
      "sudo mv /tmp/Start_CKA_Lab.sh /home/ubuntu/",
      "sudo /tmp/clonegitrepo.sh",
      "chmod 600 ~/.ssh/id_rsa",
    ]
    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = "${file(var.ssh_private_key)}"
    }
  }
}
