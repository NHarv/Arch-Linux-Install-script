#!/bin/bash

# This script was inspired by Eznix's Arch Linux Install Guides
# on his Youtube Channel https://www.youtube.com/channel/UCQrSHD-tv9nkssrD4nNGcMw/videos
# You can exit the script after Base and Bootloader install, or you can continue to
# installing a desktop environment and choosing to install some software categories.

echo "Choose Keyboard Layout eg uk, us..."
echo
echo
read -p '           Keyboard Layout?: ' KEYVAR
loadkeys "${$KEYVAR}"
lsblk
echo
echo
echo "Which Hard Drive do do whant to use..."
echo
echo
read -p '                     Drive?: ' DRIVEVAR
echo
cfdisk /dev/"${DRIVEVAR}"
clear
echo
lsblk
echo
read -p '      EFI partition number?: ' EFIVAR
echo
read -p '     Swap Partition number?: ' SWAPVAR
echo
read -p '   System Partition number?: ' SYSTEMVAR
echo
read -p '     Home Partition number?: ' HOMEVAR
echo
read -p '                  Hostname?: ' HOSTVAR
echo
read -p '                  Username?: ' USERVAR
echo
read -p '                  Password?: ' PASSWDVAR
echo
read -p '           Repeat Password?: ' PASSWD2VAR
echo
[[ "${PASSWDVAR}" == "${PASSWD2VAR}" ]] || ( echo "Passwords did not match"; exit 1; )
clear
echo
TZVAR=$(tzselect | tail -n1 )
clear
echo
echo '              AG    NZ'
echo '              AU    PH'
echo '              BW    SC'
echo '              CA    SG'
echo '              DK    US'
echo '              GB    ZA'
echo '              HK    ZW'
echo '              IE      '
echo
read -p ' Select a Locale from the list above: ' LOCALEVAR
echo
echo
echo   ================Thank you "${USERVAR}"================
clear
echo
echo "        Formatting Partitions..."
echo
sleep 1
while true; do
	read -r -p "Do you want to format your Home partition (y/n) " ans;
	case $ans in
		[yY][eE][sS]|[yY]* )
			mkfs.fat -F32 /dev/"${DRIVEVAR}""${EFIVAR}" && mkfs.ext4 /dev/"${DRIVEVAR}""${SYSTEMVAR}" && mkfs.ext4 /dev/"${DRIVEVAR}""${HOMEVAR}"; break;;
		[nN][oO]|[nN]* )
			mkfs.fat -F32 /dev/"${DRIVEVAR}""${EFIVAR}" && mkfs.ext4 /dev/"${DRIVEVAR}""${SYSTEMVAR}"; break;;
        * ) 
			echo "Please Answer Yes or No.";;
	esac
done
mkswap /dev/"${DRIVEVAR}""${SWAPVAR}"
swapon /dev/"${DRIVEVAR}""${SWAPVAR}"
clear
echo
echo "     Mounting Partitions..."
sleep 1
mount /dev/"${DRIVEVAR}""${SYSTEMVAR}" /mnt
mkdir -p /mnt/boot/EFI
mount /dev/"${DRIVEVAR}""${EFIVAR}" /mnt/boot/EFI
mkdir /mnt/home
mount /dev/"${DRIVEVAR}""${HOMEVAR}" /mnt/home
echo
echo
echo
echo "     Time and Date setup..."
sleep 1
timedatectl set-ntp true
echo
echo
echo
echo "     Setting up Mirrors and Repositories..."
echo
sleep 1
pacman -Syy
pacman -Sy archlinux-keyring --noconfirm
pacman -Sy reflector --noconfirm
reflector --latest 50 --protocol http --protocol https --sort rate --save /etc/pacman.d/mirrorlist
clear
echo
echo "     Installing Base system..."
echo
sleep 3
pacstrap /mnt base base-devel linux linux-firmware sysfsutils usbutils e2fsprogs dosfstools mtools inetutils netctl device-mapper cryptsetup nano less lvm2 dialog wpa_supplicant --noconfirm
clear
echo
echo "     Generating fstab..."
sleep 3
genfstab -U /mnt >> /mnt/etc/fstab
cp archinstallaur.sh /mnt
echo
echo "Setting up Mirrors and Repositories..."
echo
sleep 3
arch-chroot /mnt pacman -Syy
arch-chroot /mnt pacman -Sy reflector --noconfirm
arch-chroot /mnt reflector --latest 50 --protocol http --protocol https --sort rate --save /etc/pacman.d/mirrorlist
clear
echo
echo "Installing and Setting up Bootloader..."
echo
sleep 3
arch-chroot /mnt pacman -Sy grub efibootmgr os-prober --noconfirm
arch-chroot /mnt grub-install --target=x86_64-efi  --bootloader-id=grub_uefi --recheck
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
arch-chroot /mnt mkinitcpio -p linux
clear
echo
echo "Adding User..."
arch-chroot /mnt useradd -m -g users -G wheel,audio,video,storage,power,input,optical,sys,log,network,floppy,scanner,rfkill,lp,adm -s /bin/bash $USERVAR
echo
arch-chroot /mnt echo ""${USERVAR}":"${PASSWDVAR}"" | chpasswd --root /mnt
arch-chroot /mnt echo "root:"${PASSWDVAR}"" | chpasswd --root /mnt
clear
echo
echo "setting up Sudo Priverlages..."
sleep 1
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /mnt/etc/sudoers
clear
echo
echo "Setting up Hostname and Locales..."
echo
sleep 3
echo "${HOSTVAR}" > /mnt/etc/hostname
echo 127.0.0.1	localhost >> /mnt/etc/hosts
echo ::1		localhost >> /mnt/etc/hosts
echo 127.0.1.1	"${HOSTVAR}".localdomain	"${HOSTVAR}" >> /mnt/etc/hosts
echo en_"${LOCALEVAR}".UTF-8 UTF-8 >> /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
echo LANG=en_"${LOCALEVAR}".UTF-8 >> /mnt/etc/locale.conf
echo LC_COLLATE=C >> /mnt/etc/locale.conf
export LANG=en_"${LOCALEVAR}".UTF-8
echo KEYMAP="${KEYVAR}" > /mnt/etc/vconsole.conf
ln -sf /usr/share/zoneinfo/"${TZVAR}" /mnt/etc/localtime
arch-chroot /mnt hwclock --systohc --utc
clear
echo "Do you want to Install Desktop Software or Reboot into Base System?"
echo
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
				pacstrap /mnt lxde lightdm lightdm-gtk-greeter && DM=lightdm; break;;
			[Rr]* )
				reboot; break;;
				* )
				echo "Please enter a valid Option.";;
  
		esac
done
clear
echo
arch-chroot /mnt systemctl enable "${DM}"
echo
echo "Installing Xorg..."
echo
sleep 3
pacstrap /mnt xorg xorg-apps xorg-server xorg-drivers xorg-xkill xorg-xinit xterm mesa --noconfirm
clear
sleep 3
echo
while true; do
	read -r -p "Do you want to Install General Software (y/n) " ans;
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
echo
while true; do
	read -r -p "Do you want to Install Multimedia Software (y/n) " ans;
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
echo
while true; do
	read -r -p "Do you want to Install Networking Software (y/n) " ans;
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
echo
while true; do
	read -r -p "Do you want to Install Fonts and Themes (y/n) " ans;
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
echo
while true; do
	read -r -p "Do you want to Install Printing Software (y/n) " ans;
	case $ans in
		[yY][eE][sS]|[yY]* )
			pacstrap /mnt --needed system-config-printer foomatic-db foomatic-db-engine gutenprint hplip simple-scan cups cups-pdf cups-filters cups-pk-helper ghostscript gsfonts python-pillow python-pyqt5 python-pip python-reportlab --noconfirm && arch-chroot /mnt systemctl enable org.cups.cupsd.service; break;;
		[nN][oO]|[nN]* )
			break;;
        * ) 
			echo "Please Answer Yes or No.";;
	esac
done
pacstrap /mnt pavucontrol-qt --noconfirm
echo
wget https://raw.githubusercontent.com/NHarv/Arch-Linux-Install-script/master/archinstallaur.sh
echo
cp archinstallaur.sh /mnt/home/"${USERVAR}"
clear
echo
echo
echo "==========FINISHED=========="
echo
echo
echo "==========REBOOTING========="
sleep 5
echo
reboot
