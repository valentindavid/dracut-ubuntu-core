check() {
    return 255
}

depends() {
    return 0
}

install() {
    echo "DEFAULT_HOSTNAME=ubuntu" >>"${initdir}"/usr/lib/initrd-release
}
