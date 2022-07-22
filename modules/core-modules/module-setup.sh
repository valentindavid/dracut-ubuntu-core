check() {
    return 255
}

depends() {
    return 0
}

install() {
    conf=ubuntu-core-initramfs.conf
    instmods $(cat "${moddir}/${conf}" | grep -v "^#")
    inst_simple "${moddir}/${conf}" "usr/lib/modules-load.d/${conf}"

    # raspi USB OTG driver, needed for jammy
    instmods dwc2

    # All HID drivers should be available. This is for
    # recovery-chooser-trigger to be able to read keyboards.
    instmods =drivers/hid
}
