tenancy_ocid       = "ocid1.tenancy.oc1..aaaaaaaazddlwtanhkxgohlsewfwkryumcqt25jbncov3vgjtg77dsaosr3q"
user_ocid          = "ocid1.user.oc1..aaaaaaaa4y43hzkhgtkh7vp7hxhucexqdtzl73f6l4xdzw5g6txfr5urfxha" 
private_key_path   = "~/K8s-Cluster-Infra/OCI/oci_key/oci_api_key.pem"
fingerprint        = "aa:04:45:d5:5e:dd:ea:17:84:80:b4:fd:b6:6e:a2:0a"
region             = "ap-mumbai-1"
compartment_id     = "ocid1.compartment.oc1..aaaaaaaavcmcjq7mduuwofp67mex2wr7ld53vt3hurk5c5ygd7lbiw5awbtq"

###vcn_display_name
vcn_display_name         = "vcnk8s"
###vcn cidr
vcn_cidr                 = "10.0.0.0/16"
###vcn domain name
vcn_dns_label            = "vcnk8s"

###security-list for private/public subnet name
security_list_private_subnet_name   = "k8s-security-list-private-subnet"
security_list_public_subnet_name    = "k8s-security-list-public-subnet"
