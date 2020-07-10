#!/bin/bash
#
# This script was insired by EZNIX's  EZArch linux install guides.
# https://www.youtube.com/channel/UCQrSHD-tv9nkssrD4nNGcMw/videos
#   
welcome () {
    clear
    echo ""
    echo "    -------------------------------------------------------"
    echo "    |          WELCOME TO NEIL'S ARCH SCRIPT UEFI         |"
    echo "    |                                                     |"
    echo "    |                 I hope you like it                  |"
    echo "    |                                                     |"
    echo "    |                                                     |"
    echo "    |  https://github.com/NHarv/Arch-Linux-Install-script |"
    echo "    -------------------------------------------------------"
    sleep 5
    clear
}
#
#
welcomeb () {
    clear
    echo ""
    echo "    -------------------------------------------------------"
    echo "    |          WELCOME TO NEIL'S ARCH SCRIPT BIOS         |"
    echo "    |                                                     |"
    echo "    |                 I hope you like it                  |"
    echo "    |                                                     |"
    echo "    |                                                     |"
    echo "    |  https://github.com/NHarv/Arch-Linux-Install-script |"
    echo "    -------------------------------------------------------"
    sleep 5
    clear
}
#
#
keyboard () {
    clear
    echo
    read -p "Please enter you Keyboard (eg uk, us): " KEYVAR
    loadkeys "${KEYVAR}"
    clear
}
#
#
timedate () {
    timedatectl set-ntp true
}
#
#
tzlocale (){
    clear
    TZVAR="$(curl -s https://ipapi.co/timezone)"
    LOCALEVAR1="$(curl -s https://ipapi.co/languages | head -c 2)"
    LOCALEVAR2="$(curl -s https://ipapi.co/country | head -c 2)"
    LOCALEVAR="${LOCALEVAR1}"_"${LOCALEVAR2}"
    clear
}
#
#
partitions () {
    clear
    echo ""
    lsblk
    echo ""
    read -p "which Drive do you want to use?: " DRIVEVAR
    cfdisk /dev/"${DRIVEVAR}"
    clear
}
#
#
partitionsb () {
    clear
    echo ""
    lsblk
    echo ""
    read -p "which Drive do you want to use?: " DRIVEVAR
    cfdisk /dev/"${DRIVEVAR}"
    clear
}
#
#
partpick () {
    clear
    echo ""
    lsblk
    echo ""
    echo "        Please pick your Partitions:"
    echo ""
    read -p "               EFI Partition No?: " EFIVAR
    echo ""
    read -p "              SWAP Partition No?: " SWAPVAR
    echo ""
    read -p "            SYSTEM Partition No?: " SYSVAR
    echo ""
    read -p "  HOME Partition No if required?: " HOMEVAR
    clear
}
#
#
partpickb () {
    clear
    echo ""
    lsblk
    echo ""
    echo "        Please pick your Partitions:"
    echo ""
    read -p "              SWAP Partition No?: " SWAPVAR
    echo ""
    read -p "            SYSTEM Partition No?: " SYSVAR
    echo ""
    read -p "  HOME Partition No if required?: " HOMEVAR
    clear
}
#
#
hostusrpass () {
    clear
    echo ""
    echo "       Please enter your details..."
    echo ""
    read -p "                       Host Name?: " HOSTVAR
    echo ""
    read -p "                       User Name?: " USERVAR
    echo ""
    read -p "                   User Password?: " PASSVAR1
    echo ""
    read -p "Please enter your password again?: " PASSVAR2
    [[ "${PASSVAR1}" == "${PASSVAR2}" ]] || ( echo "Passwords did not match"; exit 1; )
    clear
}
#
#
homequest () {
    clear
    while true; do
        echo ""
        read -r -p "Did you make a Home partition? (yes/no): " ans;
        case $ans in
            [yY][eE][sS]|[yY]* )
                homequest2; break;;
            [nN][oO]|[nN]* )
                formatpart && mountpart; break;;
            * ) 
                echo "Please Answer Yes or No.";;
        esac
    done
    clear
}
#
#
homequest2 () {
    clear
    while true; do
        echo ""
        read -r -p "Do you want to format it? (yes/no): " ans;
        case $ans in
            [yY][eE][sS]|[yY]* )
                formatparth && mountparth; break;;
            [nN][oO]|[nN]* )
                formatpart && mountparth; break;;
            * ) 
                echo "Please Answer Yes or No.";;
        esac
    done
    clear
}
#
#
homequestb () {
    clear
    while true; do
        echo ""
        read -r -p "Did you make a Home partition? (yes/no): " ans;
        case $ans in
            [yY][eE][sS]|[yY]* )
                homequestb2; break;;
            [nN][oO]|[nN]* )
                formatpartb && mountpartb; break;;
            * ) 
                echo "Please Answer Yes or No.";;
        esac
    done
    clear
}
#
#
homequestb2 () {
    clear
    while true; do
        echo ""
        read -r -p "Do you want to format it? (yes/no): " ans;
        case $ans in
            [yY][eE][sS]|[yY]* )
                formatparthb && mountparthb; break;;
            [nN][oO]|[nN]* )
                formatpartb && mountparthb; break;;
            * ) 
                echo "Please Answer Yes or No.";;
        esac
    done
    clear
}
#
#
formatparth () {
    clear
    echo ""
    echo "Formatting Partitions..."
    sleep 3
    mkfs.fat -F32 /dev/"${DRIVEVAR}""${EFIVAR}"
    mkfs.ext4 /dev/"${DRIVEVAR}""${SYSVAR}"
    mkfs.ext4 /dev/"${DRIVEVAR}""${HOMEVAR}"
    mkswap /dev/"${DRIVEVAR}""${SWAPVAR}"
    swapon /dev/"${DRIVEVAR}""${SWAPVAR}"
    clear
}
#
#
mountparth () {
    clear
    echo ""
    echo "Mounting Partitions..."
    sleep 3
    mount /dev/"${DRIVEVAR}""${SYSVAR}" /mnt
    mkdir -p /mnt/boot/EFI
    mount /dev/"${DRIVEVAR}""${EFIVAR}" /mnt/boot/EFI
    mkdir -p /mnt/home
    mount /dev/"${DRIVEVAR}""${HOMEVAR}" /mnt/home
    clear
}
#
#
formatpart () {
    clear
    echo ""
    echo "Formatting Partitions..."
    sleep 3
    mkfs.fat -F32 /dev/"${DRIVEVAR}""${EFIVAR}"
    mkfs.ext4 /dev/"${DRIVEVAR}""${SYSVAR}"
    mkswap /dev/"${DRIVEVAR}""${SWAPVAR}"
    swapon /dev/"${DRIVEVAR}""${SWAPVAR}"
    clear
}
#
#
mountpart () {
    clear
    echo ""
    echo "Mounting Partitions..."
    sleep 3
    mount /dev/"${DRIVEVAR}""${SYSVAR}" /mnt
    mkdir -p /mnt/boot/EFI
    mount /dev/"${DRIVEVAR}""${EFIVAR}" /mnt/boot/EFI
    clear
}
#
#
formatparthb () {
    clear
    echo ""
    echo "Formatting Partitions..."
    sleep 3
    mkfs.ext4 /dev/"${DRIVEVAR}""${SYSVAR}"
    mkfs.ext4 /dev/"${DRIVEVAR}""${HOMEVAR}"
    mkswap /dev/"${DRIVEVAR}""${SWAPVAR}"
    swapon /dev/"${DRIVEVAR}""${SWAPVAR}"
    clear
}
#
#
mountparthb () {
    clear
    echo ""
    echo "Mounting Partitions..."
    sleep 3
    mount /dev/"${DRIVEVAR}""${SYSVAR}" /mnt
    mkdir -p /mnt/home
    mount /dev/"${DRIVEVAR}""${HOMEVAR}" /mnt/home
    clear
}
#
#
formatpartb () {
    clear
    echo ""
    echo "Formatting Partitions..."
    sleep 3
    mkfs.ext4 /dev/"${DRIVEVAR}""${SYSVAR}"
    mkswap /dev/"${DRIVEVAR}""${SWAPVAR}"
    swapon /dev/"${DRIVEVAR}""${SWAPVAR}"
    clear
}
#
#
mountpartb () {
    clear
    echo ""
    echo "Mounting Partitions..."
    sleep 3
    mount /dev/"${DRIVEVAR}""${SYSVAR}" /mnt
    clear
}
#
#
setmirrors () {
    echo
    echo "     Setting up Mirrors and Repositories..."
    sleep 3
    pacman -Syy
    pacman -Sy archlinux-keyring reflector --noconfirm
    reflector --latest 20 --protocol http --protocol https --sort rate --save /etc/pacman.d/mirrorlist
    clear
}
#
#
instbase () {
    clear
    echo ""
    echo "Installing Base System..."
    sleep 3
    pacstrap /mnt base base-devel linux linux-firmware sysfsutils usbutils e2fsprogs dosfstools mtools inetutils netctl device-mapper cryptsetup nano less lvm2 dialog wpa_supplicant --noconfirm
    clear
}
#
#
fstab () {
    clear
    echo ""
    echo "Generating Fstab..."
    sleep 3
    genfstab -U /mnt >> /mnt/etc/fstab
    clear
}
#
#
setmirrors2 () {
    echo ""
    echo "     Setting up Mirrors and Repositories..."
    sleep 3
    arch-chroot /mnt pacman -Syy
    arch-chroot /mnt pacman -Sy archlinux-keyring reflector --noconfirm
    arch-chroot /mnt reflector --latest 20 --protocol http --protocol https --sort rate --save /etc/pacman.d/mirrorlist
    clear
}
#
#
setusrpriv () {
    clear
    echo ""
    echo "Adding User and setting up Sudo Priverlages..."
    sleep 3
    arch-chroot /mnt useradd -m -g users -G wheel,audio,video,storage,power,input,optical,sys,log,network,floppy,scanner,rfkill,lp,adm -s /bin/bash $USERVAR
    echo
    arch-chroot /mnt echo ""${USERVAR}":"${PASSVAR1}"" | chpasswd --root /mnt
    arch-chroot /mnt echo "root:"${PASSVAR1}"" | chpasswd --root /mnt
    clear
    echo
    echo "setting up Sudo Priverlages..."
    sleep 2
    sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /mnt/etc/sudoers
    clear
}
#
#
hostlocale () {
    echo ""
    echo "Setting up Hostname and Locales..."
    sleep 3
    echo "${HOSTVAR}" > /mnt/etc/hostname
    echo 127.0.0.1	localhost >> /mnt/etc/hosts
    echo ::1		localhost >> /mnt/etc/hosts
    echo 127.0.1.1	"${HOSTVAR}".localdomain	"${HOSTVAR}" >> /mnt/etc/hosts
    echo "${LOCALEVAR}".UTF-8 UTF-8 >> /mnt/etc/locale.gen
    arch-chroot /mnt locale-gen
    echo LANG="${LOCALEVAR}".UTF-8 >> /mnt/etc/locale.conf
    echo LC_COLLATE=C >> /mnt/etc/locale.conf
    export LANG="${LOCALEVAR}".UTF-8
    echo KEYMAP="${KEYVAR}" > /mnt/etc/vconsole.conf
    ln -sf /usr/share/zoneinfo/"${TZVAR}" /mnt/etc/localtime
    arch-chroot /mnt hwclock --systohc --utc
    clear
}
#
#
bootload () {
    echo ""
    echo "Installing and Setting up Bootloader..."
    sleep 3
    arch-chroot /mnt pacman -Sy grub efibootmgr os-prober --noconfirm
    arch-chroot /mnt grub-install --target=x86_64-efi  --bootloader-id=grub_uefi --recheck
    arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
    arch-chroot /mnt mkinitcpio -p linux
    clear
}
#
#
bootloadb () {
    echo ""
    echo "Installing and Setting up Bootloader..."
    sleep 3
    arch-chroot /mnt pacman -Sy grub os-prober --noconfirm
    arch-chroot /mnt grub-install --target=i386-pc /dev/"${DRIVEVAR}"
    arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
    arch-chroot /mnt mkinitcpio -p linux
    clear
}
#
#
enabserv () {
    clear
    echo ""
    echo "Enabling services..."
    sleep 3
    arch-chroot /mnt systemctl enable "${DM}"
    clear
}
#
#
instxorg () {
    echo
    echo "Installing Xorg..."
    sleep 3
    pacstrap /mnt xorg xorg-apps xorg-server xorg-drivers xorg-xkill xorg-xinit xterm mesa --noconfirm
    clear
}
#
#
instgen () {
    echo ""
    while true; do
        read -r -p "Are you sure you want to Install General Software (y/n) " ans;
        case $ans in
            [yY][eE][sS]|[yY]* )
                pacstrap /mnt --needed linux-headers dkms p7zip archiso haveged pacman-contrib pkgfile git diffutils jfsutils reiserfsprogs btrfs-progs f2fs-tools logrotate man-db man-pages mdadm perl s-nail texinfo which xfsprogs lsscsi sdparm sg3_utils smartmontools fuse2 fuse3 ntfs-3g exfat-utils gvfs gvfs-afc gvfs-goa gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb unrar unzip unace xz xdg-user-dirs xscreensaver grsync ddrescue dd_rescue testdisk hdparm htop rsync hardinfo bash-completion geany lsb-release polkit ufw bleachbit packagekit gparted --noconfirm; break;;
            [nN][oO]|[nN]* )
                break;;
            * ) 
                echo "Please Answer Yes or No.";;
        esac
    done
    clear
}
#
#
instmulti () {
    echo ""
    while true; do
        read -r -p "Are you sure you want to Install Multimedia Software (y/n) " ans;
        case $ans in
            [yY][eE][sS]|[yY]* )
                pacstrap /mnt --needed pulseaudio vlc simplescreenrecorder cdrtools gstreamer gst-libav gst-plugins-base gst-plugins-base-libs gst-plugins-good gst-plugins-bad gst-plugins-ugly gstreamer-vaapi gst-transcoder xvidcore frei0r-plugins cdrdao dvdauthor transcode alsa-utils alsa-plugins alsa-firmware pulseaudio-alsa pulseaudio-equalizer pulseaudio-jack ffmpeg ffmpegthumbnailer libdvdcss gimp guvcview imagemagick flac faad2 faac mjpegtools x265 x264 lame sox mencoder --noconfirm; break;;
            [nN][oO]|[nN]* )
                break;;
            * ) 
                echo "Please Answer Yes or No.";;
        esac
    done
    clear
}
#
#
instnet () {
    echo ""
    while true; do
        read -r -p "Are you sure you want to Install Networking Software (y/n) " ans;
        case $ans in
            [yY][eE][sS]|[yY]* )
                pacstrap /mnt --needed b43-fwcutter broadcom-wl-dkms intel-ucode ipw2100-fw ipw2200-fw net-tools networkmanager networkmanager-openvpn nm-connection-editor network-manager-applet wget curl firefox thunderbird wireless_tools nfs-utils nilfs-utils dhclient dnsmasq dmraid dnsutils openvpn openssh openssl samba whois iwd filezilla avahi openresolv youtube-dl vsftpd --noconfirm && arch-chroot /mnt systemctl enable NetworkManager; break;;
            [nN][oO]|[nN]* )
                break;;
            * ) 
                echo "Please Answer Yes or No.";;
        esac
    done
    clear
}
#
#
instfonttheme () {
    echo ""
    while true; do
        read -r -p "Are you sure you want to Install Fonts and Themes (y/n) " ans;
        case $ans in
            [yY][eE][sS]|[yY]* )
                pacstrap /mnt --needed ttf-ubuntu-font-family ttf-dejavu ttf-bitstream-vera ttf-liberation noto-fonts ttf-roboto ttf-opensans opendesktop-fonts cantarell-fonts freetype2 papirus-icon-theme --noconfirm; break;;
            [nN][oO]|[nN]* )
                break;;
            * ) 
                echo "Please Answer Yes or No.";;
        esac
    done
    clear
}
#
#
isntprint () {
    echo ""
    while true; do
        read -r -p "Are you sure you want to Install Printing Software (y/n) " ans;
        case $ans in
            [yY][eE][sS]|[yY]* )
                pacstrap /mnt --needed system-config-printer foomatic-db foomatic-db-engine gutenprint hplip simple-scan cups cups-pdf cups-filters cups-pk-helper ghostscript gsfonts python-pillow python-pyqt5 python-pip python-reportlab --noconfirm && arch-chroot /mnt systemctl enable org.cups.cupsd.service; break;;
            [nN][oO]|[nN]* )
                break;;
            * ) 
                echo "Please Answer Yes or No.";;
        esac
    done
    clear
}
#
#
finish () {
    clear
    pacstrap /mnt pavucontrol-qt --noconfirm
    echo ""
    wget https://raw.githubusercontent.com/NHarv/Arch-Linux-Install-script/master/archinstallaur.sh
    chmod +x archinstallaur.sh
    echo ""
    cp archinstallaur.sh /mnt/home/"${USERVAR}"
    clear

    echo ""
    echo ""
    echo "  ________________________________"
    echo "  |           FINISHED           |"
    echo "  |  Please shutdown the system  |"
    echo "  |   remove the install media   |"
    echo "  |                              |"
    echo "  | Type poweroff at the prompt. |"
    echo "  |                              |"
    echo "  |     BOOT INTO NEW SYSTEM     |"
    echo "  ________________________________"
}
#
#
instdesk () {
    clear
    echo ""
    echo "Do you want to Install Desktop Software or Reboot into Base System?"
    echo ""
    echo "Please select a Desktop by number"
    echo "  1) LXQt"
    echo "  2) KDE Plasma"
    echo "  3) Xfce"
    echo "  4) Mate" 
    echo "  5) Cinnamon"
    echo "  6) Gnome"
    echo "  7) Deepin"
    echo "  8) Budgie"
    echo "  9) LXDE"
    echo "  R) REBOOT into Base System"
    echo
    while true; do
        read -r -p "Please enter an option: " enter;
            case $enter in
                [1]* )
                    pacstrap /mnt lxqt openbox obconf-qt pcmanfm-qt lxqt-sudo sddm breeze-icons qterminal kwrite networkmanager-qt qbittorrent pavucontrol-qt quodlibet kdenlive k3b xarchiver galculator polkit-qt5 packagekit-qt5 && DM=sddm; break;;
                [2]* )
                    pacstrap /mnt plasma sddm breeze-icons kwrite qbittorrent pavucontrol-qt quodlibet print-manager sweeper dolphin kdenlive k3b ark konsole gwenview okular kcalc packagekit-qt5 kvantum-qt5 latte-dock && DM=sddm; break;;
                [3]* ) 
                    pacstrap /mnt xfce4 xfce4-goodies lightdm lightdm-gtk-greeter galculator transmission-gtk pavucontrol xfburn asunder libburn libisofs libisoburn quodlibet xarchiver arc-gtk-theme arc-icon-theme gtk-engine-murrine adapta-gtk-theme polkit-gnome gnome-disk-utility gufw gnome-packagekit && DM=lightdm; break;;
                [4]* )
                    pacstrap /mnt mate mate-extra mate-applet-dock lightdm lightdm-gtk-greeter adapta-gtk-theme arc-gtk-theme arc-icon-theme gtk-engine-murrine transmission-gtk brasero asunder quodlibet gnome-disk-utility gufw mate-polkit gnome-packagekit && DM=lightdm; break;;
                [5]* )
                    pacstrap /mnt cinnamon cinnamon-translations gnome-terminal adwaita-icon-theme adapta-gtk-theme arc-gtk-theme arc-icon-theme gtk-engine-murrine gnome-keyring lightdm lightdm-gtk-greeter nemo nemo-share xed file-roller nemo-fileroller tmux tldr gparted transmission-gtk brasero asunder quodlibet pitivi gnome-disk-utility gufw polkit-gnome gnome-packagekit evince viewnior && DM=lightdm; break;;
                [6]* )
                    pacstrap /mnt gnome gnome-extra gdm && DM=gdm; break;;
                [7]* )
                    pacstrap /mnt deepin deepin-extra lightdm lightdm-gtk-greeter && DM=lightdm; break;;
                [8]* )
                    pacstrap /mnt budgie-desktop lightdm lightdm-gtk-greeter network-manager-applet gnome && DM=lightdm; break;;
                [9]* )
                    pacstrap /mnt lxde lightdm lightdm-gtk-greeter xdg-user-dirs && DM=lightdm; break;;
                [Rr]* )
                    reboot; break;;
                    * )
                    echo "Please enter a valid Option.";;
    
            esac
    done
    clear
}
#
#
softmenu () { while true
do
    clear
    echo ""
    echo "Do you want to install SOFTWARE CATEGORIES?"
    echo ""
    echo " 1) General"
    echo " 2) Multimedia"
    echo " 3) Networking"
    echo " 4) Fonts & Themes"
    echo " 5) Printing"
    echo " 6) Finish install"
    echo ""
    read -p "please select the categories you want: " choice
    case $choice in
        1 ) instgen ;;
        2 ) instmulti ;;
        3 ) instnet ;;
        4 ) instfonttheme ;;
        5 ) isntprint ;;
        6 ) finish ; break ;;
        * ) echo "Please make a valid choice:" ;;
    esac
done
}
#
#
if [ -d /sys/firmware/efi ]; then
    welcome
    keyboard
    timedate
    tzlocale
    partitions
    partpick
    hostusrpass
    homequest
    setmirrors
    instbase
    fstab
    setmirrors2
    setusrpriv
    hostlocale
    bootload
    instdesk
    enabserv
    instxorg
    softmenu
else
    welcomeb
    keyboard
    timedate
    tzlocale
    partitionsb
    partpickb
    hostusrpass
    homequestb
    setmirrors
    instbase
    fstab
    setmirrors2
    setusrpriv
    hostlocale
    bootloadb
    instdesk
    enabserv
    instxorg
    softmenu
fi
#
#
#
#
#   "_____________________________________________"
#   "|                DISCLAIMER                 |"
#   "_____________________________________________"
#   "| You use this software at your own risk.   |"
#   "| No responsability accepted by Neil Harvey |"
#   "| for any damage to your computer, or loss  |"
#   "| of any data.                              |"
#   "_____________________________________________"
