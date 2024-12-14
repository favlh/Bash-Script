#!/bin/bash

# Run script as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root!" 1>&2
    exit 1
fi

echo "Starting Telegram installation..."

# Detect distro
distro=$(lsb_release -si)

case "$distro" in
    "Ubuntu"|"Debian")
        echo "Detected distro: $distro"
        echo "Updating package list and installing dependencies..."
        apt update && apt install -y wget curl

        # Add Telegram repository (for Ubuntu/Debian)
        wget -qO - https://dl.telegram.org/linux/telegram_pubkey.asc | gpg --dearmor > /usr/share/keyrings/telegram-archive-keyring.gpg
        echo "deb [signed-by=/usr/share/keyrings/telegram-archive-keyring.gpg] https://dl.telegram.org/linux/ stable main" | tee /etc/apt/sources.list.d/telegram.list

        # Install Telegram
        apt update && apt install -y telegram-desktop
        ;;
    "Arch"|"Manjaro")
        echo "Detected distro: $distro"
        echo "Installing Telegram from the official repository..."
        pacman -Syu --noconfirm telegram-desktop
        ;;
    "Fedora")
        echo "Detected distro: $distro"
        echo "Installing Telegram using the repository..."

        # Add Telegram repository for Fedora
        dnf install -y dnf-plugins-core
        dnf config-manager --add-repo https://dl.telegram.org/linux/telegram.repo

        # Install Telegram
        dnf install -y telegram-desktop
        ;;
    "CentOS")
        echo "Detected distro: $distro"
        echo "Installing Telegram using the Telegram repository..."

        # Add Telegram repository for CentOS
        yum install -y wget
        curl https://dl.telegram.org/linux/telegram.repo | tee /etc/yum.repos.d/telegram.repo

        # Install Telegram
        yum install -y telegram-desktop
        ;;
    *)
        echo "Distro not recognized, please install manually."
        exit 1
        ;;
esac

echo "Telegram installation completed successfully!"
