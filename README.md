Neils Install Scrips instructions

1, Boot from archiso.

2, If you need to connect to WiFi, run this command.

```
wifi-menu
```

3, Download the script.

```
pacman -Syy git
git clone https://github.com/NHarv/Arch-Linux-Install-script.git
cd Arch-Linux-Install-script
./archinstall.sh
```

4, Run script, archinstall.sh

```
./archinstall.sh
```

5, Partition the drive.

```
sdx1 EFI system partition 300M
sdxx 2 x memory Swap Partition
sdxx Root partition 20G
sdxx Home partition remainder of drive.
'x' being your drive letter & Partition Number
```

6, If you want to setup AUR and install Pamac (Package Manager) (optional)

Open terminal

```
./archinstallaur.sh
```


FINISHED
