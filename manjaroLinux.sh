#!/bin/bash

RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m'

downloadFile() {
  wget -Nq $1 -O $2
  if [ $? -eq 0 ]
  then
    echo -e "${GREEN}SUCCESS${NC} Downloaded $2"
  else
    echo -e "${RED}FAILURE${NC} Failed to download $2"
  fi
}

exitIfEnvironmentVariableIsNotSet() {
  VARIABLE_NAME=$1
  VARIABLE_VALUE=${!VARIABLE_NAME}
  if [[ -z ${VARIABLE_VALUE} ]]
  then
    echo -e "${RED}FAILURE${NC} Environment variable $1 is not set!"
    exit 1
  fi
}

removePacmanPackage() {
  if pacman -Q | grep $1
  then
    sudo pacman -R $1
  fi
  echo -e "${GREEN}SUCCESS${NC} Pacman removed $1"
}

installPacmanPackage() {
  sudo pacman -Syu --needed $1
  if [ $? -eq 0 ]
  then
    echo -e "${GREEN}SUCCESS${NC} Pacman installed $1"
  else
    echo -e "${RED}FAILURE${NC} Pacman failed to install $1"
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

setupGit() {
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
}

downloadBashrc() {
  downloadFile \
    https://raw.githubusercontent.com/jttait/laptop/main/bashrc \
    ~/.bashrc
}

installDockerComposePlugin() {
	mkdir -p /usr/lib/docker/cli-plugins
	curl -SL https://github.com/docker/compose/releases/download/v2.12.2/docker-compose-linux-x86_64 -o /usr/lib/docker/cli-plugins/docker-compose
	chmod +x /usr/lib/docker/cli-plugins/docker-compose
}

installAwsCli() {
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "$HOME/Downloads/awscliv2.zip"
	unzip $HOME/Downloads/awscliv2.zip -d $HOME/Downloads/
	sudo $HOME/Downloads/aws/install --update
	rm $HOME/Downloads/awscliv2.zip
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

echo ""

exitIfEnvironmentVariableIsNotSet GITHUB_USER_EMAIL
exitIfEnvironmentVariableIsNotSet GITHUB_USER_NAME

sudo pacman -Syyu

removePacmanPackage pidgin
removePacmanPackage thunderbird
removePacmanPackage hexchat
removePacmanPackage onlyoffice-desktopeditors
removePacmanPackage audacious

installPacmanPackage borg
installPacmanPackage git
installPacmanPackage vim
installPacmanPackage task
installPacmanPackage restic
installPacmanPackage libreoffice-still
installPacmanPackage python-pip
installPacmanPackage fzf
installPacmanPackage transmission-gtk
installPacmanPackage docker
installPacmanPackage intellij-idea-community-edition
installPacmanPackage go
installPacmanPackage minikube
installPacmanPackage kubectl
installPacmanPackage helm
installPacmanPackage texlive-basic
installPacmanPackage texlive-latex
installPacmanPackage texlive-xetex
installPacmanPackage texlive-latexrecommended
installPacmanPackage texlive-latexextra
installPacmanPackage texlive-fontsrecommended

setupGit

downloadBashrc

installDockerComposePlugin

installAwsCli

installSdkMan
sdk install java 19.0.2-tem
sdk install java 17.0.6-tem
sdk install gradle
sdk install micronaut

sudo usermod -aG docker $USER

echo ""
