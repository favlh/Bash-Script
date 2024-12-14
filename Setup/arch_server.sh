#!/bin/bash

# Running the script as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root!" 1>&2
    exit 1
fi

echo "Starting Arch Linux server setup..."

# Step 1: Update the system
echo "Updating the system..."
pacman -Syu --noconfirm

# Step 2: Install essential packages for the server
echo "Installing essential packages..."
pacman -S --noconfirm \
    base base-devel \
    openssh \
    sudo \
    curl \
    git \
    vim \
    ufw \
    net-tools \
    ntp \
    htop

# Step 3: Set up NTP (Network Time Protocol) for time synchronization
echo "Setting up NTP for time synchronization..."
systemctl enable --now systemd-timesyncd

# Step 4: Configure the firewall using UFW
echo "Configuring UFW firewall..."
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw enable

# Step 5: Configure SSH for remote access
echo "Configuring SSH..."
systemctl enable --now sshd

# Step 6: Add a new user and give them sudo privileges
echo "Adding a new user..."
read -p "Enter the username you want to create: " username
useradd -m -G wheel -s /bin/bash "$username"
passwd "$username"

# Add the new user to the sudo group
echo "Adding $username to the sudo group..."
echo "$username ALL=(ALL) ALL" >> /etc/sudoers.d/$username

# Step 7: Disable root login via SSH (optional for more security)
echo "Disabling root login via SSH..."
sed -i 's/^PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl restart sshd

# Step 8: Ensure necessary services are running
echo "Ensuring services are running..."
systemctl enable --now sshd
systemctl enable --now ufw

# Step 9: Check system status
echo "Checking system status..."
ufw status
systemctl status sshd

echo "Server setup is complete. Your Arch Linux server is ready to use!"
