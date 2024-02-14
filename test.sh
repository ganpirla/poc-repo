#!/bin/bash

# Define variables
log_dir="/a/b"
log_file="CDlog-$(date +"%Y%m%d-%H%M%S").txt"
trigger_file_pattern="PIRL_RAO_"

# Check if trigger file exists
if [ -n "$(find "$log_dir" -maxdepth 1 -type f -name "${trigger_file_pattern}*" -print -quit)" ]; then
    # Trigger script and generate log file
    your_script_command > "$log_dir/$log_file" 2>&1

    # Capture return code from log file
    return_code=$(grep -oP '(?<=Return code: )[0-9]+' "$log_dir/$log_file")

    # If return code is 0, move files
    if [ "$return_code" -eq 0 ]; then
        mv "$log_dir/${trigger_file_pattern}*" "$log_dir/archive"
    fi
else
    echo "No file matching pattern found. Exiting..."
fi
