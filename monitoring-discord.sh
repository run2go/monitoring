#!/bin/bash

# Webhook Params
DISCORD_USER_ID=abc
DISCORD_CHANNEL_ID=def
DISCORD_TOKEN=xyz

# Thresholds Params
MEMORY_THRESHOLD=95
LOAD_THRESHOLD=90
DISK_THRESHOLD=80

# Get memory usage
memory_usage=$(free | awk '/Mem/{printf("%.2f", $3/$2 * 100)}' | sed 's/,/./g')

# Get number of CPU cores
num_cores=$(nproc)

# Get load average (15min)
load_average=$(uptime | awk -F'average:' '{printf("%.2f", $2)}' | sed 's/,/./g')

# Get overall disk size & currently used disk space
disk_size=$(df -h --output=size / | sed -n 2p)
disk_used=$(df -h --output=pcent / | sed -n 2p | tr -dc '0-9')

# Initialize the variable to store the report message
report_message=""

# Check if memory usage exceeds threshold
if awk -v mem_threshold="$MEMORY_THRESHOLD" -v memory_usage="$memory_usage" 'BEGIN { if (memory_usage > mem_threshold) exit 0; else exit 1 }'; then
    report_message+="- Memory usage exceeds threshold of $MEMORY_THRESHOLD%. Current memory usage: $memory_usage%.\n"
fi

# Check if load average exceeds threshold
if awk -v load_threshold="$LOAD_THRESHOLD" -v load_avg="$load_average" -v cores="$num_cores" 'BEGIN { if ((load_avg / cores) > (load_threshold / 100)) exit 0; else exit 1 }'; then
    report_message+="- Load average exceeds threshold of $LOAD_THRESHOLD%. Current load average: $load_average (Based on $num_cores cores).\n"
fi

# Check if disk space exceeds threshold
if awk -v disk_threshold="$DISK_THRESHOLD" -v disk_used="$disk_used" 'BEGIN { if (disk_used > disk_threshold) exit 0; else exit 1 }'; then
    report_message+="- Disk space usage exceeds threshold of $DISK_THRESHOLD%. Disk size: $disk_size, Disk usage: $disk_used%.\n"
fi

# Send report message if any threshold is exceeded
if [ -n "$report_message" ]; then
    curl -X POST -H "Content-Type: application/json" -d '{
        "content": "<@'$DISCORD_USER_ID'>",
        "embeds": [{
            "title": "**[Monitoring] Warning @'"$(hostname)"'**",
            "description": "'"$report_message"'",
            "color": "16732439"
            }]
    }' https://discord.com/api/webhooks/$DISCORD_CHANNEL_ID/$DISCORD_TOKEN
fi
