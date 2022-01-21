check() {
    return 255
}

depends() {
    return 0
}

install() {
    inst_simple journald-console "${systemdutildir}"/system-generators/journald-console
}
