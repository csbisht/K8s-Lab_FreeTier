#output "instances" {
 # value = oci_core_instance.CreateInstance_jump
#}

# Outputs for compute instance public ip
#output "instance_jump_public_ip" {
#  value = oci_core_instance.CreateInstance_jump.public_ip
#}

# Outputs for compute instance display name
output "instance_jump_name" {
  value = oci_core_instance.CreateInstance_jump.display_name
}

# Outputs for compute instance OCID
output "instance_OCID_jump" {
  value = oci_core_instance.CreateInstance_jump.id
}

# Outputs for compute instance public ip
output "instance_jump_public_ip" {
  value = oci_core_instance.CreateInstance_jump.public_ip
}

# Outputs for compute instance private ip
output "instance_jump_private_ip" {
  value = oci_core_instance.CreateInstance_jump.private_ip
}
