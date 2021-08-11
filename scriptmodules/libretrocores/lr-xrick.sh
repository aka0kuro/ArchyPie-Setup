#!/usr/bin/env bash

# This file is part of the ArchyPie project.
#
# Please see the LICENSE file at the top-level directory of this distribution.

rp_module_id="lr-xrick"
rp_module_desc="Rick Dangerous Libretro Core"
rp_module_help="Install the xrick data.zip to $romdir/ports/xrick/data.zip"
rp_module_licence="GPL https://raw.githubusercontent.com/libretro/xrick-libretro/master/README"
rp_module_repo="git https://github.com/libretro/xrick-libretro.git master"
rp_module_section="opt"

function sources_lr-xrick() {
    gitPullOrClone
}

function build_lr-xrick() {
    make clean
    make
    md_ret_require="$md_build/xrick_libretro.so"
}

function install_lr-xrick() {
    md_ret_files=(
        'README'
        'README.md'
        'xrick_libretro.so'
    )
}

function configure_lr-xrick() {
    setConfigRoot "ports"

    addPort "$md_id" "xrick" "XRick" "$md_inst/xrick_libretro.so" "$romdir/ports/xrick/data.zip"

    [[ "$md_mode" == "remove" ]] && return

    ensureSystemretroconfig "ports/xrick"
}
