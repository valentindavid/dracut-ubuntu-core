dracut-ubuntu-core
==================

This is an early experiment for using dracut instead of core-initrd to
generate an initramfs for Ubuntu Core.

Here are the steps to build that initramfs.  On a
machine/container/chroot with matching version of Ubuntu than the
target Ubuntu Core version:
 - Build this dracut-ubuntu-core .deb package and install it
 - Install lz4 sbsigntool xdelta3
 - Get `PkKek-1-snakeoil.{key,pem}` from core-initrd or your own keys
 - Run `build-initrd.sh` or manually run the commands
 - This will have created a snap of pc-kernel
 - Build an image with ubuntu-image using that snap
