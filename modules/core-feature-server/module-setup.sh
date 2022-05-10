check() {
    return 255
}

depends() {
    return 0
}

install() {
    conf=ubuntu-core-server.conf
    instmods $(cat "${moddir}/${conf}" | grep -v "^#")
    inst_simple "${moddir}/${conf}" "usr/lib/modules-load.d/${conf}"
}
