#!/bin/bash
set -e

echo "[+] Setting up themes and icons dirs"
mkdir -p ~/.themes
mkdir -p ~/.icons

echo "[+] Installing extraction tools"
sudo pacman -S --noconfirm p7zip

echo "[+] Extracting theme"
7z x ~/dotfiles-new-hyprland/themes/Midnight-Red.7z -o"$HOME/.themes"

echo "[+] Extracting icons"
tar -xf ~/dotfiles-new-hyprland/themes/ColorFlow.tar.xz -C ~/.icons


echo "[+] Fixing permissions"
chmod -R 755 ~/.themes ~/.icons

echo "[+] Setting up themes..."

gsettings set org.gnome.desktop.interface gtk-theme "Midnight-Red"
gsettings set org.gnome.desktop.interface icon-theme "ColorFlow"

echo "[+] Done"

