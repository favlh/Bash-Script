#!/bin/bash

# Run script as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root!" 1>&2
    exit 1
fi

echo "Starting VSCode installation..."

# Detect distro
distro=$(lsb_release -si)

case "$distro" in
    "Ubuntu"|"Debian")
        echo "Detected distro: $distro"
        echo "Updating package list and installing dependencies..."
        apt update && apt install -y wget curl gpg

        # Add the Microsoft GPG key
        curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /usr/share/keyrings/microsoft-archive-keyring.gpg

        # Add the VSCode repository
        echo "deb [signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/vscode stable main" | tee /etc/apt/sources.list.d/vscode.list

        # Install VSCode
        apt update && apt install -y code
        ;;
    "Arch"|"Manjaro")
        echo "Detected distro: $distro"
        echo "Installing VSCode from the official repository..."
        pacman -Syu --noconfirm code
        ;;
    "Fedora")
        echo "Detected distro: $distro"
        echo "Installing VSCode using the Microsoft repository..."
        
        # Install dependencies
        dnf install -y wget gpg
        
        # Add the Microsoft repository
        rpm --import https://packages.microsoft.com/keys/microsoft.asc
        curl https://packages.microsoft.com/config/fedora/34/prod.repo | tee /etc/yum.repos.d/vscode.repo

        # Install VSCode
        dnf install -y code
        ;;
    "CentOS")
        echo "Detected distro: $distro"
        echo "Installing VSCode using the Microsoft repository..."

        # Install dependencies
        yum install -y wget gpg

        # Add the Microsoft repository
        rpm --import https://packages.microsoft.com/keys/microsoft.asc
        curl https://packages.microsoft.com/config/rhel/7/prod.repo | tee /etc/yum.repos.d/vscode.repo

        # Install VSCode
        yum install -y code
        ;;
    *)
        echo "Distro not recognized, please install manually or use a different package manager."
        exit 1
        ;;
esac

echo "VSCode installation completed successfully!"
