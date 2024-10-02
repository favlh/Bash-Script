#!/bin/bash
## Update Ke Repository > For Debian Based Linux
sudo apt update 

## Upgrade Package 
sudo apt upgrade -y

## Jika untuk full-upgrade package yang ada di linux anda
#sudo apt full-upgrade -y

## Membersihkan Cache
sudo apt clean