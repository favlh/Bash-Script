#!/bin/bash
## This script is to install whatsapp manager

# Run script as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root!" 1>&2
    exit 1
fi

echo "Starting WhatsApp installation..."

# Detect distro
distro=$(lsb_release -si)

case "$distro" in
    "Ubuntu"|"Debian")
        echo "Detected distro: $distro"
        echo "Updating package list and installing dependencies..."
        apt update && apt install -y wget curl gdebi

        # Download WhatsApp Electron
        wget https://github.com/mortom99/whatsapp-web-electron/releases/download/1.1.0/whatsapp-web-1.1.0-amd64.deb -O /tmp/whatsapp-web.deb

        # Install WhatsApp
        gdebi /tmp/whatsapp-web.deb
        ;;
    "Arch"|"Manjaro")
        echo "Detected distro: $distro"
        echo "Installing WhatsApp from AUR..."
        pacman -Syu --noconfirm yay
        yay -S --noconfirm whatsapp-electron
        ;;
    "Fedora")
        echo "Detected distro: $distro"
        echo "Installing WhatsApp using the repository..."

        # Install dependencies and Electron package
        dnf install -y wget curl rpm
        wget https://github.com/mortom99/whatsapp-web-electron/releases/download/1.1.0/whatsapp-web-1.1.0-x86_64.rpm -O /tmp/whatsapp-web.rpm

        # Install WhatsApp
        rpm -i /tmp/whatsapp-web.rpm
        ;;
    "CentOS")
        echo "Detected distro: $distro"
        echo "Installing WhatsApp using the repository..."

        # Install dependencies
        yum install -y wget curl rpm

        # Download WhatsApp Electron
        wget https://github.com/mortom99/whatsapp-web-electron/releases/download/1.1.0/whatsapp-web-1.1.0-x86_64.rpm -O /tmp/whatsapp-web.rpm

        # Install WhatsApp
        rpm -i /tmp/whatsapp-web.rpm
        ;;
    *)
        echo "Distro not recognized, please install manually."
        exit 1
        ;;
esac

echo "WhatsApp installation completed successfully!"
