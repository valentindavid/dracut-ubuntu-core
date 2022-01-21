order = '99'
module = 'core-bootchart'

instdir = modulesdir / '@0@@1@'.format(order, module)

install_data(
        'module-setup.sh',
        'ubuntu-core.conf',
        'systemd-bootchart-quit.service',
        install_dir : instdir,
)
