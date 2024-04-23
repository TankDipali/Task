#!/bin/bash

REPORT_FILE="/home/einfochips/Desktop/Task/Report2.log"
THRESHOLD=90

CPU_USAGE=$(top -bn1 | awk '/Cpu/ {print $2}')

while :
do
    echo "System Usage:" >> "$REPORT_FILE"
    echo "-------------" >> "$REPORT_FILE"
    echo "CPU Usage: $CPU_USAGE" >> "$REPORT_FILE"
    echo "Memory Usage: $(free -m  | awk '/Mem/{print $3}')" >> "$REPORT_FILE"

    if (( $(echo "$CPU_USAGE > $THRESHOLD" | bc -l) )); then
    echo "CPU usage has exceeded the threshold of $THRESHOLD%" >> "$REPORT_FILE"
    /usr/sbin/sendmail -t <<EOF
Subject: CPU Usage Exceeded Threshold
To: dtank150@rku.ac.in

CPU usage has exceeded the threshold of $THRESHOLD%.
EOF
fi
    sleep 300
done