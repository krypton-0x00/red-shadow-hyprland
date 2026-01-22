#!/bin/bash
set -e

echo "[+] Setting up themes and icons dirs"
mkdir -p ~/.themes
mkdir -p ~/.icons

echo "[+] Installing extraction tools"
sudo pacman -S --noconfirm p7zip

echo "[+] Extracting theme"
7z x ~/red-shadow-hyprland/themes/Midnight-Red.7z -o"$HOME/.themes"

echo "[+] Extracting icons"
tar -xf ~/red-shadow-hyprland/themes/ColorFlow.tar.xz -C ~/.icons


echo "[+] Fixing permissions"
chmod -R 755 ~/.themes ~/.icons

echo "[+] Setting up themes..."

gsettings set org.gnome.desktop.interface gtk-theme "Midnight-Red"
gsettings set org.gnome.desktop.interface icon-theme "ColorFlow"
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

echo "[+] Done"

