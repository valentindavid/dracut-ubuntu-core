check() {
    return 255
}

depends() {
    return 0
}

install() {
    inst_simple /usr/lib/snapd/snap-bootstrap
    inst_simple /usr/lib/snapd/info
}
