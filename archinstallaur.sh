#!/bin/bash

echo
echo
read -p 'What X11-keymap do you need? (gb, us...): ' key_var
echo
echo "Installing AUR..."
sleep 2
localectl set-x11-keymap $key_var
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -rsi
clear
echo
while true; do
    read -p "Do you want install Pamac Package Manager Yes/No?" input
    case $input in
        [Yy][Ee][Ss]|[Yy]* ) yay -Sy pamac-aur pamac-tray-appindicator --noconfirm; break;;
        [Nn][Oo]|[Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done
echo
clear
echo
echo "                     FINISHED"
echo "                     ========"
echo
echo "DELETE archinstallaur.sh and yay folder from HOME folder..."
echo "========================================================="
