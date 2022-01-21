check() {
    return 255
}

depends() {
    return 0
}

install() {
    inst_simple "${systemdsystemunitdir}"/emergency.service

    inst_simple "${moddir}/emergency.conf" "${systemdsystemunitdir}"/emergency.service.d/core-override.conf

    inst_simple "${moddir}/debug-shell.conf" "${systemdsystemunitdir}"/debug-shell.service.d/core-override.conf

    inst_simple "${moddir}/emergency-target.conf" "${systemdsystemunitdir}"/emergency.target.d/core-override.conf
}
