#!/usr/bin/bash
echo Welcome To Arch
losdkeys jp106
setfont lat9w-16
timedatectl set-ntp true
echo o y n 1 (enter) +512M EF00 n (enter 4) w y
gdisk /deb/sdx
mkfs.vfat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
mount /dev2/sda2 /mnt 
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot
cat /etc/pacman.d/mirrorlist | sed 5iServer = http://ftp.jaist.ac.jp/pub/Linux/ArchLinux/$repo/os/$arch > /etc/pacman.d/mirrorlist
pacman -Syy
pactrap /mnt base base-devel
genfstab -U >> /mnt/etc/fstab
cat /mnt/etc/fstab
arch-chroot /mnt /bin/bash
cat /etc/locale.conf |sed 24ienUS.UTF-8\nja_.UTF-8 > /etc/locale.conf
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=enUS.UTF-8
echo KEYMAP=jp106 >> /etc/locale.conf
echo FONT=lat9w-16
ln -fs /usr/share/zoneinfo/Asia/Tokyo /etc/localetime
hwclock --systohc --utc
echo localhost > /etc/hostname
echo "127.0.0.1     localhost" "::1       localhost" "127.0.0.1     archlinux.localdomain archlinux"
systemctl enable systemd-networkd
systemctl enable systemd-resolved
echo root password setting
passwd
bootctl --path=/boot install
bootctl update
echo "default arch" "timeout 5" "editor 0" >> /boot/loader/loader.conf
back=`blkid -s PARTUUID -o value /dev/sda2`
echo "title Arch Linux" "linux /vmlinuz-linux" "initrd         /initramfs-linux.img" "options        root=PARTUUID="$back" rw"
exit
umount -R /mnt
shutdown -h now