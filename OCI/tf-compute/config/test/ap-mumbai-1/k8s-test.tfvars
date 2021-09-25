tenancy_ocid       = "ocid1.tenancy.oc1..aaaaaaaazddlwtanhkxgohlsewfwkryumcqt25jbncov3vgjtg77dsaosr3q"
user_ocid          = "ocid1.user.oc1..aaaaaaaa4y43hzkhgtkh7vp7hxhucexqdtzl73f6l4xdzw5g6txfr5urfxha" 
private_key_path   = "~/K8s-Cluster-Infra/OCI/oci_key/oci_api_key.pem"
fingerprint        = "aa:04:45:d5:5e:dd:ea:17:84:80:b4:fd:b6:6e:a2:0a"
region             = "ap-mumbai-1"
compartment_id     = "ocid1.compartment.oc1..aaaaaaaavcmcjq7mduuwofp67mex2wr7ld53vt3hurk5c5ygd7lbiw5awbtq"

###add your subnet ocid here to setup the vm instances
#subnet_id          = "<YOUR SUBNET OCID>"
subnet_id          = "ocid1.subnet.oc1.ap-mumbai-1.aaaaaaaabz5flmff3c4ege7jhqb4tlvldeyil6v7re2tygujb4tfec35b3sa"

###select your OS image id here. ##Canonical-Ubuntu-20.04-2021.08.26-0 
source_id          = "ocid1.image.oc1.ap-mumbai-1.aaaaaaaajohn5cjow425zcawzsmjpyc7nekdm4emyjvd5vyvfe5obfa675ta"

###select the type of VM here. ##VM.Standard.E2.1.Micro
#shape              = "VM.Standard.E2.1.Micro"
shape              = "VM.Standard.E2.1"

###set the VM instance name here.
display_name_master       = "K8s_master"
display_name_node         = "K8s_node"

###set ssh key path here to connect your VM instances
ssh_pub_key               = "~/K8s-Cluster-Infra/OCI/oci_key/K8s_test.pub"

