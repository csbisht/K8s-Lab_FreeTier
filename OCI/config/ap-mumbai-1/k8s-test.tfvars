tenancy_ocid       = "< YOUR TENANCY OCID >"
user_ocid          = "< YOUR USER OCID >"
private_key_path   = "~/K8s-Lab_FreeTier/OCI/oci_key/oci_api_key.pem"
fingerprint        = "< YOUR API FINGERPRINT >"
region             = "ap-mumbai-1"
private_security_list_name = "K8s-Lab-SL"

#####set worker node count here###its already set default value = 1 in variable.tf, if you wants to update/change the value uncomment to below####
#cluster1_node_count = "1"

###set ssh key path here to connect your VM instances
ssh_public_key            = "~/K8s-Lab_FreeTier/OCI/oci_key/K8s_test.pub"
ssh_private_key           = "~/K8s-Lab_FreeTier/OCI/oci_key/K8s_test"
