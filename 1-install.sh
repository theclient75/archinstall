#!/bin/bash
clear
echo "    _             _       ___           _        _ _ "
echo "   / \   _ __ ___| |__   |_ _|_ __  ___| |_ __ _| | |"
echo "  / _ \ | '__/ __| '_ \   | || '_ \/ __| __/ _' | | |"
echo " / ___ \| | | (__| | | |  | || | | \__ \ || (_| | | |"
echo "/_/   \_\_|  \___|_| |_| |___|_| |_|___/\__\__,_|_|_|"
echo ""
echo "by Stephan Raabe (2023)"
echo "-----------------------------------------------------"
echo ""
echo "This script will erase your hard disk and partition it with "
echo "this layout: 300 Mib efi boot, the rest for root. "
echo "Warning: Run this script at your own risk!"
echo ""

lsblk
read -p "Enter the name of your unformatted disk: " disk
sgdisk --zap-all /dev/$disk
sgdisk -o /dev/$disk
sgdisk -n 1:0:+512M -t 1:ef00 -c 1:"EFI" /dev/$disk
sgdisk -n 2:0:0     -t 2:8300 -c 2:"ROOT" /dev/$disk
# ------------------------------------------------------
# Enter partition names
# ------------------------------------------------------
lsblk
read -p "Enter the name of the EFI partition (eg. sda1): " efi
read -p "Enter the name of the root partition (eg. sda2): " root
read -p "Choose your processor (amd or intel): " processor
# read -p "Enter the name of the VM partition (keep it empty if not required): " sda3

# ------------------------------------------------------
# Sync time
# ------------------------------------------------------
timedatectl set-ntp true

# ------------------------------------------------------
# Format partitions
# ------------------------------------------------------
mkfs.fat -F 32 /dev/$efi;
mkfs.btrfs -f /dev/$root
# mkfs.btrfs -f /dev/$sda3

# ------------------------------------------------------
# Mount points for btrfs
# ------------------------------------------------------
mount /dev/$root /mnt
btrfs su cr /mnt/@
btrfs su cr /mnt/@cache
btrfs su cr /mnt/@home
btrfs su cr /mnt/@snapshots
btrfs su cr /mnt/@log
umount /mnt

mount -o compress=zstd:1,noatime,subvol=@ /dev/$root /mnt
mkdir -p /mnt/{boot/efi,home,.snapshots,var/{cache,log}}
mount -o compress=zstd:1,noatime,subvol=@cache /dev/$root /mnt/var/cache
mount -o compress=zstd:1,noatime,subvol=@home /dev/$root /mnt/home
mount -o compress=zstd:1,noatime,subvol=@log /dev/$root /mnt/var/log
mount -o compress=zstd:1,noatime,subvol=@snapshots /dev/$root /mnt/.snapshots
mount /dev/$efi /mnt/boot/efi
# mkdir /mnt/vm
# mount /dev/$sda3 /mnt/vm

# ------------------------------------------------------
# Install base packages
# ------------------------------------------------------
pacstrap -K /mnt base base-devel git linux linux-firmware vim openssh reflector rsync $processor\-ucode

# ------------------------------------------------------
# Generate fstab
# ------------------------------------------------------
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab

# ------------------------------------------------------
# Install configuration scripts
# ------------------------------------------------------
mkdir /mnt/archinstall
cp 2-configuration.sh /mnt/archinstall/
cp 3-yay.sh /mnt/archinstall/
cp 4-zram.sh /mnt/archinstall/
cp 5-timeshift.sh /mnt/archinstall/
cp 6-preload.sh /mnt/archinstall/
cp snapshot.sh /mnt/archinstall/

# ------------------------------------------------------
# Chroot to installed sytem
# ------------------------------------------------------
arch-chroot /mnt ./archinstall/2-configuration.sh

