#!/bin/bash

# Authenticate to OCI (if not already done)
oci setup config

# Get the compartment OCID
read -p "Enter the compartment OCID: " compartment_ocid

# Retrieve a list of load balancers in the compartment
lb_list=$(oci lb list --compartment-id "$compartment_ocid")

# Iterate through each load balancer
for lb in $lb_list; do
  lb_id=$(echo $lb | jq -r '.id')
  lb_name=$(echo $lb | jq -r '.display-name')

  # List security rules for the load balancer
  rules=$(oci lb network-security-group list --load-balancer-id "$lb_id")

  # Check for 0.0.0.0/0 in any rule's source
  for rule in $rules; do
    rule_source=$(echo $rule | jq -r '.source')
    if [[ $rule_source = "0.0.0.0/0" ]]; then
      echo "Load balancer $lb_name ($lb_id) has a security rule with 0.0.0.0/0: $rule"
    fi
  done
done
