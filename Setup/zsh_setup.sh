# === ZSH & Powerlevel10k Installation Script ===

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${PURPLE}           ✨ ZSH & Powerlevel10k Installer ✨           ${BLUE}║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"

# Detect Linux distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    echo -e "${RED}⚠️  Cannot detect Linux distribution${NC}"
    exit 1
fi

# Ask for installation confirmation
echo -e "\n${YELLOW}🔹 Do you want to install ZSH & Powerlevel10k? [y/N]${NC}"
read install_confirm
if [ "$install_confirm" != "y" ] && [ "$install_confirm" != "Y" ]; then
    echo -e "${RED}❌ Installation cancelled.${NC}"
    exit 0
fi

# Backup existing configurations
if [ -f "$HOME/.zshrc" ] || [ -d "$HOME/.oh-my-zsh" ]; then
    echo -e "\n${YELLOW}🔹 Existing ZSH configurations found. Do you want to backup? [y/N]${NC}"
    read backup_confirm
    if [ "$backup_confirm" = "y" ] || [ "$backup_confirm" = "Y" ]; then
        backup_dir="$HOME/zsh_backup_$(date +%Y%m%d_%H%M%S)"
        mkdir -p "$backup_dir"
        [ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$backup_dir/"
        [ -d "$HOME/.oh-my-zsh" ] && cp -r "$HOME/.oh-my-zsh" "$backup_dir/"
        echo -e "${GREEN}✅ Backup created at: $backup_dir${NC}"
    fi
fi

# Install dependencies based on distribution
echo -e "\n${CYAN}🔄 Installing dependencies for $DISTRO...${NC}"
case $DISTRO in
    "ubuntu"|"debian"|"linuxmint")
        sudo apt update
        sudo apt install -y zsh git curl wget
        ;;
    "fedora"|"rhel"|"centos")
        sudo dnf update -y
        sudo dnf install -y zsh git curl wget
        ;;
    "opensuse"|"suse")
        sudo zypper refresh
        sudo zypper install -y zsh git curl wget
        ;;
    "arch"|"manjaro")
        sudo pacman -Syu --noconfirm
        sudo pacman -S --noconfirm zsh git curl wget
        ;;
    *)
        echo -e "${RED}⚠️  Unsupported distribution: $DISTRO${NC}"
        exit 1
        ;;
esac

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "\n${CYAN}🔄 Installing Oh My Zsh...${NC}"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install Powerlevel10k theme
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo -e "\n${CYAN}🔄 Installing Powerlevel10k theme...${NC}"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# Install important plugins
echo -e "\n${CYAN}🔄 Installing essential plugins...${NC}"
PLUGINS_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

# zsh-autosuggestions
if [ ! -d "$PLUGINS_DIR/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $PLUGINS_DIR/zsh-autosuggestions
fi

# zsh-syntax-highlighting
if [ ! -d "$PLUGINS_DIR/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $PLUGINS_DIR/zsh-syntax-highlighting
fi

# zsh-completions
if [ ! -d "$PLUGINS_DIR/zsh-completions" ]; then
    git clone https://github.com/zsh-users/zsh-completions.git $PLUGINS_DIR/zsh-completions
fi

# Configure .zshrc
echo -e "\n${CYAN}🔄 Configuring Zsh...${NC}"
cat > ~/.zshrc << 'EOL'
# Enable Powerlevel10k theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Configure plugins
plugins=(
    git
    docker
    docker-compose
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
    npm
    node
    pip
    python
    sudo
)

source $ZSH/oh-my-zsh.sh
EOL

# Change default shell to Zsh
if [ "$SHELL" != "$(which zsh)" ]; then
    echo -e "\n${CYAN}🔄 Changing default shell to Zsh...${NC}"
    chsh -s $(which zsh)
fi

# Clean up system based on distribution
echo -e "\n${CYAN}🧹 Cleaning up system...${NC}"
case $DISTRO in
    "ubuntu"|"debian"|"linuxmint")
        sudo apt autoremove -y
        sudo apt clean
        sudo apt autoclean
        sudo rm -rf /var/lib/apt/lists/*
        ;;
    "fedora"|"rhel"|"centos")
        sudo dnf clean all
        ;;
    "opensuse"|"suse")
        sudo zypper clean -a
        ;;
    "arch"|"manjaro")
        sudo pacman -Scc --noconfirm
        ;;
esac

echo -e "\n${GREEN}✨ Installation complete! ✨${NC}"
echo -e "${YELLOW}🚀 Please restart your terminal and run 'p10k configure' to set up Powerlevel10k.${NC}"
