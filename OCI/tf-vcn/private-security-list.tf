# Source from https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_security_list

resource "oci_core_security_list" "private-security-list"{

# Required
  compartment_id = "${var.compartment_id}"
  vcn_id = module.vcn.vcn_id

# Optional
  display_name = "${var.security_list_private_subnet_name}"

  
  egress_security_rules {
      stateless = false
      destination = "0.0.0.0/0"
      destination_type = "CIDR_BLOCK"
      protocol = "all" 
  }

  ingress_security_rules { 
      stateless = false
      source = "10.0.0.0/16"
      source_type = "CIDR_BLOCK"
      protocol = "all"
  }
}
