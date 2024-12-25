#!/bin/bash
# Auto System Update Script
# Author: System Administrator
# Version: 1.0

# Banner function
print_banner() {
    clear
    echo -e "\e[1;36m"
    echo "┌─────────────────────────────────────────┐"
    echo "│     🚀 AUTOMATIC SYSTEM UPDATER 🚀      │"
    echo "│        Keep Your System Updated         │"
    echo "└─────────────────────────────────────────┘"
    echo -e "\e[0m"
}

update_system() {
    echo -e "\e[1;33m🔍 Detecting Linux distribution...\e[0m"
    if [ -f /etc/debian_version ]; then
        echo -e "\e[1;32m✅ Detected Debian/Ubuntu based Linux.\e[0m"
        echo -e "\e[1;34m📦 Updating packages...\e[0m"
        sudo apt-get update && sudo apt-get upgrade -y
        sudo apt-get clean
    elif [ -f /etc/redhat-release ]; then
        echo -e "\e[1;32m✅ Detected Red Hat-based Linux.\e[0m"
        echo -e "\e[1;34m📦 Updating packages...\e[0m"
        sudo dnf upgrade --refresh -y
        sudo dnf clean all
    elif [ -f /etc/arch-release ]; then
        echo -e "\e[1;32m✅ Detected Arch-based Linux.\e[0m"
        echo -e "\e[1;34m📦 Updating packages...\e[0m"
        sudo pacman -Syu --noconfirm
        sudo pacman -Sc --noconfirm
    elif [ -f /etc/SuSE-release ]; then
        echo -e "\e[1;32m✅ Detected openSUSE-based Linux.\e[0m"
        echo -e "\e[1;34m📦 Updating packages...\e[0m"
        sudo zypper refresh
        sudo zypper update -y
    elif [ -f /etc/gentoo-release ]; then
        echo -e "\e[1;32m✅ Detected Gentoo Linux.\e[0m"
        echo -e "\e[1;34m📦 Updating packages...\e[0m"
        sudo emerge --sync
        sudo emerge -uDNav @world
    else
        echo -e "\e[1;31m❌ Unsupported distribution. Please update manually.\e[0m"
        exit 1
    fi
}

print_banner
echo -e "\e[1;35m🎬 Starting system update and upgrade process...\e[0m"
update_system
echo -e "\e[1;32m✨ System update and upgrade completed successfully!\e[0m"
