#!/bin/bash

# Define variables
log_dir="/a/b"
trigger_file_pattern="PIRL_RAO_"

# Check if there are files matching the pattern
if [ "$(find "$log_dir" -maxdepth 1 -type f -name "${trigger_file_pattern}*" | wc -l)" -gt 0 ]; then
    # Loop through each file matching the pattern
    for file in "$log_dir/${trigger_file_pattern}"*; do
        # Generate log file with timestamp
        log_file="CDlog-$(date +"%Y%m%d-%H%M%S").txt"
        
        # Extract file name without extension
        filename=$(basename "$file")
        filename_without_extension="${filename%.*}"

        # Trigger script for the file
        ./xyz.sh "$filename" "$filename" server1 > "$log_dir/$log_file" 2>&1

        # Read return code from log file
        return_code=$(grep -oP '(?<=Return code: )[0-9]+' "$log_dir/$log_file")

        # If return code is 0, move file to archive
        if [ "$return_code" -eq 0 ]; then
            mv "$file" "$log_dir/archive"
        fi
    done
else
    echo "No files matching pattern found. Exiting..."
fi
