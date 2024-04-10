#!/bin/bash

REPORT_FILE="/home/einfochips/Desktop/Task/report.txt"

get_system_usage() {
    echo "System Usage:" >> "$REPORT_FILE"
    echo "-------------" >> "$REPORT_FILE"
    echo "CPU Usage: $(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')%" >> "$REPORT_FILE"
    echo "Memory Usage: $(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
}

get_top_processes() {
    echo "Top Processes:" >> "$REPORT_FILE"
    echo "-------------" >> "$REPORT_FILE"
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6 >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
}

get_disk_space() {
    echo "Disk Space Usage:" >> "$REPORT_FILE"
    echo "----------------" >> "$REPORT_FILE"
    df -h >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
}

get_network_activity() {
    echo "Network Activity:" >> "$REPORT_FILE"
    echo "-----------------" >> "$REPORT_FILE"
    netstat -an | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}' >> "$REPORT_FILE"
}

main() {
    echo "System Report - $(date)" > "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    get_system_usage
    get_top_processes
    get_disk_space
    get_network_activity
}

main
