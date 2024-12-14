#!/bin/bash

# Run script as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root!" 1>&2
    exit 1
fi

echo "Starting VirtualBox installation..."

# Detect distro
distro=$(lsb_release -si)

case "$distro" in
    "Ubuntu"|"Debian")
        echo "Detected distro: $distro"
        echo "Updating package list and installing VirtualBox and dependencies..."
        apt update && apt install -y virtualbox virtualbox-ext-pack dkms

        # Add current user to vboxusers group
        usermod -aG vboxusers $(whoami)
        systemctl enable vboxdrv
        systemctl start vboxdrv
        ;;
    "Arch"|"Manjaro")
        echo "Detected distro: $distro"
        echo "Installing VirtualBox and dependencies..."
        pacman -Syu --noconfirm virtualbox virtualbox-ext-oracle dkms

        # Add current user to vboxusers group
        usermod -aG vboxusers $(whoami)
        systemctl enable vboxdrv
        systemctl start vboxdrv
        ;;
    "Fedora")
        echo "Detected distro: $distro"
        echo "Installing VirtualBox and dependencies..."
        dnf install -y VirtualBox VirtualBox-ext-pack dkms

        # Add current user to vboxusers group
        usermod -aG vboxusers $(whoami)
        systemctl enable vboxdrv
        systemctl start vboxdrv
        ;;
    "CentOS")
        echo "Detected distro: $distro"
        echo "Installing VirtualBox and dependencies..."
        yum install -y epel-release
        yum install -y VirtualBox VirtualBox-ext-pack dkms

        # Add current user to vboxusers group
        usermod -aG vboxusers $(whoami)
        systemctl enable vboxdrv
        systemctl start vboxdrv
        ;;
    *)
        echo "Distro not recognized, please install manually."
        exit 1
        ;;
esac

echo "VirtualBox and Extension Pack installed successfully!"
echo "You may need to log out and log back in for user group changes to take effect."

echo "Starting VirtualBox..."

# Starting virtualbox after install
virtualbox
