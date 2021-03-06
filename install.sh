#!/bin/bash

b=`tput bold`
n=`tput sgr0`

echo -e "${b}Enabling parallel downloads for dnf ${n}\n"
sudo cp ./dnf.conf /etc/dnf/dnf.conf

echo -e "${b}Removing unnecessary preinstalled packages ${n}\n"
sudo dnf remove -y $(cat lists/useless)

echo -e "${b}Installing (dnf) packages from lists ${n}\n"
sudo dnf install -y $(cat ./lists/packages/*)

echo -e "${b}Installing kvm${n}\n"
bash ./virtualization.sh

echo -e "${b}Removing libreoffice${n}\n"
sudo dnf remove -y '*libreoffice*'

echo -e "${b}Installing Visual Studio Code${n}\n"
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf check-update -y 
sudo dnf install -y code

echo -e "${b}Adding Flathub remote${n}\n"
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo -e "${b}Installing (flatpak) packages from lists ${n}\n"
sudo flatpak install -y $(cat lists/flatpak)

echo -e "${b}Updating Computer${n}\n"
sudo dnf update -y 

echo -e "${b}Fixing Gnome Terminal${n}\n"
bash ./gnome-terminal.sh

echo -e "${b}Making tweaks to Gnome Shell${n}\n"
bash ./gnome-setup.sh

echo -e "${b}Installing Terminal and preferences${n}\n"
bash ./terminal.sh
