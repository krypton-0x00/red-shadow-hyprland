#!/usr/bin/env bash
set -euo pipefail

PKGFILE="packages.lst"
REPO_DIR="$HOME/red-shadow-hyprland"
SECFILE="$REPO_DIR/security-pkgs.lst"
# ===============================
# Package Install + Requirements
# ===============================

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

# ===============================
# PipeWire
# ===============================

echo "=== Setting up PipeWire Audio ==="

sudo pacman -S --needed --noconfirm \
    pipewire-pulse \
    pipewire-alsa \
    jack2

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

echo "=== PipeWire Audio setup complete. ==="

# ===============================
# Bluetooth
# ===============================

echo "=== Installing Bluetooth Utils ==="
sudo pacman -S --needed --noconfirm bluez bluez-utils
sudo systemctl enable --now bluetooth.service
echo "==== Bluetooth setup complete ===="

# ===============================
# Dotfiles 
# ===============================

echo "=== Setting up dotfiles ==="
echo "[*] Creating symlinks into ~/.config ..."


cd "$REPO_DIR"

echo "[*] Linking dotfiles into ~/.config/ ..."

mkdir -p "$HOME/.config"

find . -maxdepth 1 -mindepth 1 \
  ! -name ".git" \
  ! -name ".github" \
  ! -name "README.md" \
  ! -name "themes" \
  ! -name "demo.mp4" \
  ! -name "install.sh" \
  ! -name "walls" \
  ! -name "setup-themes.sh" \
  ! -name "install-script-beta.sh" \
  ! -name "packages.lst" \
  ! -name "security-pkgs.lst" \
  | sed 's|^\./||' \
  | xargs -I{} bash -c "
        src=\"$REPO_DIR/{}\"
        dst=\"$HOME/.config/{}\"

        echo ln -sf \"\$src\" \"\$dst\"
        ln -sf \"\$src\" \"\$dst\"
    "



echo "=== Dotfiles setup complete ==="
# ===============================
# Theme 
# ===============================


echo "=== Installing Themes."
if [ -x "$REPO_DIR/setup-themes.sh" ]; then
    echo "[*] Running theme setup…"
    "$REPO_DIR/setup-themes.sh"
else
    echo "[!] setup-themes.sh not executable, fixing perms..."
    chmod +x "$REPO_DIR/setup-themes.sh"
    "$REPO_DIR/setup-themes.sh"
fi
echo "=== Theme Setup Done==="
# ===============================
# Security Tool 
# ===============================

echo ""
read -r -p "Do you want to install security tools? [y/N]: " ans

case "$ans" in
    y|Y|yes|YES)
        if [[ ! -f "$SECFILE" ]]; then
            echo "[!] $SECFILE not found — skipping security install!"
        else
            echo "[*] Installing security tools from $SECFILE..."
            yay -S --needed --noconfirm $(cat "$SECFILE")
            echo "[✓] Security tools install complete."
        fi
        ;;
    *)
        echo "[*] Skipping security tools."
        ;;
esac
echo "===All Done==="



