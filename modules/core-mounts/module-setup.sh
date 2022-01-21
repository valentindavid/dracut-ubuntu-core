check() {
    return 255
}

depends() {
    echo core-snap-bootstrap dm crypt
}

install() {
    inst_binary systemd-mount
    inst_binary unsquashfs
    _mount="$(find_binary mount)"
    if [ -n "${_mount}" ] && [ -L "${initdir}${_mount}" ]; then
        # Work-around busybox
        rm "${initdir}${_mount}"
    fi
    inst_binary mount
    inst_binary chroot /usr/bin/chroot

    rm "${initdir}${systemdutildir}/system-generators/systemd-gpt-auto-generator"

    inst_simple "${moddir}/the-modeenv" "/usr/lib/the-modeenv"
    inst_simple "${moddir}/the-tool" "/usr/lib/the-tool"

    for i in                                    \
        populate-writable.service               \
        the-tool.service                        \
        sysroot.mount                           \
        sysroot-writable.mount                  \
        sysroot-usr-lib-firmware.mount          \
        sysroot-usr-lib-modules.mount
    do
        inst_simple "${moddir}/${i}" "${systemdsystemunitdir}/${i}"
    done


    systemctl -q --root "$initdir" add-wants basic.target populate-writable.service the-tool.service
    systemctl -q --root "$initdir" add-wants initrd-root-fs.target sysroot.mount
    systemctl -q --root "$initdir" add-wants initrd-fs.target sysroot-writable.mount sysroot-usr-lib-firmware.mount sysroot-usr-lib-modules.mount
}
