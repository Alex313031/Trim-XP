cd ~/naraeon-ssd/ezerase/liveboot
sudo cp -r /mnt/windows/bg.jpg chroot/root/bg.jpg
mkdir chroot/etc/ezerase
sudo cp -r /mnt/windows/source/*.py chroot/etc/ezerase/
mkdir chroot_release
sudo cp -r chroot/* chroot_release/
sudo mount -o bind /dev chroot_release/dev && sudo cp /etc/resolv.conf chroot_release/etc/resolv.conf
sudo chroot chroot_release
