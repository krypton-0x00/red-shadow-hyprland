#!/usr/bin/env bash

set -e

if [[ ! -f "$PKGFILE" ]]; then
    echo "Error: $PKGFILE not found"
    exit 1
fi

if ! command -v yay &> /dev/null; then
    echo "yay not found, installing..."

    sudo pacman -S --noconfirm --needed base-devel git

    tmpdir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
    cd "$tmpdir/yay"
    makepkg -si --noconfirm

    cd -
fi

echo "Installing packages from $PKGFILE..."

yay -S --needed --noconfirm $(cat "$PKGFILE")

echo "Done!"

echo "=== Setting up PipeWire Audio ==="
# we skip pipewire here coz its in the packages.lst
sudo pacman -S --needed --noconfirm \
    pipewire-pulse \
    pipewire-alsa \
    pipewire-jack \

if pacman -Q pulseaudio &>/dev/null; then
    echo "Pulseaudio detected, removing..."
    sudo pacman -Rns --noconfirm pulseaudio pulseaudio-alsa
fi

sudo pacman -S --needed --noconfirm \
    pavucontrol \
    helvum \
    qpwgraph

systemctl --user enable --now pipewire.service
systemctl --user enable --now wireplumber.service
systemctl --user enable --now pipewire-pulse.service

echo "=== PipeWire Audio setup complete. A reboot is recommended. ==="

echo "=== Installing Bluetooth Utils"
sudo pacman -S --needed --noconfirm bluez bluez-utils
sudo systemctl enable --now bluetooth.service
echo "====Bluetooth setup complete===="

