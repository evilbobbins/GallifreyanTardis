#! /bin/bash

# New laptop setup 
# updated 10/08/2022

# Standard Repo Application List

APPS1="neofetch htop code vlc gimp gedit bleachbit krusader conky plank nextcloud-desktop git hardinfo"

# None-Standard Repo Application List

APPS2="code conky-manager2 ulauncher"

echo "New install setup script"

echo "Installing Nala Apt Replacment"
echo "deb http://deb.volian.org/volian/ scar main" | sudo tee /etc/apt/sources.list.d/volian-archive-scar-unstable.list
wget -qO - https://deb.volian.org/volian/scar.key | sudo tee /etc/apt/trusted.gpg.d/volian-archive-scar-unstable.gpg
sudo apt update && sudo apt install -y nala
sudo nala fetch

# VSCode Download and repo setup 

echo "Install VScode"
sudo nala install wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] \
https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

sudo nala install -y apt-transport-https

# Conky Manager repo

sudo add-apt-repository -y ppa:ubuntuhandbook1/conkymanager2

# Ulauncher repo

sudo add-apt-repository ppa:agornostal/ulauncher

# Update system

echo "Updating system"
sudo nala update
sudo nala upgrade -y

# Install applications

echo "install Standard Application list"
sudo nala install -y $APPS1

echo "install Extra Application list"
sudo nala install -y $APPS2

# Finsh
clear
neofetch
echo "All done"
