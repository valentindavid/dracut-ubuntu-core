check() {
    return 255
}

depends() {
    return 0
}

install() {
    for conf in                                 \
        ubuntu-core-initramfs.conf              \
        ubuntu-core-server.conf
    do
        instmods $(cat "${moddir}/${conf}" | grep -v "^#")
        inst_simple "${moddir}/${conf}" "usr/lib/modules-load.d/${conf}"
    done
}
