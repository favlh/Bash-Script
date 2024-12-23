#!/bin/bash
## This script is to install whatsapp manager

# Run script as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root!" 1>&2
    exit 1
fi

# Check if lsb_release is installed
if ! command -v lsb_release &> /dev/null; then
    echo "lsb_release not found. Installing..."
    if command -v apt &> /dev/null; then
        apt update && apt install -y lsb-release
    elif command -v dnf &> /dev/null; then
        dnf install -y redhat-lsb-core
    elif command -v yum &> /dev/null; then
        yum install -y redhat-lsb-core
    elif command -v pacman &> /dev/null; then
        pacman -Sy --noconfirm lsb-release
    else
        echo "Could not install lsb_release. Please install it manually."
        exit 1
    fi
fi

echo "Starting WhatsApp installation..."

# Detect distro
distro=$(lsb_release -si)

case "$distro" in
    "Ubuntu"|"Debian")
        echo "Detected distro: $distro"
        echo "Updating package list and installing dependencies..."
        apt update && apt install -y wget curl gdebi || {
            echo "Failed to install dependencies"
            exit 1
        }

        # Download WhatsApp Electron
        wget https://github.com/mortom99/whatsapp-web-electron/releases/download/1.1.0/whatsapp-web-1.1.0-amd64.deb -O /tmp/whatsapp-web.deb || {
            echo "Failed to download WhatsApp"
            exit 1
        }

        # Install WhatsApp
        gdebi -n /tmp/whatsapp-web.deb || {
            echo "Failed to install WhatsApp"
            exit 1
        }
        ;;
    "Arch"|"Manjaro")
        echo "Detected distro: $distro"
        echo "Installing WhatsApp from AUR..."
        pacman -Syu --noconfirm yay || {
            echo "Failed to install yay"
            exit 1
        }
        yay -S --noconfirm whatsapp-electron || {
            echo "Failed to install WhatsApp"
            exit 1
        }
        ;;
    "Fedora")
        echo "Detected distro: $distro"
        echo "Installing WhatsApp using the repository..."

        # Install dependencies and Electron package
        dnf install -y wget curl rpm || {
            echo "Failed to install dependencies"
            exit 1
        }
        wget https://github.com/mortom99/whatsapp-web-electron/releases/download/1.1.0/whatsapp-web-1.1.0-x86_64.rpm -O /tmp/whatsapp-web.rpm || {
            echo "Failed to download WhatsApp"
            exit 1
        }

        # Install WhatsApp
        rpm -i /tmp/whatsapp-web.rpm || {
            echo "Failed to install WhatsApp"
            exit 1
        }
        ;;
    "CentOS")
        echo "Detected distro: $distro"
        echo "Installing WhatsApp using the repository..."

        # Install dependencies
        yum install -y wget curl rpm || {
            echo "Failed to install dependencies"
            exit 1
        }

        # Download WhatsApp Electron
        wget https://github.com/mortom99/whatsapp-web-electron/releases/download/1.1.0/whatsapp-web-1.1.0-x86_64.rpm -O /tmp/whatsapp-web.rpm || {
            echo "Failed to download WhatsApp"
            exit 1
        }

        # Install WhatsApp
        rpm -i /tmp/whatsapp-web.rpm || {
            echo "Failed to install WhatsApp"
            exit 1
        }
        ;;
    *)
        echo "Distro not recognized, please install manually."
        exit 1
        ;;
esac

# Cleanup temp files
rm -f /tmp/whatsapp-web.deb /tmp/whatsapp-web.rpm 2>/dev/null

echo "WhatsApp installation completed successfully!"
