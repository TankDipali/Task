#!/bin/bash
printf "Memory\t\tDisk\t\tCPU\n"
end=$((SECONDS+60))
MEMORY_THRESHOLD=80
while [ $SECONDS -lt $end ]; do
    MEMORY=$(free -m | awk 'NR==2{printf "%.2f%%\t\t", $3*100/$2}')
    DISK=$(df -h | awk '$NF=="/"{printf "%s\t\t", $5}')
    CPU=$(top -bn1 | grep load | awk '{printf "%.2f%%\t\t\n", $(NF-2)}')
    echo "$MEMORY$DISK$CPU"
    MEMORY_USAGE=$(free | awk 'NR==2 {print $3/$2 * 100}')
    if(( $(echo "$MEMORY_USAGE > $MEMORY_THRESHOLD" | bc -l) )); then
        echo "Memory usage crossed threshold. Clear Cache..."
        sync; echo 3 > /proc/sys/vm/drop_caches
        echo "Cache Cleared..."
    fi
    sleep 2
done