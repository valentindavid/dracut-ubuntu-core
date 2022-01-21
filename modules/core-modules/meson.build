order = '99'
module = 'core-modules'

instdir = modulesdir / '@0@@1@'.format(order, module)

install_data(
        'module-setup.sh',
        'ubuntu-core-initramfs.conf',
        'ubuntu-core-server.conf',
        install_dir : instdir,
)
