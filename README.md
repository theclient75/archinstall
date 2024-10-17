# Arch Install Script with btrfs for Timeshift or snapper

This is a bash based Arch Linux installation script with EFI boot loader and btrfs partition prepared for Timeshift or snapper.

[![Watch on YouTube](https://img.youtube.com/vi/uskzgcyGAOE/0.jpg)](https://www.youtube.com/watch?v=uskzgcyGAOE)

Install Arch Linux YOUR WAY. Arch Linux Installation 2023
https://youtu.be/uskzgcyGAOE

## Getting started

To make it easy for you to get started, here's a list of recommended next steps. 
The script will ask for some information during the installation but is not performing any validation check so far.
To get detailed information how to install Arch Linux, please visit https://wiki.archlinux.org/title/installation_guide


```
# Load keyboard layout (replace de with us, fr, es if needed)
loadkeys de-latin1

# Increase font size (optional)
setfont ter-p20b

# Connect to WLAN (if not LAN)
iwctl --passphrase [password] station wlan0 connect [network]

# Check internet connection
ping -c4 www.archlinux.org

# Check partitions
lsblk

# Create partitions
gdisk /dev/sda
# Partition 1: +512M ef00 (for EFI)
# Partition 2: Available space 8300 (for Linux filesystem)
# (Optional Partition 3 for Virtual Machines)
# Write w, Confirm Y

# Sync package
pacman -Syy

# Maybe it's required to install the current archlinux keyring
# if the installation of git fails.
pacman -S archlinux-keyring
pacman -Syy

# Install git
pacman -S git

# Clone Installation
git clone https://gitlab.com/stephan-raabe/archinstall.git
cd archinstall

# Start the script
./1-install.sh

```

## Additional information

Please note that the scripts in folder /optional are not tested yet.

After the installation you will find additional scripts in your home folder to install

- yay aur helper
- zram swap file
- timeshift snapshots
- preload application cache

Please also check out the dotfiles to configure qtile and several other applications.

