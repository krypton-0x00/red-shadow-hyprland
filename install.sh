#!/usr/bin/env bash
set -euo pipefail

PKGFILE="packages.lst"
REPO_DIR="$HOME/red-shadow-hyprland"
SECFILE="$REPO_DIR/security-pkgs.lst"

# Loggers
info() { printf "\033[1;34m[INFO]\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m[WARN]\033[0m %s\n" "$*"; }
err()  { printf "\033[1;31m[ERR ]\033[0m %s\n" "$*"; }

# ===============================
# Package Install 
# ===============================

if [[ ! -f "$PKGFILE" ]]; then
    err "Error: $PKGFILE not found"
    exit 1
fi

if ! command -v yay &> /dev/null; then
    info "yay not found, installing..."

    sudo pacman -S --noconfirm --needed base-devel git

    tmpdir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
    cd "$tmpdir/yay"
    makepkg -si --noconfirm
    cd -
fi

info "Installing packages from $PKGFILE..."
yay -S --needed --noconfirm $(cat "$PKGFILE")
info "Done!"

# ===============================
# PipeWire
# ===============================

info "=== Setting up PipeWire Audio (safe mode) ==="

HAS_JACK=0
if pacman -Qq jack2 &>/dev/null || pacman -Qq jack &>/dev/null; then
    HAS_JACK=1
fi

HAS_PRO_AUDIO=0
if pacman -Qq ardour carla cadence qtractor lsp-plugins &>/dev/null; then
    HAS_PRO_AUDIO=1
fi

if [[ $HAS_JACK -eq 1 && $HAS_PRO_AUDIO -eq 0 ]]; then
    warn "JACK detected — swapping to pipewire-jack (safe replacement)"
elif [[ $HAS_JACK -eq 1 && $HAS_PRO_AUDIO -eq 1 ]]; then
    warn "Pro-audio/JACK workflow detected — NOT auto-removing JACK!"
    warn "Skipping JACK→PipeWire swap for safety."
fi

if pacman -Qq pulseaudio pulseaudio-alsa &>/dev/null; then
    warn "Removing PulseAudio..."
    sudo pacman -Rns --noconfirm pulseaudio pulseaudio-alsa || true
fi

info "Installing PipeWire base packages..."
sudo pacman -S --needed --noconfirm \
    pipewire pipewire-pulse pipewire-alsa wireplumber || true

if [[ $HAS_JACK -eq 1 && $HAS_PRO_AUDIO -eq 0 ]]; then
    info "Installing pipewire-jack (conflict resolution mode)..."
    sudo pacman -S --needed --noconfirm --ask=4 pipewire-jack || true
fi

info "Installing PipeWire utilities..."
sudo pacman -S --needed --noconfirm pavucontrol helvum qpwgraph || true

if systemctl --user >/dev/null 2>&1; then
    info "Enabling PipeWire systemd user services..."
    systemctl --user enable --now pipewire.service    || true
    systemctl --user enable --now wireplumber.service || true
    systemctl --user enable --now pipewire-pulse.service || true
else
    warn "systemd --user not active (TTY/AUR build) — will start on login."
fi

# Verify
if pactl info >/dev/null 2>&1; then
    info "Audio backend running: $(pactl info | grep 'Server Name')"
fi

info "=== PipeWire setup complete ==="
# ===============================
# Bluetooth
# ===============================

info "=== Installing Bluetooth Utils ==="
sudo pacman -S --needed --noconfirm bluez bluez-utils
sudo systemctl enable --now bluetooth.service
sudo usermod -aG lp "$USER"
info "==== Bluetooth setup complete ===="

# ===============================
# Dotfiles 
# ===============================

info "=== Setting up dotfiles ==="

CFG_SRC="$REPO_DIR/configs"
CFG_DST="$HOME/.config"
BACKUP_DIR="$HOME/dotfile-backups-$(date +%Y%m%d-%H%M%S)"

mkdir -p "$CFG_DST"

for item in "$CFG_SRC"/*; do
    name=$(basename "$item")
    src="$item"
    dst="$CFG_DST/$name"

    if [[ -e "$dst" && ! -L "$dst" ]]; then
        warn "Found existing: $dst → moving to backup"
        mkdir -p "$BACKUP_DIR"
        mv "$dst" "$BACKUP_DIR/"
    fi

    info "→ ln -sf \"$src\" \"$dst\""
    ln -sf "$src" "$dst"
done

info "=== Dotfiles setup complete ==="
# ===============================
# Theme 
# ===============================


info "=== Installing Themes."
if [ -x "$REPO_DIR/scripts/setup-themes.sh" ]; then
    info "[*] Running theme setup…"
    "$REPO_DIR/setup-themes.sh"
else
    warn "[!] setup-themes.sh not executable, fixing perms..."
    chmod +x "$REPO_DIR/scripts/setup-themes.sh"
    "$REPO_DIR/scripts/setup-themes.sh"
fi
info "=== Theme Setup Done==="
# ===============================
# Security Tool 
# ===============================

info ""
read -r -p "Do you want to install security tools? [y/N]: " ans

case "$ans" in
    y|Y|yes|YES)
        if [[ ! -f "$SECFILE" ]]; then
            warn "[!] $SECFILE not found — skipping security install!"
        else
            info "[*] Installing security tools from $SECFILE..."
            yay -S --needed --noconfirm $(cat "$SECFILE")
            info "[✓] Security tools install complete."
        fi
        ;;
    *)
        warn "[*] Skipping security tools."
        ;;
esac
info "===All Done==="



