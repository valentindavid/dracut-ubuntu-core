check() {
    return 255
}

depends() {
    echo base dm crypt systemd systemd-initrd udev-rules busybox core-modules core-mounts core-bootchart core-journald-console core-recovery-chooser-trigger core-shell
}
