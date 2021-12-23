#!/bin/bash

RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m'

UBUNTU_DISTRO="focal"

exitIfEnvironmentVariableIsNotSet() {
   VARIABLE_NAME=$1
   VARIABLE_VALUE=${!VARIABLE_NAME}
   if [[ -z ${VARIABLE_VALUE} ]]
   then
      echo -e "${RED}FAILURE${NC} Environment variable $1 is not set!"
      exit 1
   fi
}

deleteDirectoryIfExists() {
   if [ -d $1 ]
   then
      sudo rm -r $1
      if [ -d $1 ]
      then
         echo -e "${RED}FAILED${NC} Failed to remove directory $1"
      else
         echo -e "${GREEN}SUCCESS${NC} Successfully removed directory $1"
      fi
   else
      echo -e "${GREEN}SUCCESS${NC} Directory $1 does not exist, not removing"
   fi
}

makeDirectoryIfNotExists() {
   if [ -d $1 ]
   then 
      echo -e "${GREEN}SUCCESS${NC} Directory $1 already exists"
   else
      mkdir $1
      if [ -d $1 ]
      then
         echo -e "${GREEN}SUCCESS${NC} Successfully made directory $1"
      else
         echo -e "${RED}FAILURE${NC} Failed to make directory $1"
      fi
   fi
}

installAndUpdateVimPackageFromGithub() {
   cd ~/.vim/pack/gitplugins/start/
   if [ ! -d $1 ]
   then
      git clone $2
   fi
   cd ~/.vim/pack/gitplugins/start/$1
   git pull --quiet
   echo -e "${GREEN}SUCCESS${NC} Installed/updated Vim package $1"
}

installAptPackage() {
   if dpkg --get-selections | grep -q "^$1[[:space:]]*install$" >/dev/null
   then
      echo -e "${GREEN}SUCCESS${NC} APT package $1 already installed"
   else
      sudo apt -qq install $1
      if dpkg --get-selections | grep -q "^$1[[:space:]]*install$" >/dev/null
      then
         echo -e "${GREEN}SUCCESS${NC} Successfully installed APT package $1"
      else
         echo -e "${RED}FAILED${NC} Failed to install APT package $1"
      fi
   fi
}

installSnapPackage() {
   PACKAGE_NAME=$(echo $1 | head -n1 | awk '{print $1;}')
   INSTALLED=$(snap list | grep $PACKAGE_NAME | wc -l)
   if [[ INSTALLED -eq 1 ]]
   then
      echo -e "${GREEN}SUCCESS${NC} Snap package $PACKAGE_NAME already installed"
   else
      sudo snap install $1
   fi
}

removeAptPackageIfInstalled() {
   if dpkg --get-selections | grep -q "^$1[[:space:]]*install$" >/dev/null
   then
      sudo apt remove $1
      if dpkg --get-selections | grep -q "^$1[[:space:]]*install$" >/dev/null
      then
         echo -e "${RED}FAILED${NC} failed to remove APT package $1"
      else
         echo -e "${GREEN}SUCCESS${NC} successfully removed APT package $1"
      fi
   else
      echo -e "${GREEN}SUCCESS${NC} $1 not installed, not removing"
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
      echo -e "${GREEN}SUCCESS${NC} Git config $1 set to $VARIABLE_VALUE"
   fi
}

downloadFile() {
   wget -Nq $1 -O $2
   if [ $? -eq 0 ]
   then
      echo -e "${GREEN}SUCCESS${NC} Downloaded $2"
   else
      echo -e "${RED}FAILURE${NC} Failed to download $2"
   fi
}

installPip3package() {
   sudo pip3 install $1 --quiet
   echo "[???????] Installed pip3 package $1"
}

exitIfEnvironmentVariableIsNotSet GITHUB_USER_EMAIL
exitIfEnvironmentVariableIsNotSet GITHUB_USER_NAME

# timeshift
sudo timeshift --create --comments "run by linuxMint.sh"

# remove unwanted directories
deleteDirectoryIfExists ~/Music
deleteDirectoryIfExists ~/Videos
deleteDirectoryIfExists ~/Templates
deleteDirectoryIfExists ~/Pictures
deleteDirectoryIfExists ~/Public
deleteDirectoryIfExists ~/Documents

# apt
sudo apt update -qq
sudo apt upgrade -qq

# python
installAptPackage python3-pip
installPip3package virtualenv

# remove unwanted apt packages
removeAptPackageIfInstalled thunderbird
removeAptPackageIfInstalled celluloid
removeAptPackageIfInstalled rhythmbox
removeAptPackageIfInstalled gnote
removeAptPackageIfInstalled hexchat
removeAptPackageIfInstalled pix
removeAptPackageIfInstalled pix-data
removeAptPackageIfInstalled hypnotix
removeAptPackageIfInstalled webapp-manager
removeAptPackageIfInstalled mpv
removeAptPackageIfInstalled drawing
removeAptPackageIfInstalled sticky
removeAptPackageIfInstalled simple-scan
removeAptPackageIfInstalled zsh
removeAptPackageIfInstalled zsh-common
sudo apt autoremove -qq

# vlc
installAptPackage vlc

# gimp
installAptPackage gimp

# nfs-common
installAptPackage nfs-common

# terminator
installAptPackage terminator

# nodejs
installAptPackage nodejs

# texlive-xetex
installAptPackage texlive-xetex

# fzf
installAptPackage fzf

# apt-transport-https
installAptPackage apt-transport-https

#curl
installAptPackage curl

# gnupg
installAptPackage gnupg

# restic
installAptPackage restic

# snap
installAptPackage snapd
sudo snap refresh

# bitwarden
installSnapPackage bw

# intellij
installSnapPackage "intellij-idea-community --classic"

# git
installAptPackage git
downloadFile \
   https://raw.githubusercontent.com/jttait/laptop/main/gitconfig \
   ~/.gitconfig
makeDirectoryIfNotExists ~/.githooks
downloadFile \
   https://raw.githubusercontent.com/jttait/laptop/main/githooks/pre-commit \
   ~/.githooks/pre-commit
chmod +x ~/.githooks/pre-commit
setGitConfigFromEnvironmentVariable "user.email" "GITHUB_USER_EMAIL"
setGitConfigFromEnvironmentVariable "user.name" "GITHUB_USER_NAME"

# vim
installAptPackage vim
downloadFile \
   https://raw.githubusercontent.com/jttait/laptop/main/vimrc \
   ~/.vimrc
downloadFile \
   https://raw.githubusercontent.com/jttait/laptop/main/vim/ftplugin/javascript.vim \
   ~/.vim/ftplugin/javascript.vim
installAndUpdateVimPackageFromGithub "nerdcommenter" "https://github.com/preservim/nerdcommenter"
installAndUpdateVimPackageFromGithub "nerdtree" "https://github.com/preservim/nerdtree"
installAndUpdateVimPackageFromGithub "ale" "https://github.com/dense-analysis/ale"
installAndUpdateVimPackageFromGithub "fzf" "https://github.com/junegunn/fzf"
installAndUpdateVimPackageFromGithub "fzf.vim" "https://github.com/junegunn/fzf.vim"

# javascript
sudo npm install standard --global

# sdkman
source "$HOME/.sdkman/bin/sdkman-init.sh"
if command -v sdk &> /dev/null
then
   echo "[SKIPPED] sdk already installed"
else
   curl -s "https://get.sdkman.io?rcupdate=false" | bash
   if command -v sdk &> /dev/null
   then
      echo -e "[${GREEN}SUCCESS${NC}] Successfully installed sdk"
   else
      echo -e "[${RED}FAILURE${NC}] Failed to install sdk"
   fi
fi
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk update

# java
sdk install java 16.0.1.hs-adpt
sdk install micronaut
sdk install gradle

# bash 
downloadFile \
   https://raw.githubusercontent.com/jttait/laptop/main/bashrc \
   ~/.bashrc

# docker
removeAptPackageIfInstalled docker
removeAptPackageIfInstalled docker-engine
removeAptPackageIfInstalled docker.io
removeAptPackageIfInstalled runc
sudo apt update -qq
installAptPackage ca-certificates
installAptPackage lsb-release
installAptPackage software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  ${UBUNTU_DISTRO} stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update -qq
installAptPackage docker-ce
installAptPackage docker-ce-cli
installAptPackage containerd.io

# borg
sudo add-apt-repository ppa:costamagnagianfranco/borgbackup --yes
sudo apt update -qq
installAptPackage borgbackup

