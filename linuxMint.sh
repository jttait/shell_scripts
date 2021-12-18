#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

deleteDirectoryIfExists() {
   if [ -d $1 ]
   then
      sudo rm -r $1
      if [ -d $1 ]
      then
         echo -e "[${RED}FAILED${NC}] Failed to remove directory $1"
      else
         echo -e "{${GREEN}SUCCESS${NC}] Successfully removed directory $1"
      fi
   else
      echo "[SKIPPED] Directory $1 does not exist, not removing"
   fi
}

makeDirectoryIfNotExists() {
   if [ -d $1 ]
   then 
      echo -e "[SKIPPED] Directory $1 already exists"
   else
      mkdir $1
      if [ -d $1 ]
      then
         echo -e "[${GREEN}SUCCESS${NC}] Successfully made directory $1"
      else
         echo -e "[${RED}FAILURE${NC}] Failed to make directory $1"
      fi
   fi
}

installAndUpdateVimPackageFromGithub() {
  cd ~/.vim/pack/gitplugins/start/
  git clone $2
  cd ~/.vim/pack/gitplugins/start/$1
  git pull
}

installAptPackage() {
   if dpkg --get-selections | grep -q "^$1[[:space:]]*install$" >/dev/null
   then
      echo -e "[SKIPPED] APT package $1 already installed"
   else
      sudo apt --qq install $1
      if dpkg --get-selections | grep -q "^$1[[:space:]]*install$" >/dev/null
      then
         echo -e "[${GREEN}SUCCESS${NC}] successfully installed APT package $1"
      else
         echo -e "[${RED}FAILED${NC}] failed to install APT package $1"
      fi
   fi
}

installSnapPackage() {
   sudo snap install $1
}

removeAptPackageIfInstalled() {
   if dpkg --get-selections | grep -q "^$1[[:space:]]*install$" >/dev/null
   then
      sudo apt remove $1
      if dpkg --get-selections | grep -q "^$1[[:space:]]*install$" >/dev/null
      then
         echo -e "[${RED}FAILED${NC}] failed to remove APT package $1"
      else
         echo -e "[${GREEN}SUCCESS${NC}] successfully removed APT package $1"
      fi
   else
      echo "[SKIPPED] $1 not installed, not removing"
   fi
}

setGitConfigFromEnvironmentVariable() {
   VARIABLE_NAME=$2
   VARIABLE_VALUE="${!VARIABLE_NAME}"
   if [[ -z $VARIABLE_VALUE ]]
   then
      echo -e "[${RED}FAILURE${NC}] Environment variable $VARIABLE_NAME not set"
   else
      git config --global $1 "$VARIABLE_VALUE"
      echo -e "[${GREEN}SUCCESS${NC}] Git config $1 set to $VARIABLE_VALUE"
   fi
}

downloadFile() {
   wget -Nq $1 -O $2
   if [ $? -eq 0 ]
   then
      echo -e "[${GREEN}SUCCESS${NC}] Downloaded $2"
   else
      echo -e "[${RED}FAILURE${NC}] Failed to download $2"
   fi
}

# timeshift
sudo timeshift --create --comments "run by newLinuxMint.sh"

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
sudo pip3 install virtualenv

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
sudo apt autoremove -qq

# vlc
installAptPackage vlc

# gimp
installAptPackage gimp

# install apt packages
installAptPackage nfs-common
installAptPackage terminator
installAptPackage nodejs
installAptPackage texlive-xetex
installAptPackage fzf

# restic
installAptPackage restic

# snap
installAptPackage snapd
sudo snap refresh

# bitwarden
installSnapPackage bw

# intellij
installSnapPackage "intellij-idea-community --classic"

# duplicity
installSnapPackage "duplicity --classic"

# git
installAptPackage git
downloadFile https://raw.githubusercontent.com/jttait/laptop/main/gitconfig?token=ABPYVWFMT4Z6PEAGK6ZVJ2TBYDIRA ~/.gitconfig
makeDirectoryIfNotExists ~/.githooks
downloadFile https://raw.githubusercontent.com/jttait/laptop/main/githooks/pre-commit?token=ABPYVWAYHSP4FSWRQIJCOMTBYYQNK ~/.githooks/pre-commit
chmod +x ~/.githooks/pre-commit
setGitConfigFromEnvironmentVariable "user.email" "GITHUB_USER_EMAIL"
setGitConfigFromEnvironmentVariable "user.name" "GITHUB_USER_NAME"

# vim
installAptPackage "vim"
downloadFile https://raw.githubusercontent.com/jttait/laptop/main/vimrc?token=ABPYVWDO2I5GOOQQIFFTANDBYDHN4 ~/.vimrc
installAndUpdateVimPackageFromGithub "nerdcommenter" "https://github.com/preservim/nerdcommenter"
installAndUpdateVimPackageFromGithub "nerdtree" "https://github.com/preservim/nerdtree"
installAndUpdateVimPackageFromGithub "ale" "https://github.com/dense-analysis/ale"
installAndUpdateVimPackageFromGithub "fzf" "https://github.com/junegunn/fzf"
installAndUpdateVimPackageFromGithub "fzf.vim" "https://github.com/junegunn/fzf.vim"

# javascript
downloadFile https://raw.githubusercontent.com/jttait/vimrc/master/.vim/ftplugin/javascript.vim ~/.vim/javascript.vim
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
downloadFile https://raw.githubusercontent.com/jttait/laptop/main/bashrc?token=ABPYVWASHVSYMCSHRCGTZ4LBX6VCO ~/.bashrc

# docker
removeAptPackageIfInstalled "docker"
removeAptPackageIfInstalled "docker-engine"
removeAptPackageIfInstalled "docker.io"
removeAptPackageIfInstalled "runc"
sudo apt update -qq
installAptPackage "apt-transport-https"
installAptPackage "ca-certificates"
installAptPackage "curl"
installAptPackage "gnupg"
installAptPackage "lsb-release"
installAptPackage "software-properties-common"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  focal stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update -qq
installAptPackage "docker-ce"
installAptPackage "docker-ce-cli"
installAptPackage "containerd.io"

# borg
sudo add-apt-repository ppa:costamagnagianfranco/borgbackup
sudo apt update -qq
installAptPackage "borgbackup"

