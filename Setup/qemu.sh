#!/bin/bash

# Run script as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root!" 1>&2
    exit 1
fi

echo "Starting QEMU setup..."

# Detect distro
distro=$(lsb_release -si)

# Check if QEMU is already installed
if command -v qemu-system-x86_64 >/dev/null 2>&1; then
    echo "QEMU is already installed, skipping installation..."
else
    case "$distro" in
        "Ubuntu"|"Debian")
            echo "Detected distro: $distro"
            echo "Updating package list and installing dependencies..."
            apt update && apt install -y qemu qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager \
            qemu-system qemu-utils virt-viewer spice-vdagent dnsmasq ebtables iptables ovmf cpu-checker

            # Add user to the libvirt group
            usermod -aG libvirt $(whoami)
            usermod -aG kvm $(whoami)
            systemctl enable libvirtd
            systemctl start libvirtd
            ;;
        "Arch"|"Manjaro")
            echo "Detected distro: $distro"
            echo "Installing QEMU and dependencies..."
            pacman -Syu --noconfirm qemu libvirt virt-manager bridge-utils virt-viewer qemu-arch-extra \
            spice-vdagent dnsmasq ebtables iptables ovmf

            # Add user to the libvirt group
            usermod -aG libvirt $(whoami)
            usermod -aG kvm $(whoami)
            systemctl enable libvirtd
            systemctl start libvirtd
            ;;
        "Fedora")
            echo "Detected distro: $distro"
            echo "Installing QEMU and dependencies..."
            dnf install -y qemu-kvm libvirt virt-manager bridge-utils virt-viewer qemu-system-x86 \
            spice-vdagent dnsmasq ebtables iptables edk2-ovmf

            # Add user to the libvirt group
            usermod -aG libvirt $(whoami)
            usermod -aG kvm $(whoami)
            systemctl enable libvirtd
            systemctl start libvirtd
            ;;
        "CentOS")
            echo "Detected distro: $distro"
            echo "Installing QEMU and dependencies..."
            yum install -y qemu-kvm libvirt virt-manager bridge-utils virt-viewer qemu-system-x86 \
            spice-vdagent dnsmasq ebtables iptables edk2-ovmf

            # Add user to the libvirt group
            usermod -aG libvirt $(whoami)
            usermod -aG kvm $(whoami)
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
fi

echo "Starting virtual machine manager (virt-manager)..."

# Starting qemu, after installation
virt-manager
