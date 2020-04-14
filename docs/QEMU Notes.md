# QEMU Notes
This document has some useful commands and explanations that I have written while studying QEMU, and developed QEMU Reeves.
`notes.sh`
```sh
# This command creates a new disk to install to:
qemu-img create -f qcow2 debian-base.img 15G
# The qcow2 format allows zlib file compression (As opposed to the file "compression" of a raw disk
# with "holes", only writing used parts to the disk.), as well as snapshots. It's the format for
# QEMU, but can be exported with the qemu-nbd tool, or converted with qemu-img convert. The
# tradeoff of using this format is that it's less performant than the raw disk image.

qemu-system-x86_64 -machine pc,accel=kvm -cpu host -m 512M debian-9.9.0-amd64-xfce-CD-1.iso --enable-kvm
# This command specifies the installation media as the main raw hard disk image, but QEMU always
# complains about the format for it not being specified. I'm not really sure how I would
# specify the installer though.

# This is the final command I ended up with for running the installer.
qemu-system-x86_64 -machine pc,accel=kvm -cpu host -boot d -m 2G -hda debian-base.img -cdrom debian-9.9.0-amd64-xfce-CD-1.iso --enable-kvm

# This command creates a disk to record changes made to the base. The potential use for this would
# be running the installer, installing Debian to "debian-base.img", and not writing to that image
# from that point on. Therefore, we can derive images, like "debian-main.img", and still have the
# ability to start fresh. The issue of this in practice is that the base image becomes quickly
# outdated.
qemu-img create -f qcow2 -b debian-base.img debian-main.img 15G

# These commands create a bridge connection for use with QEMU. I never got this working, because
# there are somewhat significant complexities in setting up a bridge with a wireless connection.
nmcli c add type bridge ifname br0 con-name "QEMU Bridge" stp no
nmcli c add type bridge-slave ifname wlp37s0 con-name "Main Wireless Slave" master br0
```
`
fstab
`
```
# This is a filesystem table that I ripped from my Debian 10 QEMU installation. The main thing of
# interest is the shared folder.

# Debian root parition on the disk image.
UUID=91109490-7714-4510-b695-3b4a24f648d1 /                 ext4    errors=remount-ro                                           0 1
# Swap partition on the disk image.
UUID=a9501a38-5326-46ef-b427-3b811581df27 none              swap    sw                                                          0 0
# Shared directory on the 9p "share" tag. Don't halt the boot if not present, so that the VM can be
# started without the Plan 9 folder sharing being properly setup on the host.
share                                     /home/koopa/Share 9p      noauto,x-systemd.automount,nofail,x-systemd.mount-timeout=1 0 0
```