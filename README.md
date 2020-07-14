Neil's Install Scripts instructions

1, Boot from archiso.

2, If you need to connect to WiFi, run this command.

```
wifi-menu
```

3, Download the script.

```
wget https://raw.githubusercontent.com/NHarv/Arch-Linux-Install-script/master/archinstall.sh
```

4, Run the script

```
./archinstall.sh
```

5, Partition the drive.

```
If UEFI use GPT if BIOS use DOS Partition table with no EFI partition.
sdx1 EFI system partition 300M
sdxx 2 x memory Swap Partition
sdxx Root partition 20G
sdxx Home partition remainder of drive.
'x' being your drive letter & Partition Number
```

6, If you want to setup AUR and install Pamac (Package Manager) (optional)

Open terminal

```
bash archinstallaur.sh
```

FINISHED

Or Download the Live ISO from my Github page.

1, Boot the live ISO

2, Connect to the internet.

3, Click the icon on the far right of the dock, scroll to the bin folder and select open in terminal.

4, Run the script.

```
./nharvarch.sh
```

