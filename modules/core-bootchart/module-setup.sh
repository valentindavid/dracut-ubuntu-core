check() {
    return 255
}

depends() {
    return 0
}

install() {
    inst_simple "${systemdsystemunitdir}"/systemd-bootchart.service
    inst_simple "${moddir}/systemd-bootchart-quit.service" "${systemdsystemunitdir}"/systemd-bootchart-quit.service
    inst_simple ubuntu-core.conf "${systemdutildir}/bootchart.conf.d/ubuntu-core.conf"

    systemctl -q --root "$initdir" add-wants sysinit.target systemd-bootchart.service
    systemctl -q --root "$initdir" add-wants initrd-switch-root.target systemd-bootchart-quit.service
}
