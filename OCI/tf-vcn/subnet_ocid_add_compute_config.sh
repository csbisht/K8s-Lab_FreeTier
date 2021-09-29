#!/bin/bash

subnet_ocid=`terraform output |grep private-subnet-OCID |cut -d'"' -f2`
config_value=`cat ../tf-compute/config/test/ap-mumbai-1/k8s-test.tfvars |grep subnet_id |cut -d'"' -f2`

sed -i "s/${config_value}/${subnet_ocid}/" ../tf-compute/config/test/ap-mumbai-1/k8s-test.tfvars
