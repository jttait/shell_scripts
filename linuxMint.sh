#!/bin/bash

deleteDirectoryIfExists() {
   if [ -d $1 ]
   then
      echo "linuxMint.sh :: Removing directory $1"
      sudo rm -r $1
   else
      echo "linuxMint.sh :: Directory $1 does not exist, not removing"
   fi
}

installAndUpdateVimPackageFromGithub() {
  cd ~/.vim/pack/gitplugins/start/
  git clone $2
  cd ~/.vim/pack/gitplugins/start/$1
  git pull
}

removeAptPackageIfInstalled() {
   if dpkg --get-selections | grep -q "^$1[[:space:]]*install$" >/dev/null
   then
      echo "linuxMint.sh :: removing $1"
      sudo apt remove $1
   else
      echo "linuxMint.sh :: $1 not installed, not removing"
   fi
}

# timeshift
sudo timeshift --create --comments "run by newLinuxMint.sh"

# remove unwanted directories
deleteDirectoryIfExists "~/Music"
deleteDirectoryIfExists "~/Videos"
deleteDirectoryIfExists "~/Templates"
deleteDirectoryIfExists "~/Pictures"
deleteDirectoryIfExists "~/Public"
deleteDirectoryIfExists "~/Documents"

# apt
sudo apt update
sudo apt upgrade

# python
sudo apt install python3-pip
sudo pip3 install virtualenv

# remove unwanted apt packages
removeAptPackageIfInstalled "thunderbird"
removeAptPackageIfInstalled "celluloid"
removeAptPackageIfInstalled "rhythmbox"
removeAptPackageIfInstalled "gnote"
removeAptPackageIfInstalled "hexchat"
removeAptPackageIfInstalled "pix"
removeAptPackageIfInstalled "pix-data"
removeAptPackageIfInstalled "hypnotix"
removeAptPackageIfInstalled "webapp-manager"
removeAptPackageIfInstalled "mpv"
removeAptPackageIfInstalled "drawing"
removeAptPackageIfInstalled "sticky"
removeAptPackageIfInstalled "simple-scan"
sudo apt autoremove

# install apt packages
sudo apt install vim
sudo apt install vlc
sudo apt install gimp
sudo apt install nfs-common
sudo apt install terminator
sudo apt install nodejs
sudo apt install snapd
sudo apt install texlive-xetex
sudo apt install fzf
sudo apt install restic

# install snap packages
sudo snap install duplicity --classic
sudo snap install intellij-idea-community --classic
sudo snap install bw
sudo snap refresh

# git
sudo apt install git
wget -N https://raw.githubusercontent.com/jttait/laptop/main/gitconfig?token=ABPYVWFMT4Z6PEAGK6ZVJ2TBYDIRA -O ~/.gitconfig
mkdir ~/.githooks 
wget -N https://raw.githubusercontent.com/jttait/laptop/main/githooks/pre-commit?token=ABPYVWAYHSP4FSWRQIJCOMTBYYQNK -O ~/.githooks/pre-commit
chmod +x ~/.githooks/pre-commit
git config --global user.email $GITHUB_USER_EMAIL
git config --global user.name $GITHUB_USER_NAME

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

# sdkman
curl -s "https://get.sdkman.io?rcupdate=false" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk update

# java
sdk install java 16.0.1.hs-adpt
sdk install micronaut
sdk install gradle

# bash 
wget -N https://raw.githubusercontent.com/jttait/laptop/main/bashrc?token=ABPYVWASHVSYMCSHRCGTZ4LBX6VCO -O ~/.bashrc

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

