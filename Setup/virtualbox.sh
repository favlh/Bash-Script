#!/bin/bash

#----------------------------------------
# Script for VirtualBox Installation
#----------------------------------------

# Check if running as root
check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "Please run this script as root!" 1>&2
        exit 1
    fi
}

# Installation function for Ubuntu/Debian
install_deb() {
    echo "Updating package list and installing VirtualBox..."
    apt update && apt install -y virtualbox virtualbox-ext-pack dkms
}

# Installation function for Arch/Manjaro
install_arch() {
    echo "Installing VirtualBox and dependencies..."
    pacman -Syu --noconfirm virtualbox virtualbox-ext-oracle dkms
}

# Installation function for Fedora
install_fedora() {
    echo "Installing VirtualBox and dependencies..."
    dnf install -y VirtualBox VirtualBox-ext-pack dkms
}

# Installation function for CentOS
install_centos() {
    echo "Installing VirtualBox and dependencies..."
    yum install -y epel-release
    yum install -y VirtualBox VirtualBox-ext-pack dkms
}

# User and service setup function
setup_virtualbox() {
    usermod -aG vboxusers $(whoami)
    systemctl enable vboxdrv
    systemctl start vboxdrv
}

# Main script
check_root

echo "Starting VirtualBox installation..."

# Detect distro
distro=$(lsb_release -si)

case "$distro" in
    "Ubuntu"|"Debian")
        echo "Detected distro: $distro"
        install_deb
        setup_virtualbox
        ;;
    "Arch"|"Manjaro")
        echo "Detected distro: $distro"
        install_arch
        setup_virtualbox
        ;;
    "Fedora")
        echo "Detected distro: $distro"
        install_fedora
        setup_virtualbox
        ;;
    "CentOS")
        echo "Detected distro: $distro"
        install_centos
        setup_virtualbox
        ;;
    *)
        echo "Unrecognized distro, please install manually."
        exit 1
        ;;
esac

echo "VirtualBox and Extension Pack successfully installed!"
echo "You may need to logout and login again for user group changes to take effect."

echo "Starting VirtualBox..."

# Run virtualbox after installation
virtualbox
