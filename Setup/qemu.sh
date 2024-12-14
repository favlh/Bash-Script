#!/bin/bash

# Run script as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root!" 1>&2
    exit 1
fi

echo "Starting QEMU setup..."

# Detect distro
distro=$(lsb_release -si)

case "$distro" in
    "Ubuntu"|"Debian")
        echo "Detected distro: $distro"
        echo "Updating package list and installing dependencies..."
        apt update && apt install -y qemu qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager

        # Add user to the libvirt group
        usermod -aG libvirt $(whoami)
        systemctl enable libvirtd
        systemctl start libvirtd
        ;;
    "Arch"|"Manjaro")
        echo "Detected distro: $distro"
        echo "Installing QEMU and dependencies..."
        pacman -Syu --noconfirm qemu libvirt virt-manager bridge-utils

        # Add user to the libvirt group
        usermod -aG libvirt $(whoami)
        systemctl enable libvirtd
        systemctl start libvirtd
        ;;
    "Fedora")
        echo "Detected distro: $distro"
        echo "Installing QEMU and dependencies..."
        dnf install -y qemu-kvm libvirt virt-manager bridge-utils

        # Add user to the libvirt group
        usermod -aG libvirt $(whoami)
        systemctl enable libvirtd
        systemctl start libvirtd
        ;;
    "CentOS")
        echo "Detected distro: $distro"
        echo "Installing QEMU and dependencies..."
        yum install -y qemu-kvm libvirt virt-manager bridge-utils

        # Add user to the libvirt group
        usermod -aG libvirt $(whoami)
        systemctl enable libvirtd
        systemctl start libvirtd
        ;;
    *)
        echo "Distro not recognized, please install manually."
        exit 1
        ;;
esac

echo "QEMU and dependencies installed successfully!"
echo "You may need to log out and log back in for user group changes to take effect."

echo "Starting virtual machine manager (virt-manager)..."

# Starting qemu, after installation
virt-manager
