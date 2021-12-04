variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}

# Variables to create compartments for K8s Lab
variable "compartment_name" { default = "k8s-labs" }
variable "compartment_description" { default = "Compartment for K8s Labs" }

# IGW variables
variable "internet_gateway_enabled" { default = "true" }
variable "internet_gateway_display_name" { default = "K8sLabIGW" }
variable "igw_route_table_rules_cidr_block" { default = "0.0.0.0/0" }

# Route table variables
variable "route_table_display_name" {
  default = "K8sLasbRouteTable"
}


# VCN variables
variable "vcn_cidr_block" { default = "10.0.0.0/16" }
variable "vcn_display_name" { default = "K8slabs" }
variable "vcn_dns_label" { default = "k8slabs" }
variable "ad_number" {
  default = "0"
}
variable "compartment_display_name" {
  default = "k8s-labs"
}
variable "vcn_ingress_protocol" {
  default = "all"
}

# Private security list variables
variable "private_security_list_name" {
  default = "PrivateSecurityList"
}
variable "egress_destination" {
  default = "0.0.0.0/0"
}
variable "egress_protocol" {
  default = "all"
}
variable "ingress_source" {
  default = "0.0.0.0/0"
}
variable "ingress_protocol" {
  default = "6"
}
variable "ingress_stateless" {
  default = false
}

# Subnet variables
variable "cidr_block_subnet" {
  default = "10.0.254.0/24"
}
variable "display_name_subnet" {
  default = "k8slab-subnet"
}
variable "dns_label_subnet" {
  default = "k8slab"
}


##INSTANCE VARIABLES
variable "image_operating_system" {
  default = "Canonical Ubuntu"
} 
variable "image_operating_system_version" {
  default = "20.04"
} 

###Image ocid for Flex instance
variable "image_ocid_flex" {
  default = "ocid1.image.oc1.ap-mumbai-1.aaaaaaaastc435xecq5snxnwqyflyo6pbnhah64nb2bnl7kfzfod733pkhua"
}

###Memory for Flex instance
variable "memory_A1_flex" {
  default = "8"
}  

###CPU for Flex instance
variable "cpu_A1_flex" {
  default = "2"
} 

variable "shape_name_jump" {
  default = "VM.Standard.E2.1.Micro"
} 
variable "shape_name_k8s" {
  default = "VM.Standard.A1.Flex"
} 
variable "source_type" {
  default = "image"
}
variable "assign_public_ip" {
  default = "true"
}
variable "ssh_public_key" {
  default = "Add here SSH key"
}
variable "ssh_private_key" {
  default = "Add here SSH key"
}
variable "display_name_jump" {
  default = "K8s_jump"
}
variable "display_name_cluster1_master" {
  default = "cluster1_controlplane"
}
variable "display_name_cluster1_node" {
  default = "cluster1_node"
}
variable "cluster1_node_count" {
  default = "1"
}
