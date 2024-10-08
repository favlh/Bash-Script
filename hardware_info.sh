#!/bin/bash

# Display CPU info
echo "CPU Info:"
lscpu
echo ""

# Display memory info
echo "Memory Info:"
free -h
echo ""

# Display disk info
echo "Disk Info:"
lsblk
echo ""

# Display network interfaces
echo "Network Interfaces:"
ip a
echo ""

# Display USB devices
echo "USB Devices:"
lsusb
echo ""

# Display PCI devices
echo "PCI Devices:"
lspci
echo ""

# Display all hardware info (optional)
# Uncomment the line below if you want all details
# sudo lshw
