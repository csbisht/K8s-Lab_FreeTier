provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

data "oci_core_images" "ubuntulinux" {
  compartment_id           = var.tenancy_ocid
  operating_system         = var.image_operating_system
  operating_system_version = var.image_operating_system_version

  # exclude GPU specific images
  filter {
    name   = "display_name"
    values = ["^([a-zA-z]+)-([a-zA-z]+)-([\\.0-9]+)-([\\.0-9-]+)$"]
    regex  = true
  }
}

data "oci_identity_availability_domains" "GetAds" {
  compartment_id = var.tenancy_ocid
}

module "CreateCompartment" {
  source                  = "./module-compartment"
  tenancy_ocid            = var.tenancy_ocid
  compartment_name        = var.compartment_name
  compartment_description = var.compartment_description
}

# Create a VCN for K8s Lab
module "CreateVCN" {
  source           = "./module-vcn"
  compartment_ocid = module.CreateCompartment.compartment.id
  vcn_cidr_block   = var.vcn_cidr_block
  display_name     = var.vcn_display_name
  dns_label        = var.vcn_dns_label
}

# Create IGW
module "CreateIGW" {
  source                        = "./module-igw"
  compartment_ocid              = module.CreateCompartment.compartment.id
  vcn_id                        = module.CreateVCN.vcn.id
  internet_gateway_enabled      = var.internet_gateway_enabled
  internet_gateway_display_name = var.internet_gateway_display_name
}

# Create Route Table
module "CreateRouteRule" {
  source                             = "./module-routetable"
  tenancy_ocid                       = var.tenancy_ocid
  compartment_ocid                   = module.CreateCompartment.compartment.id
  vcn_id                             = module.CreateVCN.vcn.id
  network_id                         = [module.CreateIGW.internetgateway.id]
  route_table_display_name           = var.route_table_display_name
  route_table_route_rules_cidr_block = [var.igw_route_table_rules_cidr_block]
}

# Create Security List
module "CreatePrivateSecurityList" {
  source             = "./module-securitylist"
  compartment_ocid   = module.CreateCompartment.compartment.id
  vcn_id             = module.CreateVCN.vcn.id
  tenancy_ocid       = var.tenancy_ocid
  sl_display_name    = var.private_security_list_name
  egress_destination = var.egress_destination
  egress_protocol    = var.egress_protocol
  ingress_protocol   = var.ingress_protocol
  ingress_source     = var.ingress_source
  ingress_stateless  = var.ingress_stateless
  vcn_cidr_block     = var.vcn_cidr_block
}

# Create Subnet
module "CreateSubnet" {
  source                       = "./module-subnet"
  availability_domain          = lookup(data.oci_identity_availability_domains.GetAds.availability_domains[0], "name")
  vcn_id                       = module.CreateVCN.vcn.id
  compartment_ocid             = module.CreateCompartment.compartment.id
  vcn_default_security_list_id = [module.CreatePrivateSecurityList.securitylist.id]
  vcn_default_route_table_id   = module.CreateRouteRule.routetable.id
  vcn_default_dhcp_options_id  = module.CreateVCN.vcn.default_dhcp_options_id
  sub_cidr_block               = var.cidr_block_subnet
  sub_display_name             = var.display_name_subnet
  sub_dns_label                = var.dns_label_subnet
  tenancy_ocid                 = var.tenancy_ocid
  prohibit_public_ip_on_vnic   = "false" # Set to true for private subnet
}

# Create Jump instance for K8s cluster access
module "CreateInstances_jump" {
  source                       = "./module-instance-jump"
  compartment_id               = module.CreateCompartment.compartment.id
  instance_availability_domain = lookup(data.oci_identity_availability_domains.GetAds.availability_domains[0], "name")
  subnet_id                    = module.CreateSubnet.subnet.id
  image_id                     = lookup(data.oci_core_images.ubuntulinux.images[0], "id")
  shape_id                     = var.shape_name_jump
  ssh_public_key               = var.ssh_public_key
  ssh_private_key              = var.ssh_private_key
  assign_public_ip             = var.assign_public_ip
  display_name_jump            = var.display_name_jump
}

# Create Cluster1 master instances for K8s Lab
module "CreateInstances_cluster1_master" {
  source                       = "./module-instance-cluster1/master"
  compartment_id               = module.CreateCompartment.compartment.id
  instance_availability_domain = lookup(data.oci_identity_availability_domains.GetAds.availability_domains[0], "name")
  subnet_id                    = module.CreateSubnet.subnet.id
  image_id                     = var.image_ocid_flex
  mem_val                      = var.memory_A1_flex
  cpu_val                      = var.cpu_A1_flex
  shape_id                     = var.shape_name_k8s
  ssh_public_key               = var.ssh_public_key
  ssh_private_key              = var.ssh_private_key
  assign_public_ip             = var.assign_public_ip
  display_name_cluster1_master = var.display_name_cluster1_master
}

# Create Cluster1 worker instances for K8s Lab
module "CreateInstances_cluster1_node" {
  source                       = "./module-instance-cluster1/worker-node"
  cluster1_node_count          = var.cluster1_node_count
  compartment_id               = module.CreateCompartment.compartment.id
  instance_availability_domain = lookup(data.oci_identity_availability_domains.GetAds.availability_domains[0], "name")
  subnet_id                    = module.CreateSubnet.subnet.id
  image_id                     = var.image_ocid_flex
  mem_val                      = var.memory_A1_flex
  cpu_val                      = var.cpu_A1_flex
  shape_id                     = var.shape_name_k8s
  ssh_public_key               = var.ssh_public_key
  ssh_private_key              = var.ssh_private_key
  assign_public_ip             = var.assign_public_ip
  display_name_cluster1_node   = var.display_name_cluster1_node
}
