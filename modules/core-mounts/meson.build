order = '99'
module = 'core-mounts'

instdir = modulesdir / '@0@@1@'.format(order, module)

install_data(
        'the-tool',
        'the-modeenv',
        install_dir : instdir,
        install_mode: 'rwxr-xr-x',
)

install_data(
        'module-setup.sh',
        'populate-writable.service',
        'the-tool.service',
        'sysroot.mount',
        'sysroot-writable.mount',
        'sysroot-usr-lib-modules.mount',
        'sysroot-usr-lib-firmware.mount',
        install_dir : instdir,
)
