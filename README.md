# Hyprland Dotfiles

This repository contains a Red-Black themed Hyprland configuration.

> **Note:** This script is intended for personal use and may not work on all systems. Review before running.


## Demo

Video Guide:

https://www.youtube.com/watch?v=hMgZhhmL-3A

---

## Installation

This script assumes a minimal Arch install.  
If you are on an existing system, make sure to back up your configs before running.

If you want to completely reset `.config` manually:

```sh
# Only run this if you know what you are doing.
rm -rf ~/.config
```

Clone the repository:

```sh
git clone https://github.com/krypton-0x00/red-shadow-hyprland
cd red-shadow-hyprland
```

Run the installer:

```sh
./install.sh
```

The installer performs the following:

- Installs packages listed in `packages.lst` (using yay)
- Sets up PipeWire audio (safe mode, handles Pulse/JACK conflicts)
- Enables Bluetooth support
- Backups existing configs and symlinks new ones into `~/.config`
- Runs theme setup script
- Optionally installs security tools

---

## Package List

The repository includes a package list:

```sh
packages.lst
```

The installer reads this file and installs packages using `yay` automatically.  
No need to worry about dependencies.

---

## Notes

- Symlinks are forced (`ln -sf`)
- Script does not manage NVIDIA. If you want NVIDIA drivers and hardware setup, check [Linutil](https://github.com/ChrisTitusTech/linutil) by Chris Titus.
- Repository is intended for personal workstation setup.
- If the script fails, check the error and manually edit `install.sh` for fixes.  
  Most likely the issue is caused by a package conflict from `packages.lst` on an existing system.  
  In that case remove the package manually from `packages.lst` or uninstall it from your system and re-run `install.sh`.


