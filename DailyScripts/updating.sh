#!/bin/bash
# Update and Upgrade Script for Major Linux Distros
# This script detects the Linux distribution and runs the appropriate commands.

update_system() {
    echo "Detecting Linux distribution..."
    if [ -f /etc/debian_version ]; then
        # Debian-based distros (e.g., Ubuntu, Pop!_OS)
        echo "Detected Debian-based Linux."
        sudo apt update && sudo apt upgrade -y
        sudo apt clean
    elif [ -f /etc/redhat-release ]; then
        # Red Hat-based distros (e.g., CentOS, Fedora, Rocky Linux)
        echo "Detected Red Hat-based Linux."
        sudo dnf upgrade --refresh -y
        sudo dnf clean all
    elif [ -f /etc/arch-release ]; then
        # Arch-based distros (e.g., Manjaro, EndeavourOS)
        echo "Detected Arch-based Linux."
        sudo pacman -Syu --noconfirm
        sudo pacman -Sc --noconfirm
    elif [ -f /etc/SuSE-release ]; then
        # openSUSE-based distros
        echo "Detected openSUSE-based Linux."
        sudo zypper refresh
        sudo zypper update -y
    elif [ -f /etc/gentoo-release ]; then
        # Gentoo Linux
        echo "Detected Gentoo Linux."
        sudo emerge --sync
        sudo emerge -uDNav @world
    else
        echo "Unsupported distribution. Please update manually."
        exit 1
    fi
}

# Messages after execution
echo "Starting system update and upgrade process..."
update_system
echo "System update and upgrade completed successfully!"
