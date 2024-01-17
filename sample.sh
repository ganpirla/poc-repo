#!/bin/bash

# Set your OCI region
OCI_REGION="your-region"

# Get a list of all block volumes in the compartment
block_volumes=$(oci bv volume list --compartment-id "your-compartment-id" --region $OCI_REGION --all)

echo "Block Volumes and Attachments:"

# Loop through each block volume
for volume_id in $(echo $block_volumes | jq -r '.data[].id'); do
    # Get display name of the block volume
    volume_display_name=$(oci bv volume get --volume-id $volume_id --region $OCI_REGION | jq -r '.data."display-name"')

    # Get the attachment information for the block volume
    attachment_info=$(oci bv volume-attachment list --volume-id $volume_id --region $OCI_REGION)

    # Check if the block volume is attached to any compute instance
    if [ "$(echo $attachment_info | jq -r '.data | length')" -eq 0 ]; then
        echo "Block Volume '$volume_display_name' is not attached to any compute instance."
    else
        # Get the compute instance display name
        compute_instance_id=$(echo $attachment_info | jq -r '.data[0]."instance-id"')
        compute_instance_display_name=$(oci compute instance get --instance-id $compute_instance_id --region $OCI_REGION | jq -r '.data."display-name"')

        echo "Block Volume '$volume_display_name' is attached to Compute Instance '$compute_instance_display_name'."
    fi
done
