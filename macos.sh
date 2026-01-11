#!/bin/bash

GREEN='\033[32m'
NOCOLOR='\033[0m'
RED='\033[31m'

download_file() {
  wget -Nq $1 -O $2
  if [ $? -ne 0 ]
  then
    echo -e "${RED}Failed to download $2${NOCOLOR}"
  else
    echo -e "${GREEN}Downloaded $2${NOCOLOR}"
  fi
}

make_directory() {
  if [ ! -d "$1" ]
  then
    mkdir -p "$1"
  fi
}

brew_install() {
   brew_name=$1
   if [ $# -eq 2 ]
   then
      brew_name=$2
   fi
   check=$(brew list | grep -E "^$brew_name$" | wc -l)
   if [ $check -eq 1 ]
   then
      echo -e "${GREEN}$brew_name already installed by brew${NOCOLOR}"
   else
      brew install $1
      check=$(brew list | grep $brew_name | wc -l)
      if [ $check -eq 1 ]
      then
         echo "${GREEN}$brew_name installed by brew${NOCOLOR}"
      else
         echo "${RED}$brew_name failed to be installed by brew${NOCOLOR}"
         exit 1
      fi
   fi
}

brew_cask_install() {
   brew_name=$1
   if [ $# -eq 2 ]
   then
      brew_name=$2
   fi
   check=$(brew list | grep -E "^$brew_name$" | wc -l)
   if [ $check -eq 1 ]
   then
      echo -e "${GREEN}$brew_name already installed by brew${NOCOLOR}"
   else
      brew install --cask $1
      check=$(brew list | grep $brew_name | wc -l)
      if [ $check -eq 1 ]
      then
         echo "${GREEN}$brew_name installed by brew${NOCOLOR}"
      else
         echo "${RED}$brew_name failed to be installed by brew${NOCOLOR}"
         exit 1
      fi
   fi
}

brew_update() {
   brew update --quiet &> /dev/null
   if [ $? -eq 0 ]
   then
      echo -e "${GREEN}brew updated${NOCOLOR}"
   else
      echo -e "${RED}brew update failed${NOCOLOR}"
   fi
}

tfenv_install() {
   tfenv install $1 &> /dev/null
   if [ $(tfenv list | grep -c $1) -ge 1 ]
   then
      echo -e "${GREEN}tfenv installed $1${NOCOLOR}"
   else
      echo -e "${RED}tfenv failed to install $1${NOCOLOR}"
   fi
}

tfenv_use() {
   tfenv use $1 &> /dev/null
   if [ $(tfenv list | grep -c "^\* $1") -eq 1 ]
   then
      echo -e "${GREEN}tfenv using $1${NOCOLOR}"
   else
      echo -e "${RED}tfenv failed to use $1${NOCOLOR}"
   fi
}

sdkman_setup() {
   curl -s "https://get.sdkman.io" | bash &> /dev/null
   source "$HOME/.sdkman/bin/sdkman-init.sh"
   sdk update &> /dev/null
   if command -v sdk &> /dev/null
   then
      echo -e "${GREEN}sdkman has been installed${NOCOLOR}"
   else
      echo -e "${RED}sdkman failed to be installed${NOCOLOR}"
   fi
}

sdkman_install_java() {
   sdk install java $1 &> /dev/null
   if [ $(sdk list java | grep -c "local only | $1") -eq 1 ]
   then
      echo -e "${GREEN}sdkman installed java $1"
   else
      echo -e "${RED}sdkman failed to install java $1"
   fi
}

sdkman_install_gradle() {
   sdk install gradle $1 &> /dev/null
   if [ $(sdk list gradle | grep -c "\* $1") -eq 1 ]
   then
      echo -e "${GREEN}sdkman installed gradle $1${NOCOLOR}"
   else
      echo -e "${RED}sdkman failed to install gradle $1${NOCOLOR}"
   fi
}

sdkman_install_groovy() {
   sdk install groovy $1 &> /dev/null
   if [ $(sdk list groovy | grep -c "\* $1") -eq 1 ]
   then
      echo -e "${GREEN}sdkman installed groovy $1${NOCOLOR}"
   else
      echo -e "${RED}sdkman failed to install groovy $1${NOCOLOR}"
   fi
}

if [ -z "$GIT_USER_NAME" ]; then
   echo "GIT_USER_NAME environment variable is not set. Exiting."
   exit 1
fi

if [ -z "$GIT_USER_EMAIL" ]; then
   echo "GIT_USER_EMAIL environment variable is not set. Exiting."
   exit 1
fi

brew_update

brew tap hashicorp/tap

brew_install minikube
brew_install k9s
brew_install tfenv
brew_install git
brew_install bash
brew_install helm
brew_install iterm2
brew_install intellij-idea-ce
brew_install awscli
brew_install azure-cli
brew_install session-manager-plugin
brew_install gh
brew_install azcopy
brew_cask_install bruno
brew_cask_install sqlitestudio
brew_install Azure/kubelogin/kubelogin kubelogin
brew_install hashicorp/tap/vault vault
brew_cask_install microsoft-teams
brew_cask_install jabra-direct

brew upgrade
brew upgrade --cask --greedy

brew cleanup

tfenv_install 1.4.5
tfenv_use 1.4.5

sdkman_setup

sdkman_install_java 8.0.362-tem
sdkman_install_java 11.0.18-tem
sdkman_install_java 17.0.2-tem
sdkman_install_gradle 8.7
sdkman_install_groovy 4.0.11

make_directory $HOME/.githooks/
download_file https://raw.githubusercontent.com/jttait/shell_scripts/main/githooks/pre-commit $HOME/.githooks/pre-commit 

download_file https://raw.githubusercontent.com/jttait/shell_scripts/main/gitconfig $HOME/.gitconfig 
git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"
