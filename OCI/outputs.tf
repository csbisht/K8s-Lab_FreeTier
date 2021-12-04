##Jump instance output
output "instance_jump_name" {
  value = "${module.CreateInstances_jump.instance_jump_name}"
}
output "instance_OCID_jump" {
  value = "${module.CreateInstances_jump.instance_OCID_jump}"
}
output "instance_jump_public_ip" {
     value = "${module.CreateInstances_jump.instance_jump_public_ip}"
}
output "instance_jump_private_ip" {
     value = "${module.CreateInstances_jump.instance_jump_private_ip}"
}

##cluster1 master output
output "instance_cluster1_master_name" {
  value = "${module.CreateInstances_cluster1_master.instance_cluster1_master_name}"
}
output "instance_OCID_cluster1_master" {
  value = "${module.CreateInstances_cluster1_master.instance_OCID_cluster1_master}"
}
output "instance_cluster1_master_public_ip" {
     value = "${module.CreateInstances_cluster1_master.instance_cluster1_master_public_ip}"
}
output "instance_cluster1_master_private_ip" {
     value = "${module.CreateInstances_cluster1_master.instance_cluster1_master_private_ip}"
}

##cluster1 worker node output
output "instance_cluster1_node_name" {
  value = "${module.CreateInstances_cluster1_node.instance_cluster1_node_name}"
}
output "instance_OCID_cluster1_node" {
  value = "${module.CreateInstances_cluster1_node.instance_OCID_cluster1_node}"
}
output "instance_cluster1_node_public_ip" {
     value = "${module.CreateInstances_cluster1_node.instance_cluster1_node_public_ip}"
}
output "instance_cluster1_node_private_ip" {
     value = "${module.CreateInstances_cluster1_node.instance_cluster1_node_private_ip}"
}
