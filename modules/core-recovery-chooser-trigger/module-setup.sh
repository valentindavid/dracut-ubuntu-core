check() {
    return 255
}

depends() {
    echo core-snap-bootstrap
}

install() {
    inst_simple "${systemdsystemunitdir}"/snapd.recovery-chooser-trigger.service
    inst_simple "${moddir}/survive-switch-root.conf" "${systemdsystemunitdir}"/snapd.recovery-chooser-trigger.service.d/survive-switch-root.conf

    systemctl -q --root "$initdir" add-wants basic.target snapd.recovery-chooser-trigger.service
}
