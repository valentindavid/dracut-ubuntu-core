#!/bin/bash

set -eu

container=jammy-initrd-builder
image=images:ubuntu/jammy

lxc delete --force ${container} || true
lxc launch ${image} ${container}

lxc exec ${container} -- apt-get update
lxc exec ${container} --env DEBIAN_FRONTEND=noninteractive -- apt-get -y upgrade
lxc exec ${container} --env DEBIAN_FRONTEND=noninteractive -- apt-get install -y --no-install-recommends devscripts debhelper-compat build-essential meson pkg-config dracut

projectdir="/root/$(basename "${PWD}")"
lxc file push -r "${PWD}" "${container}/root"

lxc exec ${container} --cwd "${projectdir}" -- debuild -us -uc

lxc exec ${container} --env DEBIAN_FRONTEND=noninteractive -- apt-get install -y --no-install-recommends /root/dracut-ubuntu-core_0.1_amd64.deb

lxc exec ${container} --env DEBIAN_FRONTEND=noninteractive -- apt-get install -y --no-install-recommends lz4 sbsigntool xdelta3 wget

lxc exec ${container} --cwd "${projectdir}" -- bash -x build-initrd.sh

lxc exec ${container} --cwd "${projectdir}" -- mkdir -p result
lxc exec ${container} --cwd "${projectdir}" -- bash -c 'mv pc-kernel_*_*.snap result/'

rm -rf result/
lxc file pull -r "${container}${projectdir}/result/" .
