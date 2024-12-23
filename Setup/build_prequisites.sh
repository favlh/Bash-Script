#!/bin/bash

# Check if is running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

clear
echo "===================================="
echo "     Build Prerequisites Script      "
echo "===================================="
echo

# Detect Distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
fi

echo "Detected OS: $OS"
echo "Version: $VER"
echo

case "$OS" in
    # Debian/Ubuntu
    *"Debian"*|*"Ubuntu"*)
        echo "Installing build prerequisites for Debian/Ubuntu..."
        apt update
        apt install -y build-essential git cmake pkg-config \
                      autoconf automake libtool curl wget \
                      unzip zip software-properties-common \
                      python3 python3-pip python3-dev \
                      libssl-dev libffi-dev libxml2-dev \
                      libxslt1-dev zlib1g-dev libsqlite3-dev \
                      default-jdk nodejs npm \
                      docker.io docker-compose \
                      vim nano emacs \
                      htop net-tools
    ;;

    # RHEL/CentOS/Fedora
    *"Red Hat"*|*"CentOS"*|*"Fedora"*)
        echo "Installing build prerequisites for RHEL/CentOS/Fedora..."
        dnf groupinstall -y "Development Tools"
        dnf install -y git cmake pkg-config \
                      autoconf automake libtool curl wget \
                      unzip zip python3 python3-pip python3-devel \
                      openssl-devel libffi-devel libxml2-devel \
                      libxslt-devel zlib-devel sqlite-devel \
                      java-latest-openjdk nodejs \
                      docker docker-compose \
                      vim nano emacs \
                      htop net-tools
    ;;

    # openSUSE
    *"SUSE"*)
        echo "Installing build prerequisites for openSUSE..."
        zypper install -y -t pattern devel_basis
        zypper install -y git cmake pkg-config \
                         autoconf automake libtool curl wget \
                         unzip zip python3 python3-pip python3-devel \
                         libopenssl-devel libffi-devel libxml2-devel \
                         libxslt-devel zlib-devel sqlite3-devel \
                         java-17-openjdk nodejs npm \
                         docker docker-compose \
                         vim nano emacs \
                         htop net-tools
    ;;

    # Arch Linux
    *"Arch"*)
        echo "Installing build prerequisites for Arch Linux..."
        pacman -Sy --noconfirm base-devel git cmake pkg-config \
                               autoconf automake libtool curl wget \
                               unzip zip python python-pip \
                               openssl libffi libxml2 libxslt zlib sqlite \
                               jdk-openjdk nodejs npm \
                               docker docker-compose \
                               vim nano emacs \
                               htop net-tools
    ;;

    # Gentoo
    *"Gentoo"*)
        echo "Installing build prerequisites for Gentoo..."
        emerge --sync
        emerge -av dev-vcs/git dev-util/cmake dev-util/pkgconfig \
                   sys-devel/autoconf sys-devel/automake sys-devel/libtool \
                   net-misc/curl net-misc/wget \
                   app-arch/unzip app-arch/zip dev-lang/python \
                   dev-python/pip dev-libs/openssl dev-libs/libffi \
                   dev-libs/libxml2 dev-libs/libxslt sys-libs/zlib \
                   dev-db/sqlite virtual/jdk net-libs/nodejs \
                   app-containers/docker app-containers/docker-compose \
                   app-editors/vim app-editors/nano app-editors/emacs \
                   sys-process/htop sys-apps/net-tools
    ;;

    *)
        echo "Unsupported distribution: $OS"
        exit 1
    ;;
esac

echo
echo "Build prerequisites installation completed!"
echo "===================================="
