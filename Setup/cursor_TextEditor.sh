#!/bin/bash

# Run script as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root!" 1>&2
    exit 1
fi

echo "Starting Cursor AI Text Editor installation..."

# Detect distro
distro=$(lsb_release -si)

case "$distro" in
    "Ubuntu"|"Debian")
        echo "Detected distro: $distro"
        echo "Updating package list..."
        apt update

        # Install dependencies
        apt install -y curl

        # Download Cursor AI Text Editor
        echo "Downloading Cursor AI Text Editor..."
        curl -fsSL https://download.cursor.so/install.sh | bash
        ;;
    "Arch"|"Manjaro")
        echo "Detected distro: $distro"
        echo "Installing dependencies..."
        pacman -Syu --noconfirm curl

        # Download Cursor AI Text Editor
        echo "Downloading Cursor AI Text Editor..."
        curl -fsSL https://download.cursor.so/install.sh | bash
        ;;
    "Fedora")
        echo "Detected distro: $distro"
        echo "Installing dependencies..."
        dnf install -y curl

        # Download Cursor AI Text Editor
        echo "Downloading Cursor AI Text Editor..."
        curl -fsSL https://download.cursor.so/install.sh | bash
        ;;
    "CentOS")
        echo "Detected distro: $distro"
        echo "Installing dependencies..."
        yum install -y curl

        # Download Cursor AI Text Editor
        echo "Downloading Cursor AI Text Editor..."
        curl -fsSL https://download.cursor.so/install.sh | bash
        ;;
    *)
        echo "Distro not recognized, please install manually."
        exit 1
        ;;
esac

echo "Cursor AI Text Editor installed successfully!"

# Provide user with the option to launch Cursor
echo "Would you like to launch Cursor now?"
read -p "Enter 'yes' to launch Cursor or 'no' to exit: " launch_choice

if [ "$launch_choice" == "yes" ]; then
    cursor
else
    echo "Installation complete. You can launch Cursor by typing 'cursor' in the terminal."
fi
