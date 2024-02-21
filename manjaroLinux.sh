#!/bin/bash

RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m'

downloadFile() {
  sudo wget -Nq $1 -O $2
  if [ $? -ne 0 ]
  then
    echo -e "${RED}FAILURE${NC} Failed to download $2"
  fi
}

setGitConfigFromEnvironmentVariable() {
  VARIABLE_NAME=$2
  VARIABLE_VALUE="${!VARIABLE_NAME}"
  if [[ -z $VARIABLE_VALUE ]]
  then
    echo -e "${RED}FAILURE${NC} Environment variable $VARIABLE_NAME not set"
  else
    git config --global $1 "$VARIABLE_VALUE"
  fi
}

setupGit() {
  downloadFile \
    https://raw.githubusercontent.com/jttait/laptop/main/gitconfig \
     ~/.gitconfig
  makeDirectory ~/.githooks
  downloadFile \
    https://raw.githubusercontent.com/jttait/laptop/main/githooks/pre-commit \
    ~/.githooks/pre-commit
  chmod +x ~/.githooks/pre-commit
  setGitConfigFromEnvironmentVariable user.email GITHUB_USER_EMAIL
  setGitConfigFromEnvironmentVariable user.name GITHUB_USER_NAME
}

downloadBashrc() {
  downloadFile \
    https://raw.githubusercontent.com/jttait/laptop/main/bashrc \
    ~/.bashrc
}

installDockerPlugin() {
  makeDirectory /usr/lib/docker/cli-plugins
  downloadFile $2 /usr/lib/docker/cli-plugins/$1
  sudo chmod +x /usr/lib/docker/cli-plugins/$1
}

installAwsCli() {
  downloadFile \
    https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip \
    ~/Downloads/awscliv2.zip
  unzip -qq ~/Downloads/awscliv2.zip -d ~/Downloads/
  sudo ~/Downloads/aws/install --update
  rm -f ~/Downloads/awscliv2.zip
  rm -r ~/Downloads/aws
}

installSdkMan() {
  source ~/.sdkman/bin/sdkman-init.sh
  if ! command -v sdk &> /dev/null
  then
    curl -s "https://get.sdkman.io?rcupdate=false" | bash
    if command -v sdk &> /dev/null
    then
      echo -e "[${GREEN}SUCCESS${NC}] Successfully installed sdk"
    else
      echo -e "[${RED}FAILURE${NC}] Failed to install sdk"
    fi
  fi
  source ~/.sdkman/bin/sdkman-init.sh
  sdk update
}

installPamacPackage() {
  alreadyInstalled=$(pamac list | grep -w $1)
  if [[ -z "$alreadyInstalled" ]]
  then
    sudo pamac install $1 --no-confirm
  fi
}

removePamacPackage() {
  alreadyInstalled=$(pamac list | grep $1)
  if [[ -n "$alreadyInstalled" ]]
  then
    sudo pamac remove $1 --no-confirm
  fi
}

removeDirectory() {
  if [ -d "$1" ]
  then
    sudo rm -r $1
  fi
}

makeDirectory() {
  if [ ! -d "$1" ]
  then
    sudo mkdir -p $1
  fi
}

installJetBrainsMonoFont() {
  downloadFile \
    https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip \
    ~/Downloads/JetBrainsMono.zip
  makeDirectory /usr/share/fonts/jetbrains
  sudo unzip -u ~/Downloads/JetBrainsMono.zip -d /usr/share/fonts/jetbrains/
  sudo rm ~/Downloads/JetBrainsMono.zip
}

installRobotoFont() {
  downloadFile \
    https://www.fontsquirrel.com/fonts/download/roboto \
    ~/Downloads/Roboto.zip
  makeDirectory /usr/share/fonts/roboto
  sudo unzip -u ~/Downloads/Roboto.zip -d /usr/share/fonts/roboto/
  sudo rm ~/Downloads/Roboto.zip
}

echo ""

installJetBrainsMonoFont
installRobotoFont

removeDirectory ~/Music
removeDirectory ~/Pictures
removeDirectory ~/Public
removeDirectory ~/Templates
removeDirectory ~/Videos
removeDirectory ~/Documents

sudo pamac update
sudo pamac upgrade

removePamacPackage pidgin
removePamacPackage thunderbird
removePamacPackage hexchat
removePamacPackage onlyoffice-desktopeditors

installPamacPackage borg
installPamacPackage restic
installPamacPackage libreoffice-still
installPamacPackage python-pip
installPamacPackage fzf
installPamacPackage transmission-gtk
installPamacPackage docker
installPamacPackage go
installPamacPackage minikube
installPamacPackage kubectl
installPamacPackage helm
installPamacPackage texlive-basic
installPamacPackage texlive-latex
installPamacPackage texlive-xetex
installPamacPackage texlive-latexrecommended
installPamacPackage texlive-latexextra
installPamacPackage texlive-fontsrecommended
installPamacPackage intellij-idea-community-edition
installPamacPackage k9s
installPamacPackage tfenv
installPamacPackage google-chrome
installPamacPackage make
installPamacPackage audacious
installPamacPackage audacious-plugins
installPamacPackage tmux
installPamacPackage jq

installPamacPackage git
setupGit

installPamacPackage neovim

downloadBashrc

installDockerPlugin docker-compose \
  https://github.com/docker/compose/releases/download/v2.23.0/docker-compose-linux-x86_64
installDockerPlugin docker-buildx \
  https://github.com/docker/buildx/releases/download/v0.11.2/buildx-v0.11.2.linux-amd64
sudo usermod -aG docker $USER

installAwsCli

installSdkMan
sdk install java 19.0.2-tem
sdk install java 17.0.6-tem
sdk install gradle
sdk install micronaut

go install -v golang.org/x/tools/cmd/godoc@latest

echo ""
