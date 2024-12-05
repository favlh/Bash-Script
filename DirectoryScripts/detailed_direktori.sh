#!/bin/bash

# Menampilkan direktori saat ini
get_current_directory() {
    pwd
}

# Me-list semua file dan folder dalam direktori saat ini
list_files_and_folders() {
    ls -la
}

# Menampilkan Informasi Direktori dan Isi
echo "=== Informasi Direktori ==="
echo "Direktori saat ini: $(get_current_directory)"
echo "Daftar file dan folder:"
list_files_and_folders

# Periksa ketersediaan command
check_command() {
    command -v "$1" >/dev/null 2>&1 || { echo >&2 "Error: $1 command not found. Please install it."; exit 1; }
}

# Periksa command yang digunakan
check_command "pwd"
check_command "ls"

# Jalankan script hanya jika semua command tersedia
if [ $? -eq 0 ]; then
    get_current_directory
    list_files_and_folders
else
    echo "Beberapa command tidak tersedia. Silakan install command yang diperlukan."
fi
