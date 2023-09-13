#!/bin/bash

if [ -z "$GIT_USER_NAME" ]; then
   echo "GIT_USER_NAME environment variable is not set. Exiting."
   exit 1
fi

if [ -z "$GIT_USER_EMAIL" ]; then
   echo "GIT_USER_EMAIL environment variable is not set. Exiting."
   exit 1
fi

brew update

brew install minikube
brew install Azure/kubelogin/kubelogin
brew install k9s
brew install tfenv
brew install git
brew install bash
brew install helm
brew install iterm2
brew install intellij-idea-ce
brew install postman
brew install awscli
brew install azure-cli
brew install session-manager-plugin
brew install --cask sqlitestudio
brew install terragrunt

brew upgrade
brew upgrade --cask --greedy

tfenv install 1.4.5
tfenv use 1.4.5

curl -s "https://get.sdkman.io" | bash

source "$HOME/.sdkman/bin/sdkman-init.sh"

sdk install java 8.0.362-tem
sdk install java 11.0.18-tem
sdk install java 17.0.2-tem
sdk install gradle
sdk install groovy 4.0.11

mkdir $HOME/.githooks
wget -O $HOME/.githooks/pre-commit https://raw.githubusercontent.com/jttait/shell_scripts/main/githooks/pre-commit

wget -O $HOME/.gitconfig https://raw.githubusercontent.com/jttait/shell_scripts/main/gitconfig
git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"
