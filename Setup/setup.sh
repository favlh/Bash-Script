#!/bin/bash

# Check for required tools
if ! [ -x "$(command -v smartctl)" ]; then
    echo "Installing smartmontools..."
    if [ -x "$(command -v apt)" ]; then
        sudo apt install smartmontools -y
    else
        echo "Error: Package manager not supported"
        exit 1
    fi
fi

# Check specified disk device
disk="sdb"
echo "Checking disk /dev/$disk..."

# Run SMART self-test
sudo smartctl -t short /dev/$disk

# Wait for test to complete (usually takes about 2 minutes)
echo "Waiting for self-test to complete..."
sleep 120

# Get test results
result=$(sudo smartctl -l selftest /dev/$disk)

# Check for bad sectors
bad_sectors=$(sudo smartctl -a /dev/$disk | grep "Current_Pending_Sector" | awk '{print $10}')

if [ ! -z "$bad_sectors" ] && [ "$bad_sectors" -gt 0 ]; then
    echo "Found $bad_sectors bad sectors on /dev/$disk"

    # Attempt to remap bad sectors
    echo "Attempting to force read/write to remap bad sectors..."
    sudo hdparm --read-sector $(sudo smartctl -a /dev/$disk | grep "LBA_of_First_Error" | awk '{print $4}') /dev/$disk

    # Run another quick test to verify
    sudo smartctl -t short /dev/$disk
    sleep 120

    new_bad_sectors=$(sudo smartctl -a /dev/$disk | grep "Current_Pending_Sector" | awk '{print $10}')

    if [ "$new_bad_sectors" -lt "$bad_sectors" ]; then
        echo "Successfully remapped some bad sectors. Remaining bad sectors: $new_bad_sectors"
    else
        echo "Warning: Could not remap bad sectors. Consider backing up data and replacing the disk"
    fi
else
    echo "No bad sectors found on /dev/$disk"
fi

echo "Disk check complete"
