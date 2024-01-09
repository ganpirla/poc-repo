#!/bin/bash

# Set your OCI compartment ID
compartment_id="your-compartment-id"

# List all security lists in the compartment
security_lists=$(oci network security-list list --compartment-id $compartment_id --query 'data[*].id' --raw-output)

# Loop through each security list and check rules
for security_list_id in $security_lists
do
    echo "Checking Security List: $security_list_id"
    
    # Get details of the security list
    security_list_details=$(oci network security-list get --security-list-id $security_list_id)

    # Check each egress rule for 0.0.0.0/0
    egress_rules=$(echo $security_list_details | jq -r '.data.egress_security_rules[] | select(.destinationType == "CIDR_BLOCK" and .destination == "0.0.0.0/0")')
    
    if [ ! -z "$egress_rules" ]; then
        echo "Security List $security_list_id has egress rules allowing traffic to 0.0.0.0/0"
    fi

    # Check each ingress rule for 0.0.0.0/0
    ingress_rules=$(echo $security_list_details | jq -r '.data.ingress_security_rules[] | select(.sourceType == "CIDR_BLOCK" and .source == "0.0.0.0/0")')

    if [ ! -z "$ingress_rules" ]; then
        echo "Security List $security_list_id has ingress rules allowing traffic from 0.0.0.0/0"
    fi

    echo ""
done

# List all load balancers in the compartment
load_balancers=$(oci lb load-balancer list --compartment-id $compartment_id --query 'data[*].id' --raw-output)

# Loop through each load balancer and check for security rules
for lb_id in $load_balancers
do
    echo "Checking Load Balancer: $lb_id"
    
    # Get details of the load balancer
    lb_details=$(oci lb load-balancer get --load-balancer-id $lb_id)

    # Check each security rule for 0.0.0.0/0
    security_rules=$(echo $lb_details | jq -r '.data.securityRules[] | select(.sourceType == "CIDR_BLOCK" and .source == "0.0.0.0/0")')

    if [ ! -z "$security_rules" ]; then
        echo "Load Balancer $lb_id has security rules allowing traffic from 0.0.0.0/0"
    fi

    echo ""
done
