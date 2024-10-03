#!/bin/bash

# Colors 
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting Hyperland installation with all the goodies...${NC}"

# Update and install dependencies 
sudo apt update && sudo apt upgrade -y
sudo apt install -y git build-essential meson ninja-build cmake libwayland-dev libwlroots-dev \
    libxcb1-dev libx11-dev libxkbcommon-dev libdrm-dev libgbm-dev libevdev-dev libpixman-1-dev \
    xorg-dev xcb-proto xutils-dev libinput-dev wayland-protocols libgles2-mesa-dev libegl1-mesa-dev \
    libpulse-dev libudev-dev libxcb-xinput-dev libxcb-damage0-dev libxfixes-dev libxrandr-dev \
    libxcomposite-dev libxinerama-dev libxcursor-dev libxi-dev libxkbfile-dev libpam0g-dev unzip \
    wget curl swaybg waybar dunst rofi alacritty pavucontrol pipewire pipewire-pulse blueman picom \
    fcitx5 fcitx5-mozc fonts-noto-cjk arc-theme papirus-icon-theme

# Clone Hyperland from GitHub 
echo -e "${GREEN}Downloading Hyperland, hang tight...${NC}"
git clone https://github.com/hyperland/hyperland
cd hyperland
meson build
ninja -C build
sudo ninja -C build install

# Installing Japanese Fonts 
echo -e "${GREEN}Installing cool Japanese fonts...${NC}"
sudo apt install -y fonts-noto-cjk

# For wallpaper (you can change it)
WALLPAPER_URL="https://images.unsplash.com/photo-1535385793349-51f9387a14a7?auto=compress&cs=tinysrgb&w=1920&h=1080"
WALLPAPER_PATH="$HOME/Pictures/japan_wallpaper.jpg"
mkdir -p $HOME/Pictures
wget -O $WALLPAPER_PATH $WALLPAPER_URL

# Set up Hyperland config
echo -e "${GREEN}Setting up Hyperland configuration...${NC}"
mkdir -p $HOME/.config/hyperland
cat <<EOT > $HOME/.config/hyperland/config
# Simple Hyperland config that looks cool

# Set the wallpaper we just downloaded
exec_always swaybg -i $WALLPAPER_PATH -m fill

# Waybar for the top status bar
exec_always waybar

# Rofi for a slick app launcher
bindsym $mod+d exec rofi -show drun

# Dunst for notifications so you don't miss anything
exec_always dunst

# Alacritty as the terminal emulator because it's fast and simple
bindsym $mod+Return exec alacritty

# Audio control with pavucontrol
bindsym $mod+Shift+a exec pavucontrol

# Custom keybindings to make life easier
bindsym $mod+Shift+q kill # Close apps
bindsym $mod+Shift+e exec poweroff # Shutdown

# Follow the mouse for window focus (it's cool, trust me)
focus_follows_mouse yes

# Start picom for transparency and shadows to make it look slick
exec_always picom

# Input method for typing in Japanese
exec_always fcitx5
EOT

# Set the theme and icons for dekstop
gsettings set org.gnome.desktop.interface gtk-theme "Arc-Dark"
gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"

# Auto-enable network manager and Bluetooth
echo -e "${GREEN}Setting up network and Bluetooth management...${NC}"
sudo systemctl enable NetworkManager
sudo systemctl enable bluetooth

# Done
echo -e "${GREEN}Hyperland is ready to go! Restart to apply all the changes.${NC}"