#!/bin/bash

# Script instalasi server Debian

# Memastikan script dijalankan sebagai root
if [ "$(id -u)" != "0" ]; then
   echo "Script ini harus dijalankan sebagai root" 1>&2
   exit 1
fi

# Update dan upgrade sistem
echo "Memperbarui sistem..."
apt update && apt upgrade -y

# Instalasi paket-paket esensial
echo "Menginstal paket-paket esensial..."
apt install -y \
    sudo \
    curl \
    wget \
    vim \
    htop \
    net-tools \
    ufw \
    fail2ban \
    unattended-upgrades

# Konfigurasi firewall (UFW)
echo "Mengkonfigurasi firewall..."
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow http
ufw allow https
ufw enable

# Konfigurasi Fail2Ban
echo "Mengkonfigurasi Fail2Ban..."
systemctl enable fail2ban
systemctl start fail2ban

# Instalasi dan konfigurasi web server (contoh: Nginx)
echo "Menginstal dan mengkonfigurasi Nginx..."
apt install -y nginx
systemctl enable nginx
systemctl start nginx

# Instalasi database server (contoh: MariaDB)
echo "Menginstal MariaDB..."
apt install -y mariadb-server
systemctl enable mariadb
systemctl start mariadb

# Instalasi PHP dan ekstensi yang umum digunakan
echo "Menginstal PHP dan ekstensi..."
apt install -y php-fpm php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc

# Konfigurasi unattended-upgrades untuk pembaruan otomatis
echo "Mengkonfigurasi pembaruan otomatis..."
dpkg-reconfigure -plow unattended-upgrades

# Instalasi alat monitoring (contoh: Netdata)
echo "Menginstal Netdata untuk monitoring..."
bash <(curl -Ss https://my-netdata.io/kickstart.sh) --non-interactive

# Instalasi dan konfigurasi SSH server
echo "Mengkonfigurasi SSH server..."
apt install -y openssh-server
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl restart ssh

# Membuat pengguna non-root dengan akses sudo
echo "Membuat pengguna baru dengan akses sudo..."
read -p "Masukkan nama pengguna baru: " username
adduser $username
usermod -aG sudo $username

echo "Instalasi server selesai. Silakan reboot sistem untuk menerapkan semua perubahan."