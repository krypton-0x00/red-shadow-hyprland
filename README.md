# Hyprland Dotfiles

This repository contains a Red-Black Themed Hyprland configuration. 

---

## Demo

Demo video showing the configuration in use:

https://jmp.sh/Ey29okW54BcgsAG1IBfS

---

## Installation
Clone the repository:

```
git clone https://github.com/krypton-0x00/dotfiles-new-hyprland.git
cd dotfiles-new-hyprland
```

Run the installer:

```
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

```
packages.lst
```

The installer reads this file and installs packages using yay automatically. So no need to worry about deps. 

---

## Notes

- Symlinks are forced (`ln -sf`)
- Script does not manage NVIDIA, If you want nvidia drivers check linutil by Christ Titus. 
- Repository is intended for personal workstation setup.
- If the script fails check the error and manually edit the `install.sh` script for fixes, most likly its gonna cause by the `packages.lst`, coz sometimes your setup would already have a certain packages that will conflict will the installer, in that case remove the package manually from `packages.lst` or from your system and rerun the `install.sh`.
