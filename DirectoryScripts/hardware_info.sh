#!/bin/bash

# =============================
# System Hardware Information
# =============================

print_header() {
    echo -e "\n====== $1 ======"
}

# Display CPU information
print_header "CPU INFO"
lscpu | grep -E "^(Model name|Architecture|CPU\(s\)|Thread|Core|Socket)"

# Display memory information
print_header "MEMORY INFO"
free -h | awk 'NR==1{print}\
              NR==2{printf "%-15s%10s%10s%10s\n", $1, $2, $3, $4}'

# Display disk information
print_header "DISK INFO"
lsblk --output NAME,SIZE,TYPE,MOUNTPOINT

# Display network interfaces
print_header "NETWORK INTERFACES"
ip -br addr show

# Display USB devices
print_header "USB DEVICES"
lsusb | sort

# Display PCI devices
print_header "PCI DEVICES"
lspci | grep -E "VGA|Network|Audio|USB"

# Display all hardware info (optional)
print_header "FULL HARDWARE INFO"
# Uncomment line below for complete details
# sudo lshw -short
