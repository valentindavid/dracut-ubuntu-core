#!/bin/bash

set -eu

snap download pc-kernel --channel=22/edge
unsquashfs -d pc-kernel pc-kernel*.snap

config="$(cd "pc-kernel" && echo config-*-generic)"
kernelver="${config#config-}"

objcopy -O binary -j .linux pc-kernel/kernel.efi kernel.img-"${kernelver}"

mkdir -p layout/lib
ln -s "${PWD}/pc-kernel/modules" layout/lib/modules
ln -s "${PWD}/pc-kernel/firmware" layout/lib/firmware

# There is a bug in dracut that does not allow to not have cmdline
# so we provide "dummy". We should submit a patch.
dracut                                                  \
    --conf /usr/share/dracut-ubuntu-core/dracut.conf    \
    --kmoddir "${PWD}/layout/lib/modules/${kernelver}"  \
    --fwdir "${PWD}/layout/lib/firmware"                \
    --kernel-image "${PWD}/kernel.img-${kernelver}"     \
    kernel.efi-"${kernelver}" "${kernelver}"

# FIXME: re-signing is not needed once the 2 next FIXMEs are
# fixed
sbattach --remove kernel.efi-"${kernelver}"

# FIXME: This is not needed from dracut 052
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

# FIXME: re-signing is not needed once the 2 previous FIXMEs are
# fixed
key="/usr/share/dracut-ubuntu-core/snakeoil/PkKek-1-snakeoil.key"
cert="/usr/share/dracut-ubuntu-core/snakeoil/PkKek-1-snakeoil.pem"
sbsign                                          \
    --key "${key}"                              \
    --cert "${cert}"                            \
    --output kernel.efi-"${kernelver}"          \
    kernel.efi-"${kernelver}"


cp kernel.efi-"${kernelver}" pc-kernel/kernel.efi
snap pack pc-kernel
