#!/bin/bash
# ****************************************
# *         Author: Abdul_Rehman         *
# *   Fresh OS Install & Tweaks Script   *
# ****************************************

set -e  # Exit script on any error

echo "Updating package lists..."
sudo apt update

# Function to check if a package is installed
is_installed() {
    dpkg -l | grep -qw "$1"
}

# Function to install software via Snap and APT
install_packages() {
    echo -e "\n\033[1;34m[ Installing Essential Applications ]\033[0m"
    packages=("qbittorrent" "vlc" "libreoffice" "php" "neovim" "git" "python3" "python3-pip" "build-essential" "cmake" "g++" "curl" "obsidian --classic")

    for pkg in "${packages[@]}"; do
        if is_installed "$pkg"; then
            echo -e "\033[1;32m✔ $pkg is already installed.\033[0m"
        else
            sudo apt install -y "$pkg"
        fi
    done

    snap_packages=("code --classic" "discord --classic" "telegram-desktop" "postman")
    for snap_pkg in "${snap_packages[@]}"; do
        if snap list | grep -qw "$(echo "$snap_pkg" | awk '{print $1}')"; then
            echo -e "\033[1;32m✔ $snap_pkg is already installed.\033[0m"
        else
            sudo snap install $snap_pkg
        fi
    done
}

# Install OBS Studio with required dependencies
install_obs_studio() {
    echo -e "\n\033[1;34m[ Installing OBS Studio ]\033[0m"
    if is_installed "obs-studio"; then
        echo -e "\033[1;32m✔ OBS Studio is already installed.\033[0m"
        return
    fi
    sudo apt install -y mesa-utils ffmpeg
    glxinfo | grep "OpenGL" || echo "OpenGL not found!"
    sudo add-apt-repository -y ppa:obsproject/obs-studio
    sudo apt update
    sudo apt install -y obs-studio
}

# Install GitHub Desktop
install_github_desktop() {
    echo -e "\n\033[1;34m[ Installing GitHub Desktop ]\033[0m"
    if is_installed "github-desktop"; then
        echo -e "\033[1;32m✔ GitHub Desktop is already installed.\033[0m"
    else
        wget -qO /tmp/github-desktop.deb https://apt.packages.shiftkey.dev/gpg.key | gpg --dearmor | sudo tee /usr/share/keyrings/shiftkey-packages.gpg > /dev/null
        sudo dpkg -i /tmp/github-desktop.deb || sudo apt install -fy
        rm /tmp/github-desktop.deb
    fi
}

# Install Tweaks and Utilities
install_tweaks() {
    echo -e "\n\033[1;34m[ Installing Tweaks & System Utilities ]\033[0m"
    utilities=("gnome-tweaks" "chrome-gnome-shell" "zsh" "neofetch" "htop" "preload" "gimp")

    for util in "${utilities[@]}"; do
        if is_installed "$util"; then
            echo -e "\033[1;32m✔ $util is already installed.\033[0m"
        else
            sudo apt install -y "$util"
        fi
    done

    echo -e "\n\033[1;34m[ Installing Google Chrome ]\033[0m"
    if is_installed "google-chrome-stable"; then
        echo -e "\033[1;32m✔ Google Chrome is already installed.\033[0m"
    else
        wget -qO /tmp/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
        sudo dpkg -i /tmp/google-chrome.deb || sudo apt install -fy
        rm /tmp/google-chrome.deb
    fi

    echo -e "\n\033[1;34m[ Configuring Security & Performance Tweaks ]\033[0m"
    sudo ufw enable
    sudo ufw allow ssh
    sudo systemctl disable NetworkManager-wait-online.service
    echo 'Acquire::http {No-Cache=True;};' | sudo tee /etc/apt/apt.conf.d/99no-cache
}

# Install Zsh & Oh My Zsh
install_zsh() {
    echo -e "\n\033[1;34m[ Installing & Configuring Zsh ]\033[0m"
    if is_installed "zsh"; then
        echo -e "\033[1;32m✔ Zsh is already installed.\033[0m"
    else
        sudo apt install -y zsh
        chsh -s $(which zsh)
    fi

    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo -e "\033[1;32m✔ Oh My Zsh is already installed.\033[0m"
    else
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || echo "Oh My Zsh installation failed!"
    fi
}

# Uncomment to install Anaconda
# install_anaconda() {
#     echo -e "\n\033[1;34m[ Installing Anaconda ]\033[0m"
#     chmod +x /path/to/Anaconda.sh
#     ./path/to/Anaconda.sh
# }

# Run all functions
install_packages
install_obs_studio
install_github_desktop
install_tweaks
install_zsh

echo -e "\n\033[1;32m✔ All installations and tweaks completed successfully! 🎉\033[0m"
exit 0

