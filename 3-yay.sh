#!/bin/bash
# __   __ _ __   __
# \ \ / // \\ \ / /
#  \ V // _ \\ V / 
#   | |/ ___ \| |  
#   |_/_/   \_\_|  
#                 
# by theclient75 (2023)
# ------------------------------------------------------
# Install Script for Yay
# ------------------------------------------------------
# Name: yay Install Script
# DESC: All required steps to install yay
# WARNING: Run this script at your own risk.

clear
echo "__   __ _ __   __"
echo "\ \ / // \\ \ / /"
echo " \ V // _ \\ V / "
echo "  | |/ ___ \| |  "
echo "  |_/_/   \_\_|  "
echo "                 "
echo ""

# -----------------------------------------------------
# Confirm Start
# -----------------------------------------------------
while true; do
    read -p "DO YOU WANT TO START THE INSTALLATION NOW? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            echo "Installation started."
        break;;
        [Nn]* ) 
            exit;
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done
git clone https://aur.archlinux.org/yay-git.git
cd yay-git
makepkg -si

echo "DONE!"
