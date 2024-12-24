#!/bin/bash

# Run script as root
if [ "$(id -u)" -ne 0 ]; then
    echo -e "\033[1;31mPlease run this script as root!\033[0m" 1>&2
    exit 1
fi

echo -e "\033[1;36m
████████╗███████╗██╗     ███████╗ ██████╗ ██████╗  █████╗ ███╗   ███╗
╚══██╔══╝██╔════╝██║     ██╔════╝██╔════╝ ██╔══██╗██╔══██╗████╗ ████║
   ██║   █████╗  ██║     █████╗  ██║  ███╗██████╔╝███████║██╔████╔██║
   ██║   ██╔══╝  ██║     ██╔══╝  ██║   ██║██╔══██╗██╔══██║██║╚██╔╝██║
   ██║   ███████╗███████╗███████╗╚██████╔╝██║  ██║██║  ██║██║ ╚═╝ ██║
   ╚═╝   ╚══════╝╚══════╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝
                    🚀 INSTALLER SCRIPT 🚀
\033[0m"

echo -e "\033[1;32m=== Telegram Installation Menu ===\033[0m"

# Detect distro
distro=$(lsb_release -si)

# Ask user if they want to install
echo -e "\033[1;33mDo you want to install Telegram? (y/n)\033[0m"
read -r choice

if [[ ! "$choice" =~ ^[Yy]$ ]]; then
    echo -e "\033[1;31mInstallation cancelled.\033[0m"
    exit 0
fi

echo -e "\033[1;32m=== Starting Telegram Installation ===\033[0m"

case "$distro" in
    "Ubuntu"|"Debian"|"Linux Mint"|"Pop!_OS"|"Elementary OS")
        echo -e "\033[1;34mDetected Debian-based distro: $distro\033[0m"
        echo "Updating package list and installing dependencies..."
        apt-get update && apt-get install -y wget curl gpg

        # Add Telegram repository
        wget -qO - https://dl.telegram.org/linux/telegram_pubkey.asc | gpg --dearmor > /usr/share/keyrings/telegram-archive-keyring.gpg
        echo "deb [signed-by=/usr/share/keyrings/telegram-archive-keyring.gpg] https://dl.telegram.org/linux/ stable main" | tee /etc/apt/sources.list.d/telegram.list

        # Install Telegram
        apt-get update && apt-get install -y telegram-desktop

        # Clean up packages
        apt-get clean
        apt-get autoremove -y
        ;;
    "Arch"|"Manjaro"|"EndeavourOS"|"Garuda"|"ArcoLinux")
        echo -e "\033[1;34mDetected Arch-based distro: $distro\033[0m"
        echo "Installing Telegram from the official repository..."
        pacman -Syu --noconfirm telegram-desktop

        # Clean up packages
        pacman -Sc --noconfirm
        ;;
    "Fedora"|"Red Hat"|"CentOS Stream")
        echo -e "\033[1;34mDetected Red Hat-based distro: $distro\033[0m"
        echo "Installing Telegram using the repository..."

        # Add Telegram repository
        dnf install -y dnf-plugins-core
        dnf config-manager --add-repo https://dl.telegram.org/linux/telegram.repo

        # Install Telegram
        dnf install -y telegram-desktop

        # Clean up packages
        dnf clean all
        ;;
    "CentOS"|"RHEL"|"Oracle Linux")
        echo -e "\033[1;34mDetected Enterprise Linux distro: $distro\033[0m"
        echo "Installing Telegram using the Telegram repository..."

        # Add Telegram repository
        yum install -y wget curl
        curl https://dl.telegram.org/linux/telegram.repo | tee /etc/yum.repos.d/telegram.repo

        # Install Telegram
        yum install -y telegram-desktop

        # Clean up packages
        yum clean all
        ;;
    "openSUSE"|"SUSE")
        echo -e "\033[1;34mDetected SUSE-based distro: $distro\033[0m"
        echo "Installing Telegram using zypper..."

        # Add Telegram repository
        zypper addrepo https://dl.telegram.org/linux/telegram.repo
        zypper --gpg-auto-import-keys refresh

        # Install Telegram
        zypper install -y telegram-desktop

        # Clean up packages
        zypper clean
        ;;
    *)
        echo -e "\033[1;31mDistro not recognized, please install manually.\033[0m"
        exit 1
        ;;
esac

echo -e "\033[1;32m=== Telegram installation completed successfully! ===\033[0m"
