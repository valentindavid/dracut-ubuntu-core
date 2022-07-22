order = '99'
module = 'core-recovery-chooser-trigger'

instdir = modulesdir / '@0@@1@'.format(order, module)

install_data(
        'recovery-chooser-trigger-switch-root',
        install_dir : instdir,
        install_mode: 'rwxr-xr-x',
)

install_data(
        'module-setup.sh',
        'survive-switch-root.conf',
        'recovery-chooser-trigger-switchroot.service',
        install_dir : instdir,
)
