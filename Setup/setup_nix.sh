#!/bin/bash

# Function to install Nix
install_nix() {
    echo "Installing Nix Package Manager..."

    # Run the Nix install script
    sh <(curl -L https://nixos.org/nix/install)
    
    # Source the Nix profile script to ensure it works
    . /home/$USER/.nix-profile/etc/profile.d/nix.sh

    echo "Nix Package Manager successfully installed!"
}

# Detect the distro
distro=$(lsb_release -si)

case "$distro" in
    "Ubuntu"|"Debian")
        echo "Detected distro: $distro"
        echo "Ensuring dependencies are installed..."
        sudo apt update && sudo apt install -y curl xz-utils
        install_nix
        ;;
    "Arch"|"Manjaro")
        echo "Detected distro: $distro"
        echo "Ensuring dependencies are installed..."
        sudo pacman -Syu --noconfirm curl xz
        install_nix
        ;;
    "Fedora")
        echo "Detected distro: $distro"
        echo "Ensuring dependencies are installed..."
        sudo dnf install -y curl xz
        install_nix
        ;;
    "CentOS")
        echo "Detected distro: $distro"
        echo "Ensuring dependencies are installed..."
        sudo yum install -y curl xz
        install_nix
        ;;
    *)
        echo "Distro not recognized, please install manually or use a different package manager."
        exit 1
        ;;
esac
