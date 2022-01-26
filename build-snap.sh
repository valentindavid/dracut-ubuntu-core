#!/bin/bash

set -eux

container=pc-kernel-builder
image=images:ubuntu/jammy
setup_snapshot=snapcraft_installed

if ! lxc restore "${container}" ${setup_snapshot}; then
    lxc delete --force "${container}" || true
    lxc launch ${image} "${container}"
    lxc exec "${container}" -- apt-get update
    lxc exec "${container}" -- apt-get dist-upgrade -y
    lxc exec "${container}" -- apt-get autoremove -y
    lxc exec "${container}" -- apt-get install -y --no-install-recommends snapd
    lxc exec "${container}" -- snap install snapcraft --classic --channel=latest/stable
    lxc stop "${container}"
    lxc snapshot "${container}" ${setup_snapshot}
fi

lxc start "${container}" || true
lxc file push "${PWD}" "${container}/home/ubuntu/" -r
srcdir="/home/ubuntu/$(basename "${PWD}")"
lxc exec --cwd "${srcdir}" "${container}" -- snapcraft --destructive-mode
snap_file="$(lxc exec --cwd "${srcdir}" "${container}" -- bash -c 'ls pc-kernel_*.snap')"
lxc file pull "${container}${srcdir}/${snap_file}"  .
