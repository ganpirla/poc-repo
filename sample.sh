#!/bin/bash

# Replace these values with your actual OCI information
compartment_id="your-compartment-id"
availability_domain="your-availability-domain"

# List unattached block volumes
echo "Unattached Block Volumes:"
oci bv volume list --compartment-id $compartment_id --lifecycle-state AVAILABLE --availability-domain $availability_domain --query "data[?attachmentCount == 0].{Name: display-name, OCID: id}" --all

# List unattached boot volumes
echo -e "\nUnattached Boot Volumes:"
oci bv boot-volume list --compartment-id $compartment_id --lifecycle-state AVAILABLE --availability-domain $availability_domain --query "data[?attachmentCount == 0].{Name: display-name, OCID: id}" --all
