install_pacman_package() {
	sudo pacman --sync --sysupgrade --refresh --needed "$1"
}
install_yay_package() {
	yay --sync --sysupgrade --refresh --needed "$1"
}
setup_git() {
	wget --timestamping --quiet \
		https://raw.githubusercontent.com/jttait/shell_scripts/main/gitconfig \
		--output-document ~/.gitconfig
	mkdir --parents ~/.githooks
	wget --timestamping --quiet \
		https://raw.githubusercontent.com/jttait/shell_scripts/main/githooks/pre-commit/ \
		--output-document ~/.githooks/pre-commit
	chmod +x ~/.githooks/pre-commit
	git config --global user.email "$GITHUB_USER_EMAIL"
	git config --global user.name "$GITHUB_USER_NAME"
}
install_docker_plugin() {
	sudo mkdir --parents /usr/lib/docker/cli-plugins
	sudo wget --timestamping --quiet \
		"$2" \
		--output-document "/usr/lib/docker/cli-plugins/$1"
	sudo chmod +x "/usr/lib/docker/cli-plugins/$1"
}
install_sdkman() {
	curl -s "https://get.sdkman.io" | bash
	source "$HOME/.sdkman/bin/sdkman-init.sh"
}

rm --recursive --force ~/Music
rm --recursive --force ~/Pictures
rm --recursive --force ~/Public
rm --recursive --force ~/Templates
rm --recursive --force ~/Videos
rm --recursive --force ~/Documents

install_pacman_package base-devel
install_pacman_package dolphin
install_pacman_package konsole
install_pacman_package vim
install_pacman_package firefox
install_pacman_package fuse2
install_pacman_package man
install_pacman_package borg
install_pacman_package restic
install_pacman_package libreoffice-still
install_pacman_package docker
install_pacman_package go
install_pacman_package minikube
install_pacman_package kubectl
install_pacman_package k9s
install_pacman_package intellij-idea-community-edition
install_pacman_package git
install_pacman_package calibre
install_pacman_package helm
install_pacman_package texlive-basic
install_pacman_package texlive-latex
install_pacman_package texlive-xetex
install_pacman_package texlive-latexrecommended
install_pacman_package texlive-latexextra
install_pacman_package texlive-fontsrecommended
install_pacman_package ktorrent
install_pacman_package openssh
install_pacman_package wget

install_yay_package tfenv
install_yay_package aws-cli-v2
install_yay_package piavpn-bin

setup_git

install_docker_plugin docker-compose \
  "https://github.com/docker/compose/releases/download/v2.23.0/docker-compose-linux-x86_64"
install_docker_plugin docker-buildx \
  "https://github.com/docker/buildx/releases/download/v0.11.2/buildx-v0.11.2.linux-amd64"
sudo usermod -aG docker $USER

install_sdkman
sdk install java 22.0.1-tem
sdk install java 21.0.3-tem
sdk install java 17.0.11-tem
sdk install gradle
sdk install micronaut

wget --timestamping --quiet \
	https://raw.githubusercontent.com/jttait/shell_scripts/main/bashrc \
	--output-document ~/.bashrc
