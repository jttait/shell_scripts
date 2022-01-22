#!/bin/bash

GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m'

exitIfEnvironmentVariableIsNotSet() {
   VARIABLE_NAME=$1
   VARIABLE_VALUE=${!VARIABLE_NAME}
   if [[ -z ${VARIABLE_VALUE} ]]
   then
      echo -e "${RED}FAILURE${NC} Environment variable $1 is not set!"
      exit 1
   fi
}

setGitConfigFromEnvironmentVariable() {
   VARIABLE_NAME=$2
   VARIABLE_VALUE="${!VARIABLE_NAME}"
   if [[ -z $VARIABLE_VALUE ]]
   then
      echo -e "${RED}FAILURE${NC} Environment variable $VARIABLE_NAME not set"
      exit 1
   else
      git config --global $1 "$VARIABLE_VALUE"
      echo -e "${GREEN}SUCCESS${NC} Git config $1 set to $VARIABLE_VALUE"
   fi
}

installBrewFormula() {
   if brew ls $1 > /dev/null
   then
      echo -e "${GREEN}SUCCESS${NC} Brew formula $1 is already installed"
   else
      brew install $1
      if brew ls $1 > /dev/null
      then
         echo -e "${GREEN}SUCCESS${NC} Installed Brew formula $1"
      else
         echo -e "${RED}FAILURE${NC} Failed to install Brew formula $1"
      fi
   fi
}

installBrewCask() {
   if brew ls --cask $1 > /dev/null
   then
      echo -e "${GREEN}SUCCESS${NC} Brew cask $1 is already installed"
   else
      brew install --cask $1
      if brew ls --cask $1 > /dev/null
      then
         echo -e "${GREEN}SUCCESS${NC} Installed Brew cask $1"
      else
         echo -e "${RED}FAILURE${NC} Failed to install Brew cask $1"
      fi
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

exitIfEnvironmentVariableIsNotSet GITHUB_USER_NAME
exitIfEnvironmentVariableIsNotSet GITHUB_USER_EMAIL

brew update
installBrewFormula derailed/k9s/k9s
installBrewFormula tfenv
installBrewFormula git
installBrewCask iterm2
brew upgrade

downloadFile \
   https://raw.githubusercontent.com/jttait/laptop/main/gitconfig \
   ~/.gitconfig
mkdir -p ~/.githooks
downloadFile \
   https://raw.githubusercontent.com/jttait/laptop/main/githooks/pre-commit \
   ~/.githooks/pre-commit
chmod +x ~/.githooks/pre-commit
setGitConfigFromEnvironmentVariable "user.email" "GITHUB_USER_EMAIL"
setGitConfigFromEnvironmentVariable "user.name" "GITHUB_USER_NAME"

downloadFile \
   https://raw.githubusercontent.com/jttait/laptop/main/vimrc \
   ~/.vimrc
