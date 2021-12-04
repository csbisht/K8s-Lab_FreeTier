variable "vcn_id" {}
variable "tenancy_ocid" {}
variable "compartment_ocid" {}
variable "sl_display_name" {}
variable "egress_destination" {}
variable "egress_protocol" {}
variable "ingress_source" {}
variable "ingress_stateless" {}
variable "ingress_protocol" {}
variable "vcn_cidr_block" {}



resource "oci_core_security_list" "CreateSecurityList" {
  compartment_id = var.compartment_ocid
  vcn_id         = var.vcn_id
  display_name   = var.sl_display_name
  egress_security_rules {
      stateless = false
      destination = var.egress_destination
      destination_type = "CIDR_BLOCK"
      protocol = var.egress_protocol
  }
  ingress_security_rules {
      stateless = var.ingress_stateless
      source = var.ingress_source
      source_type = "CIDR_BLOCK"
      protocol = "all"
  }
  ingress_security_rules {
      stateless = var.ingress_stateless
      source = var.ingress_source
      source_type = "CIDR_BLOCK"
      # Get protocol numbers from https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml TCP is 6
      protocol = var.ingress_protocol
      tcp_options {
          min = 22
          max = 22
      }
    }
  ingress_security_rules {
      stateless = var.ingress_stateless
      source = var.ingress_source
      source_type = "CIDR_BLOCK"
      # Get protocol numbers from https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml ICMP is 1
      protocol = "1"
      # For ICMP type and code see: https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xhtml
      icmp_options {
        type = 3
        code = 4
      }
    }
  ingress_security_rules {
      stateless = false
      source = var.vcn_cidr_block
      source_type = "CIDR_BLOCK"
      # Get protocol numbers from https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml ICMP is 1
      protocol = "1"
      # For ICMP type and code see: https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xhtml
      icmp_options {
        type = 3
      }
   }
}

