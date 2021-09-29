# The "name" of the availability domain to be used for the compute instance.
output "name-of-first-availability-domain" {
  value = data.oci_identity_availability_domains.ads.availability_domains[0].name
}

# Outputs for compute instance public ip
output "public-ip-for-compute-instance-master" {
  value = oci_core_instance.ubuntu_instance_master.public_ip
}

output "instance-name-master" {
  value = oci_core_instance.ubuntu_instance_master.display_name
}

output "instance-OCID-master" {
  value = oci_core_instance.ubuntu_instance_master.id
}

output "instance-region-master" {
  value = oci_core_instance.ubuntu_instance_master.region
}

output "instance-shape-master" {
  value = oci_core_instance.ubuntu_instance_master.shape
}

output "instance-state-master" {
  value = oci_core_instance.ubuntu_instance_master.state
}

output "instance-OCPUs-master" {
  value = oci_core_instance.ubuntu_instance_master.shape_config[0].ocpus
}

output "instance-memory-in-GBs-master" {
  value = oci_core_instance.ubuntu_instance_master.shape_config[0].memory_in_gbs
}

output "time-created-master" {
  value = oci_core_instance.ubuntu_instance_master.time_created
}

# Outputs for compute instance public ip
output "public-ip-for-compute-instance-node" {
  value = oci_core_instance.ubuntu_instance_node.*.public_ip
}

output "instance-name-node" {
  value = oci_core_instance.ubuntu_instance_node.*.display_name
}

output "instance-OCID-node" {
  value = oci_core_instance.ubuntu_instance_node.*.id
}

output "instance-region-node" {
  value = oci_core_instance.ubuntu_instance_node.*.region
}

output "instance-shape-node" {
  value = oci_core_instance.ubuntu_instance_node.*.shape
}

output "instance-state-node" {
  value = oci_core_instance.ubuntu_instance_node.*.state
}

output "time-created-node" {
  value = oci_core_instance.ubuntu_instance_node.*.time_created
}
