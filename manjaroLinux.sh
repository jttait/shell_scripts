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
     $HOME/.gitconfig
  makeDirectory $HOME/.githooks
  downloadFile \
    https://raw.githubusercontent.com/jttait/laptop/main/githooks/pre-commit \
    $HOME/.githooks/pre-commit
  chmod +x ~/.githooks/pre-commit
  setGitConfigFromEnvironmentVariable "user.email" "GITHUB_USER_EMAIL"
  setGitConfigFromEnvironmentVariable "user.name" "GITHUB_USER_NAME"
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
		$HOME/Downloads/awscliv2.zip
	unzip -qq $HOME/Downloads/awscliv2.zip -d $HOME/Downloads/
	sudo $HOME/Downloads/aws/install --update
	rm -f $HOME/Downloads/awscliv2.zip
	rm -r $HOME/Downloads/aws
}

installSdkMan() {
	source $HOME/.sdkman/bin/sdkman-init.sh
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
	source $HOME/.sdkman/bin/sdkman-init.sh
	sdk update
}

installAndUpdateVimPackageFromGithub() {
   makeDirectory $HOME/.vim/pack/gitplugins/start
   cd ~/.vim/pack/gitplugins/start/
   if [ ! -d $1 ]
   then
      git clone --quiet $2
   fi
   cd ~/.vim/pack/gitplugins/start/$1
   git pull --quiet
}

installPamacPackage() {
	result=$(pamac list | grep $1)
	if [[ -z "$result" ]]
	then
		sudo pamac install $1 --no-confirm
	fi
}

removePamacPackage() {
	result=$(pamac list | grep $1)
	if [[ -n "$result" ]]
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

echo ""

removeDirectory $HOME/Music
removeDirectory $HOME/Pictures
removeDirectory $HOME/Public
removeDirectory $HOME/Templates
removeDirectory $HOME/Videos
removeDirectory $HOME/Documents

sudo pamac update
sudo pamac upgrade

removePamacPackage pidgin
removePamacPackage thunderbird
removePamacPackage hexchat
removePamacPackage onlyoffice-desktopeditors
removePamacPackage audacious
removePamacPackage audacious-plugins

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

installPamacPackage git
setupGit

installPamacPackage vim
installAndUpdateVimPackageFromGithub "vim-go" "https://github.com/fatih/vim-go.git"

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

echo ""
