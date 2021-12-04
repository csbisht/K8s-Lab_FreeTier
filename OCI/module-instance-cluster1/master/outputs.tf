# Outputs for compute instance display name
output "instance_cluster1_master_name" {
  value = oci_core_instance.CreateInstance_cluster1_master.display_name
}

# Outputs for compute instance OCID
output "instance_OCID_cluster1_master" {
  value = oci_core_instance.CreateInstance_cluster1_master.id
}

# Outputs for compute instance public ip
output "instance_cluster1_master_public_ip" {
  value = oci_core_instance.CreateInstance_cluster1_master.public_ip
}

# Outputs for compute instance private ip
output "instance_cluster1_master_private_ip" {
  value = oci_core_instance.CreateInstance_cluster1_master.private_ip
}

