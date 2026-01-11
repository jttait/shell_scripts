#!/bin/bash

rm --recursive --force ~/Music
rm --recursive --force ~/Videos
rm --recursive --force ~/Pictures
rm --recursive --force ~/Public
rm --recursive --force ~/Templates
rm --recursive --force ~/Documents

sudo apt install git
sudo apt install vim
sudo apt install borgbackup
sudo apt install restic
sudo apt install vlc
