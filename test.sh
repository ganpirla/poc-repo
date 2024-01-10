#!/bin/bash

# Set your OCI configuration file path
OCI_CONFIG_FILE=~/.oci/config

# Get the list of VCN OCIDs
VCN_OCIDS=$(oci network vcn list --config-file $OCI_CONFIG_FILE --query 'data[*].id' --raw-output)

# Iterate over each VCN OCID
for VCN_OCID in $VCN_OCIDS
do
    echo "Checking Route Table for VCN: $VCN_OCID"

    # Get the list of Route Table OCIDs in the current VCN
    RT_OCIDS=$(oci network route-table list --vcn-id $VCN_OCID --config-file $OCI_CONFIG_FILE --query 'data[*].id' --raw-output)

    # Iterate over each Route Table OCID
    for RT_OCID in $RT_OCIDS
    do
        echo "Checking Routes for Route Table: $RT_OCID"

        # Get the list of routes in the current Route Table
        ROUTES=$(oci network route-table get --rt-id $RT_OCID --config-file $OCI_CONFIG_FILE --query 'data[].route_rules[].destination')

        # Check if any route has destination CIDR 0.0.0.0/0
        if [[ $ROUTES == *"0.0.0.0/0"* ]]; then
            echo "Warning: Route Table $RT_OCID in VCN $VCN_OCID has a route with destination CIDR 0.0.0.0/0"
        else
            echo "Route Table $RT_OCID in VCN $VCN_OCID does not have a route with destination CIDR 0.0.0.0/0"
        fi
    done
done
