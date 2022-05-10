#!/bin/bash

set -eu

snap download pc-kernel --channel=22/edge
unsquashfs -d pc-kernel pc-kernel*.snap

config="$(cd "pc-kernel" && echo config-*-generic)"
kernelver="${config#config-}"

objcopy -O binary -j .linux pc-kernel/kernel.efi kernel.img-"${kernelver}"

# There is a bug in dracut that does not allow to not have cmdline
# so we provide "dummy". We should submit a patch.
dracut                                                          \
    --no-hostonly                                               \
    --zstd                                                      \
    --uefi                                                      \
    --modules core                                              \
    --kmoddir "${PWD}/pc-kernel/lib/modules/${kernelver}"       \
    --fwdir "${PWD}/pc-kernel/lib/firmware"                     \
    --uefi-stub /usr/lib/systemd/boot/efi/linuxx64.efi.stub     \
    --kernel-image "${PWD}/kernel.img-${kernelver}"             \
    --kernel-cmdline "dummy"                                    \
    kernel.efi-"${kernelver}" "${kernelver}"

# The systemd kernel EFI stub does not allow cmdline from grub if it
# is set in the binary, so we remove it.
objcopy --remove-section .cmdline kernel.efi-"${kernelver}"

# FIXME: the systemd package should probably add .sbat section in the
# stub.
if ! [ -r sbat.txt ]; then
    systemd_version="$(pkg-config --modversion systemd)"
    systemd_package_version="$(dpkg-query --show --showformat='${Version}' systemd)"
    cat <<EOF >sbat.txt
sbat,1,SBAT Version,sbat,1,https://github.com/rhboot/shim/blob/main/SBAT.md
systemd,1,The systemd Developers,systemd,${systemd_version},https://www.freedesktop.org/wiki/Software/systemd
systemd.ubuntu,1,Ubuntu,systemd,${systemd_package_version},https://bugs.launchpad.net/ubuntu/
EOF
fi

objcopy                                                         \
    --add-section .sbat=sbat.txt                                \
    --set-section-flags .sbat=contents,alloc,load,readonly,data \
    --change-section-vma .sbat=0x50000                          \
    --set-section-alignment .sbat=4096                          \
    kernel.efi-"${kernelver}"

if ! [ -r PkKek-1-snakeoil.key ]; then
    wget https://raw.githubusercontent.com/snapcore/core-initrd/main/snakeoil/PkKek-1-snakeoil.key
fi
if ! [ -r PkKek-1-snakeoil.pem ]; then
    wget https://raw.githubusercontent.com/snapcore/core-initrd/main/snakeoil/PkKek-1-snakeoil.pem
fi

sbsign                                          \
    --key PkKek-1-snakeoil.key                  \
    --cert PkKek-1-snakeoil.pem                 \
    --output kernel.efi-"${kernelver}"          \
    kernel.efi-"${kernelver}"

cp kernel.efi-"${kernelver}" pc-kernel/kernel.efi
snap pack pc-kernel
