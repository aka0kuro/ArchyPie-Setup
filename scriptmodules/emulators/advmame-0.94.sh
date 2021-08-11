#!/usr/bin/env bash

# This file is part of the ArchyPie project.
#
# Please see the LICENSE file at the top-level directory of this distribution.

rp_module_id="advmame-0.94"
rp_module_desc="AdvanceMAME v0.94.0"
rp_module_help="ROM Extension: .zip\n\nCopy your AdvanceMAME roms to either $romdir/mame-advmame or\n$romdir/arcade"
rp_module_licence="GPL2 https://raw.githubusercontent.com/amadvance/advancemame/master/COPYING"
rp_module_repo="file $__archive_url/advancemame-0.94.0.tar.gz"
rp_module_section="opt"
rp_module_flags="!mali !kms"

function depends_advmame-0.94() {
    local depends=(sdl)
    getDepends "${depends[@]}"
}

function sources_advmame-0.94() {
    downloadAndExtract "$md_repo_url" "$md_build" --strip-components 1
    _sources_patch_advmame-1.4
}

function build_advmame-0.94() {
    ./configure CFLAGS="$CFLAGS -fsigned-char -fno-stack-protector" LDFLAGS="-s -lm -Wl,--no-as-needed" --prefix="$md_inst"
    make clean
    make
}

function install_advmame-0.94() {
    make install
}

function configure_advmame-0.94() {
    # move any old configuration file
    if [[ -f "$md_conf_root/mame-advmame/advmame-0.94.0.rc" ]]; then
        mv "$md_conf_root/mame-advmame/advmame-0.94.0.rc" "$md_conf_root/mame-advmame/advmame-0.94.rc"
    fi

    # remove old emulators.cfg entries
    delEmulator advmame-0.94.0 mame-advmame
    delEmulator advmame-0.94.0 arcade

    configure_advmame
}
