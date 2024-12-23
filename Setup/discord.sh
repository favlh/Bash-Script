#!/bin/bash

# Run script as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root!" 1>&2
    exit 1
fi

echo "Starting Discord installation..."

# Detect distro
distro=$(lsb_release -si)

case "$distro" in
    "Ubuntu"|"Debian")
        echo "Detected distro: $distro"
        echo "Updating package list and installing dependencies..."
        apt update && apt install -y wget curl gpg

        # Add Discord repository (for Ubuntu/Debian)
        wget -qO - https://discord.com/api/download/cdn/latest/discord.deb -O /tmp/discord.deb

        # Install Discord
        dpkg -i /tmp/discord.deb
        apt --fix-broken install -y
        ;;
    "Arch"|"Manjaro")
        echo "Detected distro: $distro"
        echo "Installing Discord from the official repository..."
        pacman -Syu --noconfirm discord
        ;;
    "Fedora")
        echo "Detected distro: $distro"
        echo "Installing Discord using the repository..."

        # Add Discord repository for Fedora
        dnf install -y discord

        # Install Discord
        dnf install -y discord
        ;;
    "CentOS")
        echo "Detected distro: $distro"
        echo "Installing Discord using the repository..."

        # Add the EPEL repository for CentOS
        yum install -y epel-release
        yum install -y discord

        # Install Discord
        yum install -y discord
        ;;
    *)
        echo "Distro not recognized, please install manually."
        exit 1
        ;;
esac

echo "Discord installation completed successfully!"
