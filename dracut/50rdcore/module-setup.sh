#!/bin/bash

install_and_enable_unit() {
    unit="$1"; shift
    target="$1"; shift
    inst_simple "$moddir/$unit" "$systemdsystemunitdir/$unit"
    # note we `|| exit 1` here so we error out if e.g. the units are missing
    # see https://github.com/coreos/fedora-coreos-config/issues/799
    systemctl -q --root="$initdir" add-requires "$target" "$unit" || exit 1
}

install() {
    inst_simple "$moddir/rdcore" "/usr/bin/rdcore"

    inst_simple "$moddir/coreos-installer" "/usr/bin/coreos-installer"

    inst_simple "$moddir/coreos-installer-generator" \
        "$systemdutildir/system-generators/coreos-installer-generator"

    inst_script "$moddir/coreos-installer-service" \
        "/usr/libexec/coreos-installer-service"

    inst_script "$moddir/coreos-installer-disable-device-auto-activation" \
        "/usr/libexec/coreos-installer-disable-device-auto-activation"

    install_and_enable_unit "coreos-installer.service" \
        "default.target" 

    install_and_enable_unit "coreos-installer-reboot.service" \
        "default.target" 

#    install_and_enable_unit "coreos-installer-noreboot.service" \
#        "basic.target" 
#    inst_simple "$moddir/coreos-installer-reboot.service" \
#        "$systemdsystemunitdir/coreos-installer-reboot.service"
#    inst_simple "$moddir/coreos-installer-noreboot.service" \
#        "$systemdsystemunitdir/coreos-installer-noreboot.service"
#
#    inst_simple "$moddir/coreos-installer.target" \
#        "$systemdsystemunitdir/coreos-installer.target"
#
#    inst_simple "$moddir/coreos-installer-pre.target" \
#        "$systemdsystemunitdir/coreos-installer-pre.target"
#
#    inst_simple "$moddir/coreos-installer-post.target" \
#        "$systemdsystemunitdir/coreos-installer-post.target"
}
