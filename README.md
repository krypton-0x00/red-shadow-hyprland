# Hyprland Dotfiles

This repository contains a Red-Black Themed Hyprland configuration. 

> **Note:** This script is intended for personal use and may not work on all systems. Review before running.


## Demo

Demo video showing the configuration in use:

https://jmp.sh/Ey29okW54BcgsAG1IBfS

---

## Installation
This Script Assumes that you have a fresh minimal arch install.
So if you are on a pre-existing setup then make sure to backup your `.config` folder and then remove it.
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
- Sets up PipeWire audio
- Enables Bluetooth support
- Symlinks configuration directories into `~/.config`
- Runs theme setup script
- Optionally installs security tools

---

## Package List

The repository includes a package list:

```sh
packages.lst
```

The installer reads this file and installs packages using yay automatically. So no need to worry about deps. 

---

## Notes

- Symlinks are forced (`ln -sf`)
- Script does not manage NVIDIA. If you want NVIDIA drivers and hardware setup, check [Linutil](https://github.com/ChrisTitusTech/linutil) by Chris Titus.
- Repository is intended for personal workstation setup.
- If the script fails check the error and manually edit the `install.sh` script for fixes, most likly its gonna cause by the `packages.lst`, coz sometimes your setup would already have a certain packages that will conflict will the installer, in that case remove the package manually from `packages.lst` or from your system and rerun the `install.sh`.
