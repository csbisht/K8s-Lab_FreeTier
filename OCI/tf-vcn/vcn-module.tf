module "vcn" {
  source  = "oracle-terraform-modules/default-vcn/oci"
  version = "1.0.1"
  # insert the 4 required variables here

  # Required
  compartment_ocid = "${var.compartment_id}"
  vcn_display_name = "${var.vcn_display_name}"
  vcn_cidr         = "${var.vcn_cidr}"
  vcn_dns_label = "${var.vcn_dns_label}"
}

