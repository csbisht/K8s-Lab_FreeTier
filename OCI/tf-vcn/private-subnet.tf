# Source from https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_subnet

resource "oci_core_subnet" "vcn-private-subnet"{

  # Required
  compartment_id = "${var.compartment_id}"
  vcn_id = module.vcn.vcn_id
  cidr_block = "${var.private_subnet_cidr_block}"
 
  # Optional
  security_list_ids = [oci_core_security_list.private-security-list.id]
  display_name = "${var.private-subnet-name}"
}
