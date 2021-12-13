#!/bin/bash

deleteDirectoryIfExists() {
  if [ -d $1 ]
  then
    sudo rm -r $1
  fi
}

installAndUpdateVimPackageFromGithub() {
  cd ~/.vim/pack/gitplugins/start/
  git clone $2
  cd ~/.vim/pack/gitplugins/start/$1
  git pull
}

# Timeshift
sudo timeshift --create --comments "run by newLinuxMint.sh"

# Remove unwanted directories from home directory
deleteDirectoryIfExists "~/Music"
deleteDirectoryIfExists "~/Videos"
deleteDirectoryIfExists "~/Templates"
deleteDirectoryIfExists "~/Pictures"
deleteDirectoryIfExists "~/Public"
deleteDirectoryIfExists "~/Documents"

# Update APT
sudo apt update
sudo apt upgrade

# Setup Python
sudo apt install python3-pip
sudo pip3 install virtualenv

# Remove unwanted programs
sudo apt remove thunderbird
sudo apt remove celluloid
sudo apt remove rhythmbox
sudo apt remove gnote
sudo apt remove hexchat
sudo apt remove pix
sudo apt remove pix-data
sudo apt remove hypnotix
sudo apt remove webapp-manager
sudo apt remove mpv
sudo apt remove drawing
sudo apt remove sticky
sudo apt remove simple-scan
sudo apt autoremove

# Install Aptitude packages
sudo apt install vim
sudo apt install vlc
sudo apt install gimp
sudo apt install nfs-common
sudo apt install git
sudo apt install terminator
sudo apt install nodejs
sudo apt install snapd
sudo apt install texlive-xetex
sudo apt install fzf
sudo apt install restic

# Install Snap packages
sudo snap install duplicity --classic
sudo snap install bw
sudo snap refresh

# vim
wget -N https://raw.githubusercontent.com/jttait/laptop/main/vimrc?token=ABPYVWDO2I5GOOQQIFFTANDBYDHN4 -O ~/.vimrc
installAndUpdateVimPackageFromGithub "nerdcommenter" "https://github.com/preservim/nerdcommenter"
installAndUpdateVimPackageFromGithub "nerdtree" "https://github.com/preservim/nerdtree"
installAndUpdateVimPackageFromGithub "ale" "https://github.com/dense-analysis/ale"
installAndUpdateVimPackageFromGithub "fzf" "https://github.com/junegunn/fzf"
installAndUpdateVimPackageFromGithub "fzf.vim" "https://github.com/junegunn/fzf.vim"

# javascript
wget -N https://raw.githubusercontent.com/jttait/vimrc/master/.vim/ftplugin/javascript.vim -O ~/.vim/javascript.vim
sudo npm install standard --global

# bash 
wget -N https://raw.githubusercontent.com/jttait/laptop/main/bashrc?token=ABPYVWASHVSYMCSHRCGTZ4LBX6VCO -O ~/.bashrc

# git
wget -N https://raw.githubusercontent.com/jttait/laptop/main/gitconfig?token=ABPYVWFMT4Z6PEAGK6ZVJ2TBYDIRA -O ~/.gitconfig

# sdkman
curl -s "https://get.sdkman.io?rcupdate=false" | bash
sdk install java 16.0.1.hs-adpt
sdk install micronaut
sdk install gradle

# docker
sudo apt remove docker
sudo apt remove docker-engine
sudo apt remove docker.io
sudo apt remove containerd
sudo apt remove runc
sudo apt update
sudo apt install apt-transport-https
sudo apt install ca-certificates
sudo apt install curl
sudo apt install gnupg
sudo apt install lsb-release
sudo apt install software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  focal stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce
sudo apt install docker-ce-cli
sudo apt install containerd.io

# borg
sudo add-apt-repository ppa:costamagnagianfranco/borgbackup
sudo apt update
sudo apt install borgbackup

