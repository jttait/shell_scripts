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
sudo apt remove element-desktop

sudo apt install git
sudo apt install vim
sudo apt install borgbackup
sudo apt install restic
sudo apt install vlc
sudo apt install arduino
sudo apt install imagemagick

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
