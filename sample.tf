#!/bin/bash

# Specify the process name to check
process_name="your_process_name"

# Check if the process is already running
if pgrep -f "$process_name" >/dev/null; then
  echo "The process $process_name is already running. Exiting."
  exit 1
fi

# Add your desired commands or actions here
echo "Starting the script..."
# Your script commands go here

# End of the script
echo "Script completed."



===


#!/bin/bash

# Specify the process name to check
process_name="your_process_name"

# Check if the process is already running
if pgrep -f "$process_name" >/dev/null; then
  echo "The process $process_name is already running. Exiting."
  exit 1
fi

# Add the startup command for the additional script
additional_script="path/to/your/additional_script.sh"

# Check if the additional script exists
if [ ! -x "$additional_script" ]; then
  echo "The additional script $additional_script does not exist or is not executable. Exiting."
  exit 1
fi

# Run the additional script
echo "Starting the additional script..."
"$additional_script"

# Add your desired commands or actions here
echo "Starting the main script..."
# Your script commands go here

# End of the script
echo "Script completed."

