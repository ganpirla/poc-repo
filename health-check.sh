#!/bin/bash

# Set the recipient email address
recipient="user@example.com"

# Set the warning threshold for various parameters
cpu_warning=90
mem_warning=90
disk_warning=90
load_warning=5

# Get the current system status
cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
mem=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
disk=$(df -h / | tail -1 | awk '{print $5}' | cut -d'%' -f1)
load=$(uptime | awk '{print $10}' | sed 's/,//')

# Check the system status and send an email notification if any parameter exceeds the warning threshold
if (( $(echo "$cpu > $cpu_warning" | bc -l) )); then
    echo "CPU usage is high: $cpu%" | mail -s "System health check warning" $recipient
fi

if (( $(echo "$mem > $mem_warning" | bc -l) )); then
    echo "Memory usage is high: $mem%" | mail -s "System health check warning" $recipient
fi

if (( $(echo "$disk > $disk_warning" | bc -l) )); then
    echo "Disk usage is high: $disk%" | mail -s "System health check warning" $recipient
fi

if (( $(echo "$load > $load_warning" | bc -l) )); then
    echo "System load is high: $load" | mail -s "System health check warning" $recipient
fi
