check() {
    return 255
}

depends() {
    echo core-snap-bootstrap
}

install() {
    inst_simple "${systemdsystemunitdir}"/snapd.recovery-chooser-trigger.service
    inst_simple "${moddir}/survive-switch-root.conf" "${systemdsystemunitdir}"/snapd.recovery-chooser-trigger.service.d/survive-switch-root.conf
    inst_simple "${moddir}/recovery-chooser-trigger-switch-root" /usr/lib/recovery-chooser-trigger-switch-root
    inst_simple "${moddir}/recovery-chooser-trigger-switchroot.service" "${systemdsystemunitdir}"/recovery-chooser-trigger-switchroot.service

    systemctl -q --root "$initdir" add-wants basic.target snapd.recovery-chooser-trigger.service
    systemctl -q --root "$initdir" add-wants initrd-switch-root.target recovery-chooser-trigger-switchroot.service
}
