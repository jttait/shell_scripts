#!/bin/bash

source linux.sh
source secrets.sh

rm --recursive --force ~/Music
rm --recursive --force ~/Videos
rm --recursive --force ~/Pictures
rm --recursive --force ~/Public
rm --recursive --force ~/Templates
rm --recursive --force ~/Documents

sudo apt update
sudo apt upgrade

sudo apt remove celluloid --yes
sudo apt remove thunderbird --yes
sudo apt remove hypnotix --yes

sudo apt install git
sudo apt install vim
sudo apt install borgbackup
sudo apt install restic
sudo apt install vlc
sudo apt install arduino
sudo apt install imagemagick
sudo apt install jq

sudo apt autoremove --yes

# Install Go programming language
wget -O $HOME/Downloads/golang.tar.gz https://go.dev/dl/go1.25.6.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf $HOME/Downloads/golang.tar.gz
sudo rm $HOME/Downloads/golang.tar.gz

# Install Java programming language
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java 25.0.2-tem
sdk install gradle 9.3.1

# Git
exitIfEnvironmentVariableIsNotSet GITHUB_USER_EMAIL
exitIfEnvironmentVariableIsNotSet GITHUB_USER_NAME
wget --timestamping --quiet \
	https://raw.githubusercontent.com/jttait/shell_scripts/main/gitconfig \
	--output-document ~/.gitconfig
mkdir --parents ~/.githooks
wget --timestamping --quiet \
	https://raw.githubusercontent.com/jttait/shell_scripts/main/githooks/pre-commit/ \
	--output-document ~/.githooks/pre-commit
chmod +x ~/.githooks/pre-commit
git config --global user.email "$GITHUB_USER_EMAIL"
git config --global user.name "$GITHUB_USER_NAME"

# Bashrc
wget --timestamping --quiet \
	https://raw.githubusercontent.com/jttait/shell_scripts/main/bashrc \
	--output-document ~/.bashrc

# Electrum
mkdir --parents ~/appimage
ELECTRUM_VERSION="4.7.0"
wget --timestamping --quiet \
	https://download.electrum.org/$ELECTRUM_VERSION/electrum-$ELECTRUM_VERSION-x86_64.AppImage \
	--output-document ~/appimage/electrum.AppImage
chmod +x ~/appimage/electrum.AppImage

# Docker
sudo apt-get update
sudo apt-get install ca-certificates curl --yes
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$UBUNTU_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin --yes
sudo usermod -aG docker $USER

# Google Antigravity
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg | \
  sudo gpg --dearmor --yes -o /etc/apt/keyrings/antigravity-repo-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" | \
  sudo tee /etc/apt/sources.list.d/antigravity.list > /dev/null
sudo apt update
sudo apt install antigravity

# Godot Engine
mkdir --parents ~/Applications/Godot
GODOT_VERSION="4.6"
GODOT_URL="https://downloads.godotengine.org/?version=$GODOT_VERSION&flavor=stable&slug=linux.x86_64.zip&platform=linux.64"
wget --timestamping --quiet "$GODOT_URL" --output-document ~/Applications/Godot/godot.zip
unzip -o ~/Applications/Godot/godot.zip -d ~/Applications/Godot/
chmod +x ~/Applications/Godot/Godot_v$GODOT_VERSION-stable_linux.x86_64
rm ~/Applications/Godot/godot.zip
wget --timestamping --quiet https://godotengine.org/assets/press/icon_color.png --output-document ~/Applications/Godot/godot.png

cat <<EOF > ~/.local/share/applications/godot.desktop
[Desktop Entry]
Name=Godot Engine
GenericName=Libre game engine
Comment=Multi-platform 2D and 3D game engine with a unified interface
Exec=/home/$USER/Applications/Godot/Godot_v$GODOT_VERSION-stable_linux.x86_64
Icon=/home/$USER/Applications/Godot/godot.png
Terminal=false
Type=Application
Categories=Development;IDE;
Keywords=godot;game;engine;development;
StartupWMClass=Godot
EOF
