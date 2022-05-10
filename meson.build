project('dracut-ubuntu-core')

dracut = dependency('dracut')
modulesdir = dracut.get_pkgconfig_variable('dracutmodulesdir')

subdir('modules/core')
subdir('modules/core-bootchart')
subdir('modules/core-default-hostname')
subdir('modules/core-journald-console')
subdir('modules/core-modules')
subdir('modules/core-mounts')
subdir('modules/core-recovery-chooser-trigger')
subdir('modules/core-shell')
subdir('modules/core-snap-bootstrap')

subdir('modules/core-feature-server')

pkgdatadir = join_paths(get_option('prefix'),
                        get_option('datadir'),
                        meson.project_name())

configure_file(
    input : 'dracut.conf.in',
    output : 'dracut.conf',
    configuration : {
        'pkgdatadir': pkgdatadir
    },
    install_dir : pkgdatadir,
)

install_data(
        'snakeoil/PkKek-1-snakeoil.pem',
        'snakeoil/PkKek-1-snakeoil.key',
        install_dir : pkgdatadir / 'snakeoil',
)
